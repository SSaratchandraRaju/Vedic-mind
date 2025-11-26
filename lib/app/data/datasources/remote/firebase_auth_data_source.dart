import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_data_source.dart';
import '../../models/user_model.dart';
import '../../models/auth_result_model.dart';
import '../../repositories/firestore_progress_repository.dart';

/// Firebase implementation of AuthDataSource
/// This can be easily replaced with other implementations (MongoDB, REST API, etc.)
///
/// NOTE: Firestore is currently disabled (commented out) to avoid billing requirements.
/// To enable Firestore:
/// 1. Enable billing in Firebase Console
/// 2. Create Firestore database
/// 3. Uncomment all lines marked with "// FIRESTORE:"
/// 4. Hot restart the app
class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static DateTime? _lastOtpRequestAt;
  static const Duration _otpThrottle = Duration(seconds: 60);
  static const bool _debugPhoneAuth = true; // Toggle verbose logs

  @override
  Future<AuthResultModel> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResultModel.failure('Google sign in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Create or update user in Firestore
      final user = await _createOrUpdateUser(userCredential.user!);

      return AuthResultModel.success(user);
    } catch (e) {
      return AuthResultModel.failure(
        'Failed to sign in with Google: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResultModel> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = await _createOrUpdateUser(userCredential.user!);
      return AuthResultModel.success(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'Failed to sign in: ${e.message}';
      }
      return AuthResultModel.failure(errorMessage);
    } catch (e) {
      return AuthResultModel.failure('An error occurred: ${e.toString()}');
    }
  }

  @override
  Future<AuthResultModel> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Immediately send verification email (non-blocking)
      final createdUser = userCredential.user;
      if (createdUser != null && !createdUser.emailVerified) {
        try {
          await createdUser.sendEmailVerification();
        } catch (e) {
          // ignore: avoid_print
          print('[EmailAuth][verification][send][error] $e');
        }
      }

      // Derive display name from email prefix and an initial placeholder as photoUrl
      final emailPrefix = email.split('@').first.trim();
      final derivedName = emailPrefix.isEmpty
          ? 'User'
          : (emailPrefix[0].toUpperCase() + emailPrefix.substring(1));
      final initial = derivedName[0].toUpperCase();
      try {
        await userCredential.user?.updateDisplayName(derivedName);
      } catch (e) {
        // ignore: avoid_print
        print('[EmailAuth][profile][displayName][warn] $e');
      }
      final user = await _createOrUpdateUser(
        userCredential.user!,
        overrideDisplayName: derivedName,
        overridePhotoInitial: initial,
      );
      return AuthResultModel.success(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'Failed to create account: ${e.message}';
      }
      return AuthResultModel.failure(errorMessage);
    } catch (e) {
      return AuthResultModel.failure('An error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      // Get user data from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        // Backfill required fields for model construction
        final nowIso = DateTime.now().toIso8601String();
        final merged = {
          ...data,
          'id': firebaseUser.uid,
          'email': (data['email'] as String?) ?? (firebaseUser.email ?? ''),
          'createdAt': (data['createdAt'] as String?) ?? nowIso,
        };
        // If fields were missing, persist them (fire-and-forget)
        if (data['email'] == null || data['createdAt'] == null) {
          try {
            await _firestore.collection('users').doc(firebaseUser.uid).set({
              'email': merged['email'],
              'createdAt': merged['createdAt'],
            }, SetOptions(merge: true));
          } catch (_) {}
        }
        return UserModel.fromJson(merged);
      }

      // If not in Firestore, create from Firebase user
      return _createOrUpdateUser(firebaseUser);
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _auth.currentUser != null;
  }

  @override
  Future<bool> updateUserProfile(UserModel user) async {
    try {
      // Update Firebase Auth profile
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(user.displayName);
        if (user.photoUrl != null) {
          await currentUser.updatePhotoURL(user.photoUrl);
        }
      }

      // Update user data in Firestore
      if (currentUser != null) {
        final updateData = {
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'ageCategory': user.ageCategory,
        }..removeWhere((key, value) => value == null);

    await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .set(updateData, SetOptions(merge: true));
      }

      // Note: Additional data (like ageCategory) can be stored in SharedPreferences
      // since Firestore is not available
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
    // Delete user data from Firestore
    await _firestore
      .collection('users')
      .doc(user.uid)
      .delete();

        // Delete Firebase Auth account
        await user.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // PHONE OTP METHODS -------------------------------------------------------
  @override
  Future<OtpSendResult> sendPhoneOtp(String phoneNumber) async {
    final start = DateTime.now();
    // Throttle to avoid device blocking (17010) and rate limits
    final now = DateTime.now();
    if (_lastOtpRequestAt != null && now.difference(_lastOtpRequestAt!) < _otpThrottle) {
      final remaining = _otpThrottle - now.difference(_lastOtpRequestAt!);
      if (_debugPhoneAuth) {
        // ignore: avoid_print
        print('[PhoneAuth][Throttle] Blocked request. nextAllowedIn=${remaining.inSeconds}s lastAt=${_lastOtpRequestAt!.toIso8601String()}');
      }
      return OtpSendResult.failure('Please wait ${remaining.inSeconds}s before requesting another OTP.');
    }
    _lastOtpRequestAt = now;

    try {
      // Normalize phone number (ensure starts with +)
      final cleaned = phoneNumber.replaceAll(RegExp(r'\s+'), '');
      final normalized = cleaned.startsWith('+') ? cleaned : '+$cleaned';

      if (_debugPhoneAuth) {
        // ignore: avoid_print
        print('[PhoneAuth] Requesting OTP for: $normalized at ${start.toIso8601String()}');
      }

      final completer = Completer<OtpSendResult>();
      final sw = Stopwatch()..start();

      await _auth.verifyPhoneNumber(
        phoneNumber: normalized,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (_debugPhoneAuth) {
            // ignore: avoid_print
            print('[PhoneAuth][verificationCompleted] provider=${credential.providerId} smsCodeLen=${credential.smsCode?.length ?? 0} elapsedMs=${sw.elapsedMilliseconds}');
          }
          try {
            final userCred = await _auth.signInWithCredential(credential);
            await _createOrUpdateUser(userCred.user!);
            if (!completer.isCompleted) {
              completer.complete(OtpSendResult.success('AUTO_VERIFIED'));
            }
          } catch (e) {
            if (_debugPhoneAuth) {
              // ignore: avoid_print
              print('[PhoneAuth][verificationCompleted][signInWithCredential][error] $e');
            }
            if (!completer.isCompleted) {
              completer.complete(OtpSendResult.failure('Auto verification sign-in failed: $e'));
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (_debugPhoneAuth) {
            // ignore: avoid_print
            print('[PhoneAuth][verificationFailed] code=${e.code} message=${e.message} elapsedMs=${sw.elapsedMilliseconds}');
            // Common hints
            if (e.code == 'too-many-requests') {
              print('[PhoneAuth][hint] Device or IP rate-limited (17010). Wait and try later or use another number/device.');
            } else if (e.code == 'quota-exceeded') {
              print('[PhoneAuth][hint] Project SMS quota exceeded.');
            } else if (e.code == 'invalid-app-credential' || e.code == 'app-not-authorized') {
              print('[PhoneAuth][hint] Invalid play integrity/app attestation (17028). Ensure SHA-1/SHA-256 and Play Integrity configured.');
            }
          }
          if (!completer.isCompleted) {
            completer.complete(OtpSendResult.failure(e.message ?? 'Verification failed'));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (_debugPhoneAuth) {
            final shortId = verificationId.length > 8 ? verificationId.substring(0, 8) : verificationId;
            // ignore: avoid_print
            print('[PhoneAuth][codeSent] verificationId=$shortId... resendToken=${resendToken ?? -1} elapsedMs=${sw.elapsedMilliseconds}');
          }
          if (!completer.isCompleted) {
            completer.complete(OtpSendResult.success(verificationId));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (_debugPhoneAuth) {
            final shortId = verificationId.length > 8 ? verificationId.substring(0, 8) : verificationId;
            // ignore: avoid_print
            print('[PhoneAuth][timeout] verificationId=$shortId... elapsedMs=${sw.elapsedMilliseconds}');
          }
          if (!completer.isCompleted) {
            completer.complete(OtpSendResult.success(verificationId));
          }
        },
      );

      final result = await completer.future;
      if (_debugPhoneAuth) {
        // ignore: avoid_print
        print('[PhoneAuth][result] type=${result.isSuccess ? 'success' : 'failure'} elapsedMs=${sw.elapsedMilliseconds}');
      }
      return result;
    } catch (e) {
      if (_debugPhoneAuth) {
        // ignore: avoid_print
        print('[PhoneAuth][exception] $e');
      }
      return OtpSendResult.failure('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<AuthResultModel> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (_debugPhoneAuth) {
      final shortId = verificationId.length > 8 ? verificationId.substring(0, 8) : verificationId;
      // ignore: avoid_print
      print('[PhoneAuth][verify] verificationId=$shortId... codeLen=${smsCode.length}');
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (_debugPhoneAuth) {
        // ignore: avoid_print
        print('[PhoneAuth][verify][success] uid=${userCredential.user?.uid}');
      }
      final user = await _createOrUpdateUser(userCredential.user!);
      return AuthResultModel.success(user);
    } on FirebaseAuthException catch (e) {
      if (_debugPhoneAuth) {
        // ignore: avoid_print
        print('[PhoneAuth][verify][FirebaseAuthException] code=${e.code} message=${e.message}');
      }
      // Map some common codes to user-friendly messages
      final fallback = 'Invalid OTP. Please check the code and try again.';
      String message;
      switch (e.code) {
        case 'invalid-verification-code':
          message = 'Invalid OTP code. Please try again.';
          break;
        case 'session-expired':
          message = 'This OTP has expired. Please request a new one.';
          break;
        case 'quota-exceeded':
          message = 'SMS quota exceeded. Please try again later.';
          break;
        default:
          message = e.message ?? fallback;
      }
      return AuthResultModel.failure(message);
    } catch (e) {
      if (_debugPhoneAuth) {
        // ignore: avoid_print
        print('[PhoneAuth][verify][exception] $e');
      }
      return AuthResultModel.failure('Failed to verify OTP. Please try again.');
    }
  }

  // EMAIL VERIFICATION HELPERS ----------------------------------------------
  Future<bool> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      await user.sendEmailVerification();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('[EmailAuth][verification][resend][error] $e');
      return false;
    }
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload(); // refresh verification state
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<bool> resendEmailVerificationIfUnverified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    if (user.emailVerified) return true; // already verified
    return await sendEmailVerification();
  }

  /// Helper method to create or update user
  Future<UserModel> _createOrUpdateUser(User firebaseUser, {String? overrideDisplayName, String? overridePhotoInitial}) async {
    final now = DateTime.now();

    // Create/update user in Firestore
    final userRef = _firestore.collection('users').doc(firebaseUser.uid);
    final docSnapshot = await userRef.get();

    final effectiveDisplayName = overrideDisplayName ?? firebaseUser.displayName ?? firebaseUser.email?.split('@').first;
    final effectivePhotoUrl = overridePhotoInitial ?? firebaseUser.photoURL; // if single letter, UI will render initial
    late UserModel model;
    if (docSnapshot.exists) {
      await userRef.set({
        'lastLoginAt': now.toIso8601String(),
        'userId': firebaseUser.uid,
        'displayName': effectiveDisplayName,
        'photoUrl': effectivePhotoUrl,
        'email': firebaseUser.email ?? '',
        'createdAt': (docSnapshot.data()?['createdAt'] as String?) ?? now.toIso8601String(),
      }, SetOptions(merge: true));
      model = UserModel.fromJson({
        ...docSnapshot.data()!,
        'displayName': effectiveDisplayName,
        'photoUrl': effectivePhotoUrl,
        'id': firebaseUser.uid,
        'lastLoginAt': now.toIso8601String(),
        'email': firebaseUser.email ?? (docSnapshot.data()?['email'] as String? ?? ''),
        'createdAt': (docSnapshot.data()?['createdAt'] as String?) ?? now.toIso8601String(),
      });
    } else {
      final userData = {
        'email': firebaseUser.email ?? '',
        'displayName': effectiveDisplayName,
        'photoUrl': effectivePhotoUrl,
        'createdAt': now.toIso8601String(),
        'lastLoginAt': now.toIso8601String(),
        'userId': firebaseUser.uid,
        'total_points_overall': 0,
        'overall_accuracy': 0.0,
        'total_questions_attempted': 0,
        'total_correct_answers': 0,
      }..removeWhere((k,v)=>v==null);
      await userRef.set(userData);
      model = UserModel.fromJson({
        ...userData,
        'id': firebaseUser.uid,
      });
    }
    // Update progress user_core mirror (fire-and-forget; errors ignored)
    try {
      await FirestoreProgressRepository().updateUserCore(
        userId: firebaseUser.uid,
        displayName: effectiveDisplayName,
        photoUrl: effectivePhotoUrl,
      );
    } catch (e) {
      // ignore: avoid_print
      print('[auth] Failed to update user_core mirror: $e');
    }
    return model;
  }
}
