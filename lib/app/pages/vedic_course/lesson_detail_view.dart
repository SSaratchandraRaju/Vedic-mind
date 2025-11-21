import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/vedic_course_controller.dart';
import '../../data/models/vedic_course_models.dart';
import '../../routes/app_routes.dart';
import '../../services/tts_service.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';

class LessonDetailView extends GetView<VedicCourseController> {
  const LessonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Robust handling for Get.arguments: support Lesson instance, a Map containing
    // a 'lesson' key, or a serialized lesson Map. Show a friendly error if parsing fails.
    final dynamic arguments = Get.arguments;
    Lesson? lesson;
    if (arguments == null) {
      // No arguments provided
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(child: Text('Lesson data not found')),
      );
    }

    if (arguments is Lesson) {
      lesson = arguments;
    } else if (arguments is Map) {
      // If a map was passed, it might be { 'lesson': Lesson } or a serialized lesson map
      try {
        if (arguments.containsKey('lesson')) {
          final l = arguments['lesson'];
          if (l is Lesson) {
            lesson = l;
          } else if (l is Map) {
            lesson = Lesson.fromJson(
              Map<String, dynamic>.from(l.cast<String, dynamic>()),
            );
          }
        } else {
          // Try to treat the map directly as a Lesson json
          lesson = Lesson.fromJson(
            Map<String, dynamic>.from(arguments.cast<String, dynamic>()),
          );
        }
      } catch (e) {
        // Fall through to error below
        lesson = null;
      }
    }

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(child: Text('Invalid lesson data')),
      );
    }

    final TtsService ttsService = Get.find<TtsService>();

    // Get sequential lesson number from all lessons
    final allLessons = controller.getAllLessons();
    int lessonNumber = 1;
    for (int i = 0; i < allLessons.length; i++) {
      final lessonItem = allLessons[i]['lesson'] as Lesson;
      if (lessonItem.lessonId == lesson.lessonId) {
        lessonNumber = i + 1;
        break;
      }
    }

    // Create a map to track practice question answers and states
    final RxMap<int, String> userAnswers = <int, String>{}.obs;
    final RxMap<int, bool?> answerResults = <int, bool?>{}.obs;
    final RxInt correctAnswers = 0.obs;
    final RxBool allQuestionsAnswered = false.obs;

    // Initialize from saved data (if user has previously answered)
    for (int i = 0; i < lesson.practice.length; i++) {
      final question = lesson.practice[i];
      if (question.userAnswer != null && question.userAnswer!.isNotEmpty) {
        userAnswers[i] = question.userAnswer!;
        answerResults[i] = question.isCorrect;
        if (question.isCorrect == true) {
          correctAnswers.value++;
        }
      }
    }

    // Check if all questions are already answered
    if (answerResults.length == lesson.practice.length &&
        lesson.practice.isNotEmpty) {
      allQuestionsAnswered.value = true;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Gradient - Exactly like Sutra Detail
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.back, color: Colors.white),
                onPressed: () {
                  // Stop TTS when leaving the page
                  ttsService.stop();
                  Get.back();
                },
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Lesson $lessonNumber',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lesson.lessonTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lesson.objective,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${lesson.durationMinutes} min',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.lightbulb_outline,
                                size: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${lesson.examples.length} examples',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
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

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Objective Card - Like Sutra
                    _buildInfoCard(
                      icon: Icons.emoji_events,
                      title: 'Learning Objective',
                      content: lesson.objective,
                      color: const Color(0xFFFFA726),
                    ),
                    const SizedBox(height: 16),

                    // Why Learn This Section - Like Sutra
                    _buildWhyLearnCard(lesson.summary),
                    const SizedBox(height: 16),

                    // Start Interactive Lesson Button - Like Sutra
                    if (lesson.examples.isNotEmpty) ...[
                      _buildActionButton(
                        onPressed: () {
                          Get.toNamed(Routes.LESSON_STEPS, arguments: lesson);
                        },
                        icon: Icons.play_circle_filled,
                        label: 'Start Interactive Lesson',
                        isPrimary: true,
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Practice Problems Section - Like Sutra
                    if (lesson.practice.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Practice Problems (${lesson.practice.length})',
                        style: AppTextStyles.h5,
                      ),
                      const SizedBox(height: 12),
                      ...lesson.practice.asMap().entries.map((entry) {
                        return _buildPracticePreview(
                          entry.key + 1,
                          entry.value.question,
                        );
                      }).toList(),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        onPressed: () {
                          // Navigate to interactive steps with practice mode
                          Get.toNamed(
                            Routes.LESSON_STEPS,
                            arguments: {
                              'lesson': lesson,
                              'startPractice': true,
                            },
                          );
                        },
                        icon: Icons.edit_note,
                        label: 'Practice All Problems',
                        isPrimary: false,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Complete Lesson Section
                    _buildCompleteLessonSection(lesson),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyLearnCard(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF81C784).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Why Learn This?',
                style: AppTextStyles.h5.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: AppColors.primary, width: 2),
          ),
          elevation: isPrimary ? 2 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticePreview(int number, String problem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              problem,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gray400),
        ],
      ),
    );
  }

  Widget _buildTtsContentCard(Lesson lesson, TtsService ttsService) {
    return Obx(() {
      final isPlaying = ttsService.isPlaying.value;
      final isPaused = ttsService.isPaused.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Listen to Lesson Content',
                  style: AppTextStyles.h5.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Play/Pause/Stop Controls
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isPlaying && !isPaused) {
                        ttsService.pause();
                      } else if (isPaused) {
                        ttsService.resume();
                      } else {
                        String contentToRead = _prepareContentForReading(
                          lesson,
                        );
                        ttsService.speak(contentToRead);
                      }
                    },
                    icon: Icon(
                      isPlaying && !isPaused ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      isPlaying && !isPaused
                          ? 'Pause'
                          : isPaused
                          ? 'Resume'
                          : 'Play',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (isPlaying || isPaused) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ttsService.stop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.stop, color: Colors.white),
                  ),
                ],
              ],
            ),

            // Speed Control
            if (isPlaying || isPaused) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.speed, size: 16, color: AppColors.gray600),
                  const SizedBox(width: 8),
                  Text(
                    'Speed:',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: ttsService.speechRate.value,
                      min: 0.3,
                      max: 1.0,
                      divisions: 7,
                      label:
                          '${(ttsService.speechRate.value * 2).toStringAsFixed(1)}x',
                      onChanged: (value) {
                        ttsService.setSpeechRate(value);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${(ttsService.speechRate.value * 2).toStringAsFixed(1)}x',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            // Status indicator
            if (isPlaying && !isPaused) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reading content...',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],

            // Content Preview
            if (!isPlaying && !isPaused) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  lesson.content,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCompleteLessonSection(Lesson lesson) {
    // Create reactive variables for practice tracking
    final RxMap<int, String> userAnswers = <int, String>{}.obs;
    final RxMap<int, bool?> answerResults = <int, bool?>{}.obs;
    final RxInt correctAnswers = 0.obs;
    final RxBool allQuestionsAnswered = RxBool(lesson.practice.isEmpty);

    // Initialize from saved data
    for (int i = 0; i < lesson.practice.length; i++) {
      final question = lesson.practice[i];
      if (question.userAnswer != null && question.userAnswer!.isNotEmpty) {
        userAnswers[i] = question.userAnswer!;
        answerResults[i] = question.isCorrect;
        if (question.isCorrect == true) {
          correctAnswers.value++;
        }
      }
    }

    if (answerResults.length == lesson.practice.length &&
        lesson.practice.isNotEmpty) {
      allQuestionsAnswered.value = true;
    }

    return Obx(() {
      final bool canComplete =
          lesson.practice.isEmpty || allQuestionsAnswered.value;
      final int totalQuestions = lesson.practice.length;
      final int answered = correctAnswers.value;

      return Column(
        children: [
          if (totalQuestions > 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: canComplete
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: canComplete
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    canComplete ? Icons.check_circle : Icons.pending,
                    color: canComplete ? AppColors.success : AppColors.warning,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      canComplete
                          ? 'Great! You scored $answered/$totalQuestions. Ready to complete!'
                          : 'Complete all practice questions to proceed',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: canComplete
                            ? AppColors.success
                            : AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canComplete
                  ? () {
                      Get.find<VedicCourseController>().completeLesson(
                        lesson.lessonId,
                      );

                      lesson.isCompleted = true;
                      lesson.score = totalQuestions > 0
                          ? ((correctAnswers.value / totalQuestions) * 100)
                                .toInt()
                          : 100;

                      Get.back();
                      Get.snackbar(
                        'Lesson Complete!',
                        'Score: ${lesson.score}% - Great job! Keep learning.',
                        backgroundColor: AppColors.success,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppColors.gray200,
              ),
              child: Text(
                canComplete
                    ? 'Complete Lesson'
                    : 'Complete Practice Questions First',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildExampleCard(Example example, int number) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.yellow.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Example $number',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (example.problem != null) ...[
            Text(
              'Problem:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(example.problem!, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
          ],

          if (example.step1 != null) ...[_buildStep('Step 1', example.step1!)],
          if (example.step2 != null) ...[_buildStep('Step 2', example.step2!)],
          if (example.step3 != null) ...[_buildStep('Step 3', example.step3!)],
          if (example.step4 != null) ...[_buildStep('Step 4', example.step4!)],

          if (example.solution != null) ...[
            Text(
              'Solution:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(example.solution!, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
          ],

          if (example.answer != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Answer: ${example.answer}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (example.explanation != null) ...[
            const SizedBox(height: 8),
            Text(
              example.explanation!,
              style: AppTextStyles.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(content, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildInteractivePracticeQuestion(
    PracticeQuestion question,
    int index,
    RxMap<int, String> userAnswers,
    RxMap<int, bool?> answerResults,
    RxInt correctAnswers,
    RxBool allQuestionsAnswered,
    int totalQuestions,
  ) {
    final int number = index + 1;

    return Obx(() {
      final bool? isCorrect = answerResults[index];
      final String? userAnswer = userAnswers[index];

      Color borderColor = AppColors.border;
      Color backgroundColor = Colors.white;

      if (isCorrect == true) {
        borderColor = AppColors.success;
        backgroundColor = AppColors.success.withOpacity(0.05);
      } else if (isCorrect == false) {
        borderColor = AppColors.error;
        backgroundColor = AppColors.error.withOpacity(0.05);
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCorrect == true
                        ? AppColors.success
                        : isCorrect == false
                        ? AppColors.error
                        : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCorrect != null
                        ? Icon(
                            isCorrect ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 18,
                          )
                        : Text(
                            '$number',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Answer Input based on question type
            if (question.type == 'multiple_choice' &&
                question.options != null) ...[
              ...question.options!.asMap().entries.map((entry) {
                final option = entry.value;
                final isSelected = userAnswer == option;
                final isCorrectOption = option == question.answer;

                Color optionBorderColor = AppColors.border;
                Color optionBgColor = AppColors.gray50;

                if (isCorrect != null) {
                  if (isCorrectOption) {
                    optionBorderColor = AppColors.success;
                    optionBgColor = AppColors.success.withOpacity(0.1);
                  } else if (isSelected && !isCorrectOption) {
                    optionBorderColor = AppColors.error;
                    optionBgColor = AppColors.error.withOpacity(0.1);
                  }
                } else if (isSelected) {
                  optionBorderColor = AppColors.primary;
                  optionBgColor = AppColors.primary.withOpacity(0.1);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: isCorrect == null
                        ? () {
                            userAnswers[index] = option;
                          }
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: optionBgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: optionBorderColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.gray400,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isCorrect != null && isCorrectOption)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ] else if (question.type == 'input' ||
                question.type == 'fill_blank') ...[
              Directionality(
                textDirection: TextDirection.ltr,
                child: TextFormField(
                  enabled: isCorrect == null,
                  initialValue: userAnswer ?? '',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    userAnswers[index] = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Type your answer here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: isCorrect == null
                        ? Colors.white
                        : AppColors.gray100,
                  ),
                  style: AppTextStyles.bodyMedium,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],

            if (isCorrect != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.info,
                      color: isCorrect ? AppColors.success : AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isCorrect
                            ? 'Correct!'
                            : 'Correct answer: ${question.answer}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isCorrect
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (question.hint != null && isCorrect == null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Hint: ${question.hint}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Submit Answer Button
            if (isCorrect == null &&
                userAnswer != null &&
                userAnswer.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final bool correct =
                        userAnswer.trim().toLowerCase() ==
                        question.answer.trim().toLowerCase();

                    // Update reactive state
                    answerResults[index] = correct;
                    if (correct) {
                      correctAnswers.value++;
                      Get.find<VedicCourseController>().recordPracticeAttempt(
                        true,
                      );
                    } else {
                      Get.find<VedicCourseController>().recordPracticeAttempt(
                        false,
                      );
                    }

                    // Save to PracticeQuestion model (persists across visits)
                    question.userAnswer = userAnswer;
                    question.isCorrect = correct;

                    // Check if all questions are answered
                    if (answerResults.length == totalQuestions) {
                      allQuestionsAnswered.value = true;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit Answer',
                    style: AppTextStyles.button.copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// Build Text-to-Speech controls
  Widget _buildTtsControls(Lesson lesson, TtsService ttsService) {
    return Obx(() {
      final isPlaying = ttsService.isPlaying.value;
      final isPaused = ttsService.isPaused.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.volume_up, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Listen to Content',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Play/Pause/Stop Controls
            Row(
              children: [
                // Play/Pause Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isPlaying && !isPaused) {
                        ttsService.pause();
                      } else if (isPaused) {
                        ttsService.resume();
                      } else {
                        // Prepare content for reading
                        String contentToRead = _prepareContentForReading(
                          lesson,
                        );
                        ttsService.speak(contentToRead);
                      }
                    },
                    icon: Icon(
                      isPlaying && !isPaused ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      isPlaying && !isPaused
                          ? 'Pause'
                          : isPaused
                          ? 'Resume'
                          : 'Play',
                      style: AppTextStyles.button.copyWith(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Stop Button
                if (isPlaying || isPaused) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ttsService.stop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.stop, color: Colors.white),
                  ),
                ],
              ],
            ),

            // Speed Control
            if (isPlaying || isPaused) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.speed, size: 16, color: AppColors.gray600),
                  const SizedBox(width: 8),
                  Text(
                    'Speed:',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: ttsService.speechRate.value,
                      min: 0.3,
                      max: 1.0,
                      divisions: 7,
                      label:
                          '${(ttsService.speechRate.value * 2).toStringAsFixed(1)}x',
                      onChanged: (value) {
                        ttsService.setSpeechRate(value);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${(ttsService.speechRate.value * 2).toStringAsFixed(1)}x',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            // Status indicator
            if (isPlaying && !isPaused) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reading content...',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  /// Prepare lesson content for text-to-speech reading
  String _prepareContentForReading(Lesson lesson) {
    StringBuffer buffer = StringBuffer();

    // Add title
    buffer.writeln('Lesson: ${lesson.lessonTitle}.');
    buffer.writeln();

    // Add objective
    buffer.writeln('Objective: ${lesson.objective}.');
    buffer.writeln();

    // Add main content
    buffer.writeln('Content:');
    buffer.writeln(lesson.content);
    buffer.writeln();

    // Add summary
    buffer.writeln('Summary: ${lesson.summary}');

    return buffer.toString();
  }
}
