import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

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
    final result = await _authService.signInWithEmailPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    isLoading.value = false;

    if (result.isSuccess) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        'Error',
        result.error ?? 'Sign in failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    final result = await _authService.signUpWithEmailPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    isLoading.value = false;

    if (result.isSuccess) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        'Error',
        result.error ?? 'Sign up failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    final result = await _authService.signInWithGoogle();
    isLoading.value = false;

    if (result.isSuccess) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        'Error',
        result.error ?? 'Google sign in failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Send Phone OTP - Note: Phone auth not yet implemented in new architecture
  Future<void> sendPhoneOTP() async {
    Get.snackbar(
      'Coming Soon',
      'Phone authentication will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
    // TODO: Implement phone auth in AuthService when needed
  }

  // Verify OTP - Not yet implemented
  Future<void> verifyOTP(String otp) async {
    Get.snackbar(
      'Coming Soon',
      'Phone authentication will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
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
    final success = await _authService.sendPasswordResetEmail(
      emailController.text.trim(),
    );
    isLoading.value = false;

    if (success) {
      Get.snackbar(
        'Success',
        'Password reset email sent!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to send reset email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
