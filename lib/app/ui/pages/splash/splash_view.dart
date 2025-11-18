import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';

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
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    
    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    
    if (!onboardingCompleted) {
      // First time user - show onboarding
      Get.offAllNamed(Routes.ONBOARDING);
    } else if (user != null) {
      // User is logged in - go to home
      Get.offAllNamed(Routes.HOME);
    } else {
      // User completed onboarding but not logged in - show login
      Get.offAllNamed(Routes.LOGIN);
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
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Master Vedic mathematics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
