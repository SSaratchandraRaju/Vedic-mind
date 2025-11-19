import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

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
                const SizedBox(height: 20),
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
                Text(
                  'Create Account',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 26,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() => GestureDetector(
                              onTap: () => controller.selectAuthMethod(0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: controller.selectedAuthMethod.value == 0 ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: controller.selectedAuthMethod.value == 0 ? Colors.white : AppColors.textSecondary,
                                  fontFamily: 'Poppins'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ),
                      Expanded(
                        child: Obx(() => GestureDetector(
                              onTap: () => controller.selectAuthMethod(1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: controller.selectedAuthMethod.value == 1 ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Phone',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: controller.selectedAuthMethod.value == 1 ? Colors.white : AppColors.textSecondary,
                                  fontFamily: 'Poppins'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => controller.selectedAuthMethod.value == 0 ? _buildEmailSignupForm() : _buildPhoneSignupForm()),
                const SizedBox(height: 20),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (controller.selectedAuthMethod.value == 0) {
                                  controller.signUp();
                                } else {
                                  controller.sendPhoneOTP();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor: AppColors.gray300,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(controller.selectedAuthMethod.value == 0 ? 'Sign Up' : 'Send OTP', style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w600, letterSpacing: 0.2),
                            ),
                      ),
                    )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.border, thickness: 1, height: 1)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('Or', style: TextStyle(color: AppColors.gray400, fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w400)),
                    ),
                    Expanded(child: Divider(color: AppColors.border, thickness: 1, height: 1)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: controller.signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.border, width: 1),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
                        const SizedBox(width: 12),
                        const Text('Continue with Google', style: TextStyle(fontSize: 15, fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Already have an account?  ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w400)),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text('Log In', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
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

  Widget _buildEmailSignupForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Email', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w400,
        fontFamily: 'Poppins'),
        decoration: InputDecoration(
          hintText: 'yourname@gmail.com',
          hintStyle: TextStyle(color: AppColors.gray400, fontSize: 15, fontWeight: FontWeight.w400,
          fontFamily: 'Poppins'),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      const SizedBox(height: 16),
      Text('Password', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Obx(() => TextField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w400,
            fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(color: AppColors.gray400, fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 2,
              fontFamily: 'Poppins'),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: IconButton(icon: Icon(controller.obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.gray400), onPressed: controller.togglePasswordVisibility),
            ),
          )),
      const SizedBox(height: 16),
      Text('Confirm Password', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Obx(() => TextField(
            controller: controller.confirmPasswordController,
            obscureText: controller.obscureConfirmPassword.value,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w400,
            fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(color: AppColors.gray400, fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 2,
              fontFamily: 'Poppins'),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: IconButton(icon: Icon(controller.obscureConfirmPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.gray400), onPressed: controller.toggleConfirmPasswordVisibility),
            ),
          )),
    ]);
  }

  Widget _buildPhoneSignupForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Phone Number', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w400,
        fontFamily: 'Poppins'),
        decoration: InputDecoration(
          hintText: '+91 1234567890',
          hintStyle: TextStyle(color: AppColors.gray400, fontSize: 15, fontWeight: FontWeight.w400,
          fontFamily: 'Poppins'),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    ]);
  }
}
