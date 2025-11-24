import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';

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
        title:  Text('Notifications', style: AppTextStyles.h5),
        centerTitle: true,
      ),
      body: Obx(() {
        final items = controller.notifications;
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No notifications yet',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final n = items[index];
            final now = DateTime.now();
            final diff = now.difference(n.timestamp);
            String timeLabel;
            if (diff.inMinutes < 60) {
              timeLabel = '${diff.inMinutes}m ago';
            } else if (diff.inHours < 24) {
              timeLabel = '${diff.inHours}h ago';
            } else {
              timeLabel = '${diff.inDays}d ago';
            }
            // Basic heuristic: choose icon by keywords
            final lower = n.title.toLowerCase();
            IconData icon = Icons.notifications;
            Color iconBg = AppColors.primary.withOpacity(0.1);
            Color iconColor = AppColors.primary;
            if (lower.contains('practice') || lower.contains('level')) {
              icon = Icons.stars;
              iconBg = const Color(0xFF8B5CF6);
              iconColor = Colors.white;
            } else if (lower.contains('math') || lower.contains('table')) {
              icon = Icons.calculate;
            }
            return _buildNotificationItem(
              icon: icon,
              iconColor: iconColor,
              iconBackground: iconBg,
              title: n.title,
              subtitle: n.body,
              time: timeLabel,
            );
          },
        );
      }),
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
            child: Icon(icon, color: iconColor, size: 24),
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
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
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
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
