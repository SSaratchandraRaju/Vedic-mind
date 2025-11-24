import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/firestore_user_settings_repository.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class OnboardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final pageController = PageController();
  final currentPage = 0.obs;

  // Animation controller for floating elements
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animationController.forward();
    _initAuth();
  }

  AuthService? _authService;
  String? _userId;
  final _settingsRepo = FirestoreUserSettingsRepository();

  Future<void> _initAuth() async {
    try {
      _authService = Get.find<AuthService>();
      final user = await _authService!.getCurrentUser();
      _userId = user?.id;
    } catch (_) {}
  }

  void onPageChanged(int page) {
    currentPage.value = page;

    // Reset and replay animation when page changes
    animationController.reset();
    animationController.forward();
  }

  // Total number of onboarding pages
  static const int totalPages = 3;

  Future<void> nextPage() async {
    // If not on last page, go to next
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as completed remotely and navigate
      if (_userId != null) {
        await _settingsRepo.markOnboardingCompleted(_userId!);
        // If already authenticated, go straight to HOME
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
      // Persist locally so we don't show onboarding again on cold start
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    }
  }

  Future<void> skipOnboarding() async {
    if (_userId != null) {
      await _settingsRepo.markOnboardingCompleted(_userId!);
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }

  @override
  void onClose() {
    pageController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
