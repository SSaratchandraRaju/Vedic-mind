import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppColors.yellow.withOpacity(0.15),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
              
              // Logo/Slogan
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                      color: AppColors.gray800,
                      borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/vedicmindicon.png',
                        fit: BoxFit.cover,
                      ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                        'Unlock the Magic of Numbers!',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Sign in to your\nAccount',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 26,
                  height: 1.3,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your email and password to log in',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
              
              // Email field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email / Phone',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'yourname@gmail.com',
                  hintStyle: TextStyle(
                    color: AppColors.gray400,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Password field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(
                        color: AppColors.gray400,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.gray400,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password ?',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Or divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.border,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or',
                      style: TextStyle(
                        color: AppColors.gray400,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.border,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Google sign in
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: controller.signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.border, width: 1),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/google.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Sign up link
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Don\'t have an account?  ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.SIGNUP),
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

