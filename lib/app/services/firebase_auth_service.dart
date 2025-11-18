import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class FirebaseAuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Current user
  User? get currentUser => _auth.currentUser;
  
  // Phone verification ID
  String? _verificationId;
  String? get verificationId => _verificationId;

  // Sign in with Email and Password
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  // Sign up with Email and Password
  Future<UserCredential?> signUpWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Send Phone OTP
  Future<void> sendPhoneOTP(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException exception) onVerificationFailed,
    Function(PhoneAuthCredential credential)? onAutoVerify,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
          if (onAutoVerify != null) {
            onAutoVerify(credential);
          } else {
            await _auth.signInWithCredential(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  // Verify Phone OTP
  Future<UserCredential?> verifyPhoneOTP(String otp) async {
    try {
      if (_verificationId == null) {
        Get.snackbar(
          'Error',
          'Verification ID not found. Please request OTP again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
        return null;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    }
  }

  // Handle Firebase Auth Exceptions
  void _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email.';
        break;
      case 'invalid-email':
        message = 'The email address is invalid.';
        break;
      case 'weak-password':
        message = 'The password is too weak.';
        break;
      case 'invalid-verification-code':
        message = 'Invalid OTP code. Please try again.';
        break;
      case 'invalid-phone-number':
        message = 'Invalid phone number format.';
        break;
      default:
        message = e.message ?? 'An error occurred. Please try again.';
    }
    
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
    );
  }
}
