import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';
import '../services/firebase_auth_service.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = Get.find<FirebaseAuthService>();
  
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  
  // Observable states
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;
  final selectedAuthMethod = 0.obs; // 0 = Email, 1 = Phone
  
  // OTP related
  final otpCode = ''.obs;
  final verificationId = ''.obs;
  final resendTimer = 60.obs;
  
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
  
  void selectAuthMethod(int method) {
    selectedAuthMethod.value = method;
  }

  // Email/Password Login
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final credential = await _authService.signInWithEmailPassword(
      emailController.text.trim(),
      passwordController.text,
    );
    isLoading.value = false;

    if (credential != null) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // Email/Password Signup
  Future<void> signUp() async {
    if (emailController.text.isEmpty || 
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final credential = await _authService.signUpWithEmailPassword(
      emailController.text.trim(),
      passwordController.text,
    );
    isLoading.value = false;

    if (credential != null) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    final credential = await _authService.signInWithGoogle();
    isLoading.value = false;

    if (credential != null) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // Send Phone OTP
  Future<void> sendPhoneOTP() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Format phone number (add country code if needed)
    String phoneNumber = phoneController.text.trim();
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91$phoneNumber'; // Default to India, change as needed
    }

    isLoading.value = true;
    
    await _authService.sendPhoneOTP(
      phoneNumber,
      onCodeSent: (verId) {
        isLoading.value = false;
        verificationId.value = verId;
        startResendTimer();
        Get.toNamed(Routes.OTP_VERIFICATION, arguments: {
          'phoneNumber': phoneNumber,
          'verificationType': 'phone',
        });
      },
      onVerificationFailed: (e) {
        isLoading.value = false;
        // Error is handled in the service
      },
      onAutoVerify: (credential) async {
        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);
      },
    );
  }

  // Verify OTP
  Future<void> verifyOTP(String otp) async {
    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter valid 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final credential = await _authService.verifyPhoneOTP(otp);
    isLoading.value = false;

    if (credential != null) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    if (resendTimer.value > 0) return;
    await sendPhoneOTP();
  }

  // Start resend timer
  void startResendTimer() {
    resendTimer.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendTimer.value > 0) {
        resendTimer.value--;
        return true;
      }
      return false;
    });
  }

  // Reset Password
  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    await _authService.resetPassword(emailController.text.trim());
    isLoading.value = false;
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
