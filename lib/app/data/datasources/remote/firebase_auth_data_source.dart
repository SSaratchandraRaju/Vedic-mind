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

      final user = await _createOrUpdateUser(userCredential.user!);
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
        return UserModel.fromJson({
          ...data,
          'id': firebaseUser.uid,
        });
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
    try {
      // Normalize phone number (ensure starts with +)
      final cleaned = phoneNumber.replaceAll(RegExp(r'\s+'), '');
      final normalized = cleaned.startsWith('+')
          ? cleaned
          : '+$cleaned';

    // Debug logging to help diagnose phone auth issues (remove in production)
    // ignore: avoid_print
    print('[PhoneAuth] Requesting OTP for: $normalized');

      final completer = Completer<OtpSendResult>();

      await _auth.verifyPhoneNumber(
        phoneNumber: normalized,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval on Android; sign in directly
          final userCred = await _auth.signInWithCredential(credential);
          await _createOrUpdateUser(userCred.user!);
          if (!completer.isCompleted) {
            completer.complete(OtpSendResult.success('AUTO_VERIFIED'));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.complete(OtpSendResult.failure(e.message ?? 'Verification failed'));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(OtpSendResult.success(verificationId));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout - still provide verificationId for manual entry
          if (!completer.isCompleted) {
            completer.complete(OtpSendResult.success(verificationId));
          }
        },
      );

      return await completer.future;
    } catch (e) {
      return OtpSendResult.failure('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<AuthResultModel> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = await _createOrUpdateUser(userCredential.user!);
      return AuthResultModel.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResultModel.failure(e.message ?? 'Invalid OTP');
    } catch (e) {
      return AuthResultModel.failure('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Helper method to create or update user
  Future<UserModel> _createOrUpdateUser(User firebaseUser) async {
    final now = DateTime.now();

    // Create/update user in Firestore
    final userRef = _firestore.collection('users').doc(firebaseUser.uid);
    final docSnapshot = await userRef.get();

    late UserModel model;
    if (docSnapshot.exists) {
      await userRef.update({
        'lastLoginAt': now.toIso8601String(),
        'userId': firebaseUser.uid,
        'displayName': firebaseUser.displayName, // keep name fresh
        'photoUrl': firebaseUser.photoURL,
      });
      model = UserModel.fromJson({
        ...docSnapshot.data()!,
        'displayName': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoURL,
        'id': firebaseUser.uid,
      });
    } else {
      final userData = {
        'email': firebaseUser.email,
        'displayName': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoURL,
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
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
      );
    } catch (e) {
      // ignore: avoid_print
      print('[auth] Failed to update user_core mirror: $e');
    }
    return model;
  }
}
