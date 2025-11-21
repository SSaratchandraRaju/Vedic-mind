import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/practice_hub_controller.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/progress_section.dart';
import '../../ui/widgets/bottom_nav_bar.dart';

class PracticeHubView extends GetView<PracticeHubController> {
  const PracticeHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Practice', style: AppTextStyles.h5),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Section
                    Obx(
                      () => ProgressSection(
                        completedCount: controller.completedSessions.value,
                        totalCount: controller.totalSessions.value,
                        accuracy: controller.accuracy.value,
                        totalPoints: controller.totalPoints.value,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Practice Options Title
                    Text(
                      'Choose Practice Type',
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Practice Options Grid
                    _buildPracticeOption(
                      icon: Icons.calculate,
                      title: 'Arithmetic Practice',
                      description:
                          'Addition, Subtraction, Multiplication, Division',
                      color: AppColors.primary,
                      onTap: controller.navigateToTables,
                    ),

                    const SizedBox(height: 12),

                    _buildPracticeOption(
                      icon: Icons.auto_stories,
                      title: 'Questions from Sutras',
                      description: 'Practice Vedic sutra problems',
                      color: const Color(0xFFFF6B6B),
                      onTap: controller.navigateToSutraQuestions,
                    ),

                    const SizedBox(height: 12),

                    _buildPracticeOption(
                      icon: Icons.psychology,
                      title: 'Questions from Tactics',
                      description: 'Practice tactical problems',
                      color: const Color(0xFF9B59B6),
                      onTap: controller.navigateToTacticsQuestions,
                    ),

                    const SizedBox(height: 12),

                    _buildPracticeOption(
                      icon: Icons.sports_esports,
                      title: 'Games',
                      description: 'Play 16 mini-games from sutras',
                      color: const Color(0xFF4CAF50),
                      onTap: controller.navigateToGames,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => BottomNavBar(
              currentIndex: controller.currentNavIndex.value,
              onTap: controller.onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeOption({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),

            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
