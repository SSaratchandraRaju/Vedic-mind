import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/vedic_course_controller.dart';
import '../../data/models/vedic_course_models.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';

class ChapterDetailView extends GetView<VedicCourseController> {
  const ChapterDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Handle arguments safely - it should be a Chapter
    final dynamic args = Get.arguments;

    // If the argument is a Lesson (which shouldn't happen but let's handle it),
    // we need to find the chapter from the controller
    late Chapter chapter;

    if (args is Chapter) {
      chapter = args;
    } else if (args is Lesson) {
      // This is a fallback - find the chapter that contains this lesson
      final chapterId = args.lessonId ~/ 100;
      final foundChapter = controller.course.value?.chapters.firstWhere(
        (ch) => ch.chapterId == chapterId,
        orElse: () => throw Exception('Chapter not found'),
      );
      if (foundChapter == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          body: const Center(child: Text('Chapter not found')),
        );
      }
      chapter = foundChapter;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(child: Text('Invalid arguments')),
      );
    }

    final colorValue = int.tryParse(chapter.color) ?? 0xFF5B7FFF;
    final chapterColor = Color(colorValue);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
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
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 56.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chapter ${chapter.chapterId}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          chapter.chapterTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.chapterDescription,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: chapterColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: chapterColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.book_outlined, color: chapterColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${chapter.lessons.length} Lessons',
                                style: AppTextStyles.h5.copyWith(
                                  color: chapterColor,
                                ),
                              ),
                              Text(
                                'Complete all to master this chapter',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Lessons', style: AppTextStyles.h5),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final lesson = chapter.lessons[index];
                final isCompleted = controller.isLessonCompleted(
                  lesson.lessonId,
                );
                final isLocked =
                    index > 0 &&
                    !controller.isLessonCompleted(
                      chapter.lessons[index - 1].lessonId,
                    );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildLessonCard(
                    lesson,
                    index + 1,
                    isCompleted,
                    isLocked,
                    chapterColor,
                  ),
                );
              }, childCount: chapter.lessons.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildLessonCard(
    Lesson lesson,
    int number,
    bool isCompleted,
    bool isLocked,
    Color chapterColor,
  ) {
    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isLocked
            ? null
            : () {
                Get.toNamed('/lesson-detail', arguments: lesson);
              },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCompleted ? chapterColor : Colors.grey.shade300,
              width: isCompleted ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Lesson Number
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? chapterColor
                      : isLocked
                      ? Colors.grey.shade300
                      : chapterColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : isLocked
                      ? Icon(Icons.lock, color: Colors.grey.shade600, size: 20)
                      : Text(
                          '$number',
                          style: AppTextStyles.h5.copyWith(color: chapterColor),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Lesson Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.lessonTitle,
                      style: AppTextStyles.h5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${lesson.durationMinutes} min',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${lesson.practice.length} exercises',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isLocked ? Colors.grey.shade400 : chapterColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
