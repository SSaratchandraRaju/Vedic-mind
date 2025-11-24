import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/vedic_course_controller.dart';
import '../../data/models/vedic_course_models.dart';
import '../../services/tts_service.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/game_widgets.dart';

class LessonStepsView extends GetView<VedicCourseController> {
  const LessonStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Parse arguments - can be Lesson instance or a Map (with 'lesson' key or serialized lesson)
    final dynamic args = Get.arguments;
    late Lesson lesson;
    bool startInPracticeMode = false;

    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(child: Text('Lesson data not provided')),
      );
    }

    if (args is Lesson) {
      lesson = args;
    } else if (args is Map) {
      Lesson? parsed;
      try {
        if (args.containsKey('lesson')) {
          final l = args['lesson'];
          if (l is Lesson)
            parsed = l;
          else if (l is Map)
            parsed = Lesson.fromJson(
              Map<String, dynamic>.from(l.cast<String, dynamic>()),
            );
        } else {
          parsed = Lesson.fromJson(
            Map<String, dynamic>.from(args.cast<String, dynamic>()),
          );
        }
        startInPracticeMode = args['startPractice'] == true;
      } catch (e) {
        parsed = null;
      }

      if (parsed == null) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text('Error', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.primary,
          ),
          body: const Center(child: Text('Invalid lesson data')),
        );
      }

      lesson = parsed;
    }

    // If starting in practice mode and has practice questions, skip to practice
    if (startInPracticeMode && lesson.practice.isNotEmpty) {
      // Go directly to practice (we'll handle practice in this same view)
      return _buildPracticeView(lesson);
    }

    // Use first example for the step-by-step demonstration
    final Example? firstExample = lesson.examples.isNotEmpty
        ? lesson.examples.first
        : null;

    if (firstExample == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'No Examples Available',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 64, color: AppColors.gray400),
              const SizedBox(height: 16),
              Text(
                'No interactive examples available for this lesson yet.',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final RxInt currentStep = 0.obs;
    final int totalSteps = _countSteps(firstExample) + 1;
    final ttsService = Get.find<TtsService>();
    final RxBool ttsEnabled = true.obs;

    // Speak first step
    Future.delayed(const Duration(milliseconds: 500), () {
      if (ttsEnabled.value) {
        ttsService.speak("Let's solve: ${firstExample.problem ?? ''}");
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            ttsService.stop();
            Get.back();
          },
        ),
        title: Text(
          lesson.lessonTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                ttsEnabled.value ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
              ),
              onPressed: () {
                ttsEnabled.value = !ttsEnabled.value;
                if (!ttsEnabled.value) {
                  ttsService.stop();
                }
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              // Progress Bar
              Container(
                width: double.infinity,
                height: 4,
                color: Colors.grey[200],
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (currentStep.value + 1) / (totalSteps + 1),
                  child: Container(color: AppColors.primary),
                ),
              ),

              // Step Counter with TTS Speaker Icon (Fixed - doesn't scroll)
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Step ${currentStep.value + 1} of ${totalSteps + 1}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Speaker icon for current step (matches sutra UI)
                    if (ttsEnabled.value)
                      InkWell(
                        onTap: () => _speakCurrentStep(
                          ttsService,
                          ttsEnabled,
                          currentStep.value,
                          firstExample,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.volume_up,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Scrollable Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildStepContent(
                    currentStep.value,
                    firstExample,
                    lesson,
                  ),
                ),
              ),

              // Navigation Buttons (Fixed at bottom - doesn't scroll)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Previous Button
                    if (currentStep.value > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            currentStep.value--;
                            _speakCurrentStep(
                              ttsService,
                              ttsEnabled,
                              currentStep.value,
                              firstExample,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Previous',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Next/Start Practice Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentStep.value < totalSteps) {
                            currentStep.value++;
                            _speakCurrentStep(
                              ttsService,
                              ttsEnabled,
                              currentStep.value,
                              firstExample,
                            );
                          } else {
                            // Move to practice automatically without manual trigger
                            ttsService.stop();
                            if (lesson.practice.isNotEmpty) {
                              Get.off(() => _buildPracticeView(lesson));
                            } else {
                              // If no practice, mark lesson complete automatically
                              controller.completeLesson(lesson.lessonId);
                              lesson.isCompleted = true;
                              lesson.score = 100;
                              Get.back();
                              Get.snackbar(
                                'Lesson Complete!',
                                'Great job completing ${lesson.lessonTitle}!',
                                backgroundColor: AppColors.success,
                                colorText: Colors.white,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentStep.value >= totalSteps
                                  ? (lesson.practice.isNotEmpty ? 'Start Practice' : 'Finish')
                                  : 'Next',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              currentStep.value >= totalSteps
                                  ? (lesson.practice.isNotEmpty ? Icons.edit_note : Icons.check_circle)
                                  : Icons.arrow_forward,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _speakCurrentStep(
    TtsService tts,
    RxBool enabled,
    int step,
    Example example,
  ) {
    if (!enabled.value) return;

    String text = '';
    if (step == 0) {
      text = "Let's solve: ${example.problem ?? ''}";
    } else if (step == 1 && example.step1 != null) {
      text = 'Step 1. ${example.step1}';
    } else if (step == 2 && example.step2 != null) {
      text = 'Step 2. ${example.step2}';
    } else if (step == 3 && example.step3 != null) {
      text = 'Step 3. ${example.step3}';
    } else if (step == 4 && example.step4 != null) {
      text = 'Step 4. ${example.step4}';
    } else {
      text = 'Solution: ${example.solution ?? ''}';
    }

    if (text.isNotEmpty) {
      tts.speak(text);
    }
  }

  Widget _buildPracticeView(Lesson lesson) {
    final RxInt currentProblemIndex = 0.obs;
    final RxMap<int, String> userAnswers = <int, String>{}.obs;
    final RxMap<int, bool?> answerResults = <int, bool?>{}.obs;
    final RxInt correctAnswers = 0.obs;
    final ttsService = Get.find<TtsService>();
    final RxBool ttsEnabled = true.obs;

    // Speak first problem
    Future.delayed(const Duration(milliseconds: 500), () {
      if (ttsEnabled.value && lesson.practice.isNotEmpty) {
        ttsService.speak('Practice problem 1. ${lesson.practice[0].question}');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            ttsService.stop();
            Get.back();
          },
        ),
        title: Text(
          lesson.lessonTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                ttsEnabled.value ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
              ),
              onPressed: () {
                ttsEnabled.value = !ttsEnabled.value;
                if (!ttsEnabled.value) {
                  ttsService.stop();
                }
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        final currentIndex = currentProblemIndex.value;
        final problem = lesson.practice[currentIndex];
        final isAnswered = answerResults.containsKey(currentIndex);
        final isCorrect = answerResults[currentIndex];

        return Column(
          children: [
            // Progress Bar
            Container(
              width: double.infinity,
              height: 4,
              color: Colors.grey[200],
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (currentIndex + 1) / lesson.practice.length,
                child: Container(color: AppColors.secondary),
              ),
            ),

            // Problem Counter with TTS Speaker (Fixed - doesn't scroll)
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Problem ${currentIndex + 1} of ${lesson.practice.length}',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Speaker icon
                      if (ttsEnabled.value)
                        InkWell(
                          onTap: () {
                            if (ttsEnabled.value) {
                              ttsService.speak(problem.question);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.volume_up,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    'Score: ${correctAnswers.value}/${lesson.practice.length}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.secondary.withOpacity(0.1),
                            AppColors.primary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isAnswered
                              ? (isCorrect!
                                    ? AppColors.success
                                    : AppColors.error)
                              : AppColors.secondary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.quiz,
                            size: 48,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            problem.question,
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Answer Input Section - Multiple Choice or Number Pad
                    if (problem.type == 'multiple_choice' &&
                        problem.options != null &&
                        problem.options!.isNotEmpty) ...[
                      // MULTIPLE CHOICE OPTIONS
                      ...problem.options!.map((option) {
                        final currentAnswer = userAnswers[currentIndex] ?? '';
                        final isSelected = currentAnswer == option;
                        final isThisCorrect =
                            isAnswered && option == problem.answer;
                        final isThisWrong =
                            isAnswered &&
                            isSelected &&
                            option != problem.answer;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: isAnswered
                                ? null
                                : () {
                                    userAnswers[currentIndex] = option;
                                  },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isThisCorrect
                                    ? AppColors.success.withOpacity(0.1)
                                    : isThisWrong
                                    ? AppColors.error.withOpacity(0.1)
                                    : isSelected
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isThisCorrect
                                      ? AppColors.success
                                      : isThisWrong
                                      ? AppColors.error
                                      : isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isThisCorrect
                                            ? AppColors.success
                                            : isThisWrong
                                            ? AppColors.error
                                            : isSelected
                                            ? AppColors.primary
                                            : AppColors.border,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? (isThisCorrect
                                                ? AppColors.success
                                                : isThisWrong
                                                ? AppColors.error
                                                : AppColors.primary)
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isThisCorrect
                                            ? AppColors.success
                                            : isThisWrong
                                            ? AppColors.error
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  if (isThisCorrect)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.success,
                                      size: 24,
                                    ),
                                  if (isThisWrong)
                                    Icon(
                                      Icons.cancel,
                                      color: AppColors.error,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ] else ...[
                      // Show answer preview box for all typed answers
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isAnswered
                              ? (isCorrect!
                                    ? AppColors.success.withOpacity(0.1)
                                    : AppColors.error.withOpacity(0.1))
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isAnswered
                                ? (isCorrect!
                                      ? AppColors.success
                                      : AppColors.error)
                                : AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          (userAnswers[currentIndex] ?? '').isEmpty
                              ? 'Your answer...'
                              : (userAnswers[currentIndex] ?? ''),
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: (userAnswers[currentIndex] ?? '').isEmpty
                                ? AppColors.gray400
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Show PracticeKeyboard for all typed answers (numbers, text, mixed)
                      if (!isAnswered)
                        PracticeKeyboard(
                          onCharacterPressed: (character) {
                            userAnswers[currentIndex] =
                                (userAnswers[currentIndex] ?? '') + character;
                          },
                          onDelete: () {
                            final current = userAnswers[currentIndex] ?? '';
                            if (current.isNotEmpty) {
                              userAnswers[currentIndex] = current.substring(
                                0,
                                current.length - 1,
                              );
                            }
                          },
                          onSubmit: () {
                            final answer = userAnswers[currentIndex] ?? '';
                            if (answer.isNotEmpty) {
                              final correct =
                                  answer.trim().toLowerCase() ==
                                  problem.answer.trim().toLowerCase();
                              answerResults[currentIndex] = correct;
                              if (correct) {
                                correctAnswers.value++;
                                controller.recordPracticeAttempt(true);
                                if (ttsEnabled.value) {
                                  ttsService.speak('Correct! Well done!');
                                }
                              } else {
                                controller.recordPracticeAttempt(false);
                                if (ttsEnabled.value) {
                                  ttsService.speak(
                                    'Not quite right. The correct answer is ${problem.answer}',
                                  );
                                }
                              }
                              problem.userAnswer = answer;
                              problem.isCorrect = correct;
                              // If last problem answered, auto-complete lesson
                              if (currentProblemIndex.value >= lesson.practice.length - 1) {
                                controller.completeLesson(lesson.lessonId);
                                lesson.isCompleted = true;
                                lesson.score = ((correctAnswers.value / lesson.practice.length) * 100).toInt();
                                ttsService.stop();
                                Get.back();
                                Get.snackbar(
                                  'Lesson Complete!',
                                  'Score: ${lesson.score}% - Great job!',
                                  backgroundColor: AppColors.success,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 3),
                                );
                              }
                            }
                          },
                          submitColor: AppColors.success,
                          deleteColor: AppColors.error,
                          tabColor: AppColors.primary,
                        ),
                    ],

                    const SizedBox(height: 24),
                    if (!isAnswered && (problem.type == 'multiple_choice')) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final answer = userAnswers[currentIndex] ?? '';
                            if (answer.isNotEmpty) {
                              final correct =
                                  answer.trim().toLowerCase() ==
                                  problem.answer.trim().toLowerCase();
                              answerResults[currentIndex] = correct;
                              if (correct) {
                                correctAnswers.value++;
                                controller.recordPracticeAttempt(true);
                                if (ttsEnabled.value) {
                                  ttsService.speak('Correct! Well done!');
                                }
                              } else {
                                controller.recordPracticeAttempt(false);
                                if (ttsEnabled.value) {
                                  ttsService.speak(
                                    'Not quite right. The correct answer is ${problem.answer}',
                                  );
                                }
                              }
                              problem.userAnswer = answer;
                              problem.isCorrect = correct;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit Answer',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],

                    if (isAnswered) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isCorrect!
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCorrect
                                ? AppColors.success
                                : AppColors.warning,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.info,
                              color: isCorrect
                                  ? AppColors.success
                                  : AppColors.warning,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isCorrect ? 'Correct!' : 'Not quite right',
                                    style: AppTextStyles.h5.copyWith(
                                      color: isCorrect
                                          ? AppColors.success
                                          : AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!isCorrect) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Correct answer: ${problem.answer}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (problem.hint != null && !isAnswered) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Hint: ${problem.hint}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (currentIndex > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          currentProblemIndex.value--;
                          if (ttsEnabled.value) {
                            ttsService.speak(
                              'Problem ${currentProblemIndex.value + 1}. ${lesson.practice[currentProblemIndex.value].question}',
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentIndex < lesson.practice.length - 1) {
                          currentProblemIndex.value++;
                          if (ttsEnabled.value) {
                            ttsService.speak(
                              'Problem ${currentProblemIndex.value + 1}. ${lesson.practice[currentProblemIndex.value].question}',
                            );
                          }
                        } else {
                          // Auto complete lesson (removed manual button requirement)
                          controller.completeLesson(lesson.lessonId);
                          lesson.isCompleted = true;
                          if (lesson.practice.isNotEmpty) {
                            lesson.score = ((correctAnswers.value / lesson.practice.length) * 100).toInt();
                          } else {
                            lesson.score = 100;
                          }
                          ttsService.stop();
                          // Navigate back to lessons list (Vedic Tactics page)
                          Get.back();
                          Get.snackbar(
                            'Lesson Complete!',
                            'Score: ${lesson.score}% - Great job!',
                            backgroundColor: AppColors.success,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        currentIndex >= lesson.practice.length - 1
                            ? 'Finish'
                            : 'Next Problem',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  int _countSteps(Example example) {
    int count = 1; // Initial problem display
    if (example.step1 != null) count++;
    if (example.step2 != null) count++;
    if (example.step3 != null) count++;
    if (example.step4 != null) count++;
    return count;
  }

  Widget _buildStepContent(int step, Example example, Lesson lesson) {
    // Show ONLY the current step (not accumulative like before)
    if (step == 0) {
      // Step 0: Show the problem
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.gradientEnd.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
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
                        Icons.lightbulb,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Let's solve this problem",
                        style: AppTextStyles.h5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    example.problem ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Follow each step carefully. This technique makes calculations faster and easier!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Step 1-4: Show ONLY the current step
    String? stepDescription;
    String? stepDisplay;

    if (step == 1 && example.step1 != null) {
      stepDescription = 'Step 1';
      stepDisplay = example.step1;
    } else if (step == 2 && example.step2 != null) {
      stepDescription = 'Step 2';
      stepDisplay = example.step2;
    } else if (step == 3 && example.step3 != null) {
      stepDescription = 'Step 3';
      stepDisplay = example.step3;
    } else if (step == 4 && example.step4 != null) {
      stepDescription = 'Step 4';
      stepDisplay = example.step4;
    } else {
      // Final step: Show solution
      stepDescription = 'Solution';
      stepDisplay = example.solution;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.gradientEnd.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
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
                      Icons.lightbulb,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(stepDescription, style: AppTextStyles.h5),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stepDisplay ?? '',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        if (step == _countSteps(example)) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    example.explanation ??
                        'Great! You\'ve completed this example.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}