import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../controllers/enhanced_vedic_course_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class Vedic16SutrasView extends GetView<EnhancedVedicCourseController> {
  const Vedic16SutrasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Gradient
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.gradientEnd,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '16 Vedic Sutras',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Master ancient calculation techniques',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Obx(() => Text(
                                '${controller.allSutras.length} Sutras',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              )),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Progress Section
            SliverToBoxAdapter(
              child: Obx(() {
                final progress = controller.overallProgress;
                final completedCount = progress['completed'] as int;
                final totalCount = progress['total'] as int;
                final completionPercent = progress['completion_percentage'] as int;
                final accuracy = progress['accuracy'] as int;
                final totalPoints = progress['total_points'] as int;
                
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Progress',
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$completionPercent%',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Completion info
                      Row(
                        children: [
                          Text(
                            '$completedCount of $totalCount Sutras',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$completionPercent% completed',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: completionPercent / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Stats Row
                      Row(
                        children: [
                          // Accuracy
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: const Color(0xFF4CAF50),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Accuracy',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$accuracy%',
                                  style: AppTextStyles.h4.copyWith(
                                    color: const Color(0xFF4CAF50),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Divider
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.border,
                          ),
                          
                          // Points
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.emoji_events,
                                      size: 16,
                                      color: Color(0xFFFF9800),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Points',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    '$totalPoints',
                                    style: AppTextStyles.h4.copyWith(
                                      color: const Color(0xFFFF9800),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),

            // Content
            SliverToBoxAdapter(
              child: Obx(() {
                // Show loading
                if (controller.isLoading.value) {
                  return Container(
                    padding: const EdgeInsets.all(60),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading sutras...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show error if no data
                if (controller.allSutras.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No sutras loaded',
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please check your connection',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show sutra cards
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header info
                      // Sutra cards
                      ...controller.allSutras.map((sutra) {
                        return _SutraCard(
                          sutra: sutra,
                          onTap: () {
                            Get.toNamed(
                              Routes.SUTRA_DETAIL,
                              arguments: {
                                'sutra': sutra,
                                'sutraNumber': sutra.sutraId,
                                'sutraName': sutra.name,
                                'meaning': sutra.translation,
                              },
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}


class _SutraCard extends StatelessWidget {
  final dynamic sutra;
  final VoidCallback onTap;

  const _SutraCard({
    Key? key,
    required this.sutra,
    required this.onTap,
  }) : super(key: key);

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF4CAF50);
      case 'intermediate':
        return const Color(0xFFFFA726);
      case 'advanced':
        return const Color(0xFFEF5350);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedVedicCourseController>();
    
    return Obx(() {
      final progress = controller.sutraProgress[sutra.sutraId];
      final isCompleted = progress?.isCompleted ?? false;
      final accuracy = progress?.accuracy.toInt() ?? 0;
      final hasProgress = progress != null && progress.totalAttempts > 0;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted ? const Color(0xFF4CAF50) : AppColors.border,
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sutra Number (without background)
                      Stack(
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: Center(
                              child: Text(
                                '${sutra.sutraId}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      
                      // Sutra Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sutra.name,
                              style: AppTextStyles.h5.copyWith(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sutra.translation,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Difficulty Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(sutra.difficulty).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _getDifficultyColor(sutra.difficulty).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    sutra.difficulty,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _getDifficultyColor(sutra.difficulty),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                
                                // Accuracy Chip (only if has progress)
                                if (hasProgress) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: (accuracy >= 80 
                                            ? const Color(0xFF4CAF50)
                                            : accuracy >= 50
                                                ? const Color(0xFFFFA726)
                                                : const Color(0xFFEF5350)).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12,
                                          color: accuracy >= 80 
                                              ? const Color(0xFF4CAF50)
                                              : accuracy >= 50
                                                  ? const Color(0xFFFFA726)
                                                  : const Color(0xFFEF5350),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$accuracy%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: accuracy >= 80 
                                                ? const Color(0xFF4CAF50)
                                                : accuracy >= 50
                                                    ? const Color(0xFFFFA726)
                                                    : const Color(0xFFEF5350),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Time (Top Right)
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${sutra.timeMinutes} min',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 11,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Arrow Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
