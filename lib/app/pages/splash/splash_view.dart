import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/firestore_user_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../ui/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final localCompleted = prefs.getBool('onboarding_completed') ?? false;
    final user = FirebaseAuth.instance.currentUser;

    // If no user yet (unauthenticated)
    if (user == null) {
      // If we have locally completed onboarding, go straight to LOGIN
      if (localCompleted) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
      return;
    }
    try {
      final repo = FirestoreUserSettingsRepository();
      final settings = await repo.fetch(user.uid);
      // Prefer remote flag if available; fall back to local flag
      final completed = settings.onboardingCompleted || localCompleted;
      if (completed) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    } catch (e) {
      // Firestore unavailable (offline or index issue) -> default to HOME to avoid blocking UX
      if (localCompleted) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.calculate_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'VedicMind',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Master Vedic mathematics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
