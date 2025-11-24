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
  final isSendingOtp = false.obs;
  final isVerifyingOtp = false.obs;

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
      _error('Please fill in all fields');
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
      _error(result.error ?? 'Sign in failed');
    }
  }

  // Email/Password Signup
  Future<void> signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _error('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _error('Passwords do not match');
      return;
    }

    if (passwordController.text.length < 6) {
      _error('Password must be at least 6 characters');
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
      _error(result.error ?? 'Sign up failed');
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
      _error(result.error ?? 'Google sign in failed');
    }
  }

  // Send Phone OTP
  Future<void> sendPhoneOTP() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      _error('Enter phone number');
      return;
    }
    isSendingOtp.value = true;
    final res = await _authService.sendPhoneOtp(phone);
    isSendingOtp.value = false;

    if (res.isSuccess) {
      // Auto verification sentinel
      if (res.verificationId == 'AUTO_VERIFIED') {
        // Already signed in by backend
        Get.offAllNamed(Routes.HOME);
        return;
      }
      verificationId.value = res.verificationId!;
      startResendTimer();
      Get.toNamed(Routes.OTP_VERIFICATION, arguments: {'phone': phone});
      Get.snackbar(
        'OTP Sent',
        'Code sent to $phone',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
  _error(res.error ?? 'Failed to send OTP');
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String otp) async {
    if (verificationId.value.isEmpty) {
      _error('Missing verification session. Please resend OTP.');
      return;
    }
    if (otp.trim().length < 4) {
      _error('Invalid OTP code');
      return;
    }
    isVerifyingOtp.value = true;
    final result = await _authService.verifyPhoneOtp(
      verificationId: verificationId.value,
      smsCode: otp.trim(),
    );
    isVerifyingOtp.value = false;

    if (result.isSuccess) {
      Get.offAllNamed(Routes.HOME);
    } else {
      _error(result.error ?? 'OTP verification failed');
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
      _error('Please enter your email');
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
      _error('Failed to send reset email');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void _error(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
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
