import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  }

  void onPageChanged(int page) {
    currentPage.value = page;

    // Reset and replay animation when page changes
    animationController.reset();
    animationController.forward();
  }

  Future<void> nextPage() async {
    if (currentPage.value < 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as completed and navigate to login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> skipOnboarding() async {
    // Mark onboarding as completed and navigate to login
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
