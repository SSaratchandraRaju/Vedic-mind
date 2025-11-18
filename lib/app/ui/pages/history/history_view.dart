import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/history_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/bottom_nav_bar.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'History',
          style: AppTextStyles.h5,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Search for basic math...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Today Section
                  _buildSectionHeader('Today', 'See All'),
                  _buildHistoryItem(
                    title: 'Practice session - 09',
                    subtitle: 'Maths, tables and division...',
                    score: 234,
                    time: '9.56 AM',
                  ),
                  _buildHistoryItem(
                    title: 'Practice session - 09',
                    subtitle: 'Maths, tables and division...',
                    score: 234,
                    time: '9.56 AM',
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Previous Section
                  _buildSectionHeader('Previous', ''),
                  _buildHistoryItem(
                    title: 'Practice session - 09',
                    subtitle: 'Maths, tables and division...',
                    score: 234,
                    time: '9.56 AM',
                  ),
                  _buildHistoryItem(
                    title: 'Practice session - 09',
                    subtitle: 'Maths, tables and division...',
                    score: 234,
                    time: '9.56 AM',
                  ),
                  _buildHistoryItem(
                    title: 'Practice session - 09',
                    subtitle: 'Maths, tables and division...',
                    score: 234,
                    time: '9.56 AM',
                  ),
                  _buildHistoryItem(
                    title: 'Practice session - 09',
                    subtitle: 'Maths, tables and division...',
                    score: 234,
                    time: '9.56 AM',
                  ),
                  _buildHistoryItem(
                    title: 'Practice session - 09',
                    subtitle: 'Maths, tables and division...',
                    score: 234,
                    time: '9.56 AM',
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Obx(() => BottomNavBar(
                currentIndex: controller.currentNavIndex.value,
                onTap: controller.onNavTap,
              )),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (action.isNotEmpty)
            Text(
              action,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String subtitle,
    required int score,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green check icon - smaller size aligned with title
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Title and subtitle - subtitle starts under the icon
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
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Score and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
