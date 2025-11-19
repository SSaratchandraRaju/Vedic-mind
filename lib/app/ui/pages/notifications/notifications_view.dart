import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/notifications_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notifications',
          style: AppTextStyles.h5,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNotificationItem(
                  icon: Icons.calculate,
                  iconColor: AppColors.primary,
                  iconBackground: AppColors.primary.withOpacity(0.1),
                  title: 'Math Tables',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.stars,
                  iconColor: Colors.white,
                  iconBackground: const Color(0xFF8B5CF6),
                  title: 'Practice and level up',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.calculate,
                  iconColor: AppColors.primary,
                  iconBackground: AppColors.primary.withOpacity(0.1),
                  title: 'Math Tables',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.stars,
                  iconColor: Colors.white,
                  iconBackground: const Color(0xFFFFB020),
                  title: 'Practice and level up',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.stars,
                  iconColor: Colors.white,
                  iconBackground: const Color(0xFF8B5CF6),
                  title: 'Practice and level up',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.calculate,
                  iconColor: AppColors.primary,
                  iconBackground: AppColors.primary.withOpacity(0.1),
                  title: 'Math Tables',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.stars,
                  iconColor: Colors.white,
                  iconBackground: const Color(0xFFFFB020),
                  title: 'Practice and level up',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.stars,
                  iconColor: Colors.white,
                  iconBackground: const Color(0xFF8B5CF6),
                  title: 'Practice and level up',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
                _buildNotificationItem(
                  icon: Icons.calculate,
                  iconColor: AppColors.primary,
                  iconBackground: AppColors.primary.withOpacity(0.1),
                  title: 'Math Tables',
                  subtitle: 'You can resume the math test.',
                  time: '30m ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          
          // Time
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}
