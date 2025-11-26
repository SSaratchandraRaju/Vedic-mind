import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class VerifyEmailController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final isVerified = false.obs;
  final isSending = false.obs;
  final secondsRemaining = 0.obs; // resend cooldown
  Timer? _pollTimer;
  Timer? _cooldownTimer;

  static const Duration pollInterval = Duration(seconds: 12);
  static const Duration resendCooldown = Duration(seconds: 45);

  @override
  void onInit() {
    super.onInit();
    _startPolling();
    _startCooldown(0); // no initial cooldown
    refreshStatus();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(pollInterval, (_) => refreshStatus());
  }

  Future<void> refreshStatus() async {
    final user = _auth.currentUser;
    if (user == null) return; // user logged out
    await user.reload();
    final refreshed = _auth.currentUser;
    final verified = refreshed?.emailVerified ?? false;
    isVerified.value = verified;
    if (verified) {
      _pollTimer?.cancel();
      // Navigate to home only if currently on verify screen
      if (Get.currentRoute == Routes.VERIFY_EMAIL) {
        Get.offAllNamed(Routes.HOME);
      }
    }
  }

  bool get canResend => secondsRemaining.value == 0 && !isSending.value;

  String get maskedEmail {
    final email = _auth.currentUser?.email;
    if (email == null) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    if (local.length <= 2) return '${local[0]}***@${parts[1]}';
    return '${local.substring(0,2)}***@${parts[1]}';
  }

  Future<void> resendEmail() async {
    if (!canResend) return;
    isSending.value = true;
    final user = _auth.currentUser;
    if (user == null) {
      isSending.value = false;
      return;
    }
    try {
      await user.sendEmailVerification();
      _startCooldown(resendCooldown.inSeconds);
      Get.snackbar('Email Sent', 'Verification link sent to ${_maskEmail(user.email ?? '')}', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send verification email', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSending.value = false;
    }
  }

  void _startCooldown(int seconds) {
    secondsRemaining.value = seconds;
    _cooldownTimer?.cancel();
    if (seconds == 0) return;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        t.cancel();
      }
    });
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    if (local.length <= 2) return '${local[0]}***@${parts[1]}';
    return '${local.substring(0,2)}***@${parts[1]}';
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    super.onClose();
  }
}
