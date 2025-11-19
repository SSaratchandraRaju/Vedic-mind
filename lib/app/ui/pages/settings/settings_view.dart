import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.h3.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildSectionHeader('Profile'),
            const SizedBox(height: 12),
            _buildProfileCard(),
            const SizedBox(height: 32),

            // Notifications Section
            _buildSectionHeader('Notifications'),
            const SizedBox(height: 12),
            _buildNotificationCard(
              title: 'Push notifications',
              subtitle: 'Get notified about new updates',
              value: controller.pushNotifications,
              onChanged: controller.togglePushNotifications,
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              title: 'Email notifications',
              subtitle: 'Receive email updates about new events',
              value: controller.emailNotifications,
              onChanged: controller.toggleEmailNotifications,
            ),
            const SizedBox(height: 32),

            // Preferences Section
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 12),
            _buildPreferenceCard(
              title: 'Appearance',
              subtitle: 'Light',
              trailing: Obx(() => Switch(
                    value: controller.isDarkMode.value,
                    onChanged: (_) => controller.toggleTheme(),
                    activeColor: AppColors.primary,
                  )),
            ),
            const SizedBox(height: 12),
            _buildPreferenceCard(
              title: 'Language',
              subtitle: 'English',
              trailing: const Icon(Icons.chevron_right, color: AppColors.gray400),
              onTap: () {
                // TODO: Implement language selection
              },
            ),
            const SizedBox(height: 32),

            // Help & Legal Section
            _buildSectionHeader('Help & Legal'),
            const SizedBox(height: 12),
            _buildMenuCard(
              title: 'Help center',
              subtitle: 'Get support and find answers',
              onTap: () {
                // TODO: Navigate to help center
              },
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              title: 'Contact us',
              subtitle: 'Chat or call our support team',
              onTap: () {
                // TODO: Navigate to contact page
              },
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              title: 'Privacy policy',
              subtitle: 'Legal agreements',
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              title: 'Terms and conditions',
              subtitle: 'How we handle your data',
              onTap: () {
                // TODO: Navigate to terms
              },
            ),
            const SizedBox(height: 32),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: controller.signOut,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
                  ),                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.bodySmall.copyWith(
        fontSize: 13,
        color: AppColors.gray400,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Profile Image
          Obx(() {
            final imageFile = controller.profileImage.value;
            return GestureDetector(
              onTap: controller.pickProfileImage,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(28),
                  image: imageFile != null
                      ? DecorationImage(
                          image: FileImage(File(imageFile.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageFile == null
                    ? const Icon(Icons.person, size: 32, color: AppColors.gray400)
                    : null,
              ),
            );
          }),
          const SizedBox(width: 16),
          // Name and Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      controller.profileName.value,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    )),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Obx(() {
                      final email = controller.profileEmail.value;
                      final username = email.contains('@') 
                          ? email.split('@')[0] 
                          : email;
                      return Text(
                        username,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      );
                    }),
                    const SizedBox(width: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.gray400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Obx(() => Text(
                      controller.userType.value,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          // Edit Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              onTap: controller.navigateToEditProfile,
              child: Text(
                'Edit',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required RxBool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
                value: value.value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
              )),
        ],
      ),
    );
  }

  Widget _buildPreferenceCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}