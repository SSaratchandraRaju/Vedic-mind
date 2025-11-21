import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/vedic_course_controller.dart';
import '../../data/models/vedic_course_models.dart';
import '../../routes/app_routes.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/progress_section.dart';

class AllLessonsView extends GetView<VedicCourseController> {
  const AllLessonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading lessons...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final allLessons = controller.getAllLessons();

          if (allLessons.isEmpty) {
            return Center(
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
                    'No lessons available',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Gradient - Exactly like Vedic Sutras
              SliverAppBar(
                expandedHeight: 220,
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
                        colors: [AppColors.primary, AppColors.gradientEnd],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Master Vedic Mathematics',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Learn powerful calculation techniques through structured lessons',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.library_books,
                                  size: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '${allLessons.length} Comprehensive Lessons',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Progress Section - Common Widget
              SliverToBoxAdapter(
                child: Builder(
                  builder: (context) {
                    final completedCount = allLessons.where((l) {
                      final lesson = l['lesson'] as Lesson;
                      return lesson.isCompleted;
                    }).length;
                    final totalCount = allLessons.length;

                    // Calculate accuracy
                    int totalAttempts = 0;
                    int totalCorrect = 0;
                    for (var item in allLessons) {
                      final lesson = item['lesson'] as Lesson;
                      if (lesson.score > 0) {
                        totalAttempts++;
                        totalCorrect += lesson.score;
                      }
                    }
                    final accuracy = totalAttempts > 0
                        ? (totalCorrect / totalAttempts).toInt()
                        : 0;

                    // Calculate total points (100 points per completed lesson)
                    final totalPoints = completedCount * 100;

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ProgressSection(
                        completedCount: completedCount,
                        totalCount: totalCount,
                        accuracy: accuracy,
                        totalPoints: totalPoints,
                      ),
                    );
                  },
                ),
              ),

              // Lessons List - Exactly like Vedic Sutras cards
              SliverToBoxAdapter(
                child: Builder(
                  builder: (context) {
                    final allLessons = controller.getAllLessons();

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Lesson cards
                          ...allLessons.asMap().entries.map((entry) {
                            final index = entry.key;
                            final lessonWithChapter = entry.value;
                            final lesson =
                                lessonWithChapter['lesson'] as Lesson;
                            final lessonNumber =
                                index + 1; // Sequential numbering 1, 2, 3...

                            // Check if lesson should be unlocked
                            bool isUnlocked =
                                index == 0; // First lesson always unlocked
                            if (index > 0) {
                              final prevLesson =
                                  allLessons[index - 1]['lesson'] as Lesson;
                              isUnlocked = prevLesson.isCompleted;
                            }

                            return _LessonCard(
                              lesson: lesson,
                              lessonNumber: lessonNumber,
                              isUnlocked: isUnlocked,
                              onTap: isUnlocked
                                  ? () {
                                      Get.toNamed(
                                        Routes.LESSON_DETAIL,
                                        arguments: lesson,
                                      );
                                    }
                                  : null,
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// Lesson Card Widget - Exactly like Sutra Card
class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final int lessonNumber;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const _LessonCard({
    Key? key,
    required this.lesson,
    required this.lessonNumber,
    required this.isUnlocked,
    this.onTap,
  }) : super(key: key);

  Color _getDifficultyColor() {
    // Base difficulty on lesson duration
    if (lesson.durationMinutes <= 15) {
      return const Color(0xFF4CAF50); // Beginner (green)
    } else if (lesson.durationMinutes <= 25) {
      return const Color(0xFFFFA726); // Intermediate (orange)
    } else {
      return const Color(0xFFEF5350); // Advanced (red)
    }
  }

  String _getDifficultyLabel() {
    if (lesson.durationMinutes <= 15) {
      return 'Beginner';
    } else if (lesson.durationMinutes <= 25) {
      return 'Intermediate';
    } else {
      return 'Advanced';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.isCompleted;
    final hasProgress = lesson.score > 0;
    final accuracy = lesson.score;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF4CAF50)
              : isUnlocked
              ? AppColors.border
              : Colors.grey[300]!,
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lesson Number - Exactly like Sutra number
                    Stack(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: Center(
                            child: isUnlocked
                                ? Text(
                                    '$lessonNumber',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted
                                          ? const Color(0xFF4CAF50)
                                          : AppColors.primary,
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                : Icon(
                                    Icons.lock,
                                    size: 32,
                                    color: Colors.grey[400],
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

                    // Lesson Info - Exactly like Sutra info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.lessonTitle,
                            style: AppTextStyles.h5.copyWith(
                              fontSize: 16,
                              color: isUnlocked
                                  ? AppColors.textPrimary
                                  : Colors.grey[600],
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lesson.objective,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isUnlocked
                                  ? AppColors.textSecondary
                                  : Colors.grey[500],
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
                              // Difficulty Badge - Exactly like Sutra
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _getDifficultyColor().withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _getDifficultyLabel(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getDifficultyColor(),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),

                              // Accuracy Chip - Exactly like Sutra (only if has progress)
                              if (hasProgress && isUnlocked) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color:
                                          (accuracy >= 80
                                                  ? const Color(0xFF4CAF50)
                                                  : accuracy >= 50
                                                  ? const Color(0xFFFFA726)
                                                  : const Color(0xFFEF5350))
                                              .withOpacity(0.3),
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

                    // Time - Exactly like Sutra (Top Right)
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: isUnlocked
                                  ? AppColors.textTertiary
                                  : Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${lesson.durationMinutes} min',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                color: isUnlocked
                                    ? AppColors.textSecondary
                                    : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Arrow Icon - Exactly like Sutra
                        if (isUnlocked)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: AppColors.primary,
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
  }
}
