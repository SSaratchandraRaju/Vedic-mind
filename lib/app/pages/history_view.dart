import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../controllers/global_progress_controller.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/bottom_nav_bar.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProgress = Get.find<GlobalProgressController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('History', style: AppTextStyles.h5),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final allHistory = globalProgress.progressHistory;
              final todayHistory = globalProgress.getTodayHistory();
              final previousHistory = allHistory.where((e) => !todayHistory.contains(e)).toList();

              if (allHistory.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: AppColors.textTertiary),
                      const SizedBox(height: 16),
                      Text('No history yet', style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text('Complete activities to see your progress', style: AppTextStyles.bodySmall),
                    ],
                  ),
                );
              }

              final isSearching = controller.isSearching.value;
              final filtered = controller.filtered;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              decoration: InputDecoration(
                                hintText: 'Search history (section, description, type, points)...',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (controller.searchQuery.value.isNotEmpty)
                            GestureDetector(
                              onTap: controller.clearSearch,
                              child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                    ),

                    // Search Results (when active)
                    if (isSearching) ...[
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
                              const SizedBox(height: 12),
                              Text('No matching entries', style: AppTextStyles.h5),
                              const SizedBox(height: 4),
                              Text(
                                'Try a different keyword or clear search',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else ...[
                        _buildSectionHeader('Results (${filtered.length})', ''),
                        ...filtered.map((entry) => _buildHistoryItem(
                              section: entry.section,
                              description: entry.description,
                              points: entry.points,
                              time: _formatDateTime(entry.timestamp),
                              type: entry.type,
                            )),
                        const SizedBox(height: 20),
                      ],
                    ] else ...[
                      // Today Section
                      if (todayHistory.isNotEmpty) ...[
                        _buildSectionHeader('Today', '${todayHistory.length} activities'),
                        ...todayHistory.map((entry) => _buildHistoryItem(
                              section: entry.section,
                              description: entry.description,
                              points: entry.points,
                              time: _formatTime(entry.timestamp),
                              type: entry.type,
                            )),
                        const SizedBox(height: 20),
                      ],

                      // Previous Section
                      if (previousHistory.isNotEmpty) ...[
                        _buildSectionHeader('Previous', '${previousHistory.length} activities'),
                        ...previousHistory.map((entry) => _buildHistoryItem(
                              section: entry.section,
                              description: entry.description,
                              points: entry.points,
                              time: _formatDateTime(entry.timestamp),
                              type: entry.type,
                            )),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              );
            }),
          ),
          Obx(() => BottomNavBar(currentIndex: controller.currentNavIndex.value, onTap: controller.onNavTap)),
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
              fontFamily: 'Poppins',
            ),
          ),
          if (action.isNotEmpty)
            Text(
              action,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String section,
    required String description,
    required int points,
    required String time,
    required String type,
  }) {
    IconData getIcon() {
      switch (type) {
        case 'test':
          return Icons.quiz_outlined;
        case 'lesson':
          return Icons.school_outlined;
        case 'practice':
          return Icons.fitness_center_outlined;
        case 'sutra':
          return Icons.auto_awesome;
        default:
          return Icons.check_circle_outline;
      }
    }

    Color getColor() {
      switch (section) {
        case 'Math Tables':
          return AppColors.primary;
        case 'Vedic Sutras':
          return const Color(0xFFFF9800);
        case 'Vedic Tactics':
          return const Color(0xFF9C27B0);
        case 'Practice':
          return const Color(0xFF4CAF50);
        default:
          return AppColors.primary;
      }
    }

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
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: getColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(getIcon(), color: getColor(), size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.2,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$points',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Poppins',
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
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  String _formatDateTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return _formatTime(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final month = timestamp.month.toString().padLeft(2, '0');
      final day = timestamp.day.toString().padLeft(2, '0');
      return '$month/$day/${timestamp.year}';
    }
  }
}
