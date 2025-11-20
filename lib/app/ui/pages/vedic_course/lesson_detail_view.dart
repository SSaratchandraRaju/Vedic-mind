import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/vedic_course_controller.dart';
import '../../../data/models/vedic_course_models.dart';
import '../../../routes/app_routes.dart';
import '../../../services/tts_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LessonDetailView extends GetView<VedicCourseController> {
  const LessonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Lesson lesson = Get.arguments as Lesson;
    final TtsService ttsService = Get.find<TtsService>();
    
    // Calculate chapter and lesson number from lessonId
    // lessonId format: 101, 102, 103 (chapter 1), 201, 202 (chapter 2), etc.
    final int chapterId = lesson.lessonId ~/ 100;
    final int lessonNumber = lesson.lessonId % 100;
    
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
    if (answerResults.length == lesson.practice.length && lesson.practice.isNotEmpty) {
      allQuestionsAnswered.value = true;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            // Stop TTS when leaving the page
            ttsService.stop();
            Get.back();
          },
        ),
        title: Text(
          'Lesson $chapterId.$lessonNumber',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Objective
            Text(
              lesson.lessonTitle,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learning Objective',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.objective,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Duration
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: AppColors.gray400),
                const SizedBox(width: 6),
                Text(
                  '${lesson.durationMinutes} minutes',
                  style: AppTextStyles.caption,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Start Interactive Learning Button (if examples exist)
            if (lesson.examples.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.LESSON_STEPS, arguments: lesson);
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: Text(
                    'Start Interactive Learning',
                    style: AppTextStyles.button,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Content Section
            _buildSectionHeader('Content', Icons.menu_book),
            const SizedBox(height: 12),
            
            // Text-to-Speech Controls
            _buildTtsControls(lesson, ttsService),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                lesson.content,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
              ),
            ),

            const SizedBox(height: 32),

            // Examples Section
            if (lesson.examples.isNotEmpty) ...[
              _buildSectionHeader('Examples', Icons.lightbulb_outline),
              const SizedBox(height: 12),
              ...lesson.examples.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildExampleCard(entry.value, entry.key + 1),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Practice Section
            if (lesson.practice.isNotEmpty) ...[
              _buildSectionHeader('Practice Exercises', Icons.fitness_center),
              const SizedBox(height: 12),
              ...lesson.practice.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildInteractivePracticeQuestion(
                    entry.value,
                    entry.key,
                    userAnswers,
                    answerResults,
                    correctAnswers,
                    allQuestionsAnswered,
                    lesson.practice.length,
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Summary Section
            _buildSectionHeader('Summary', Icons.summarize),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.success.withOpacity(0.1),
                    AppColors.success.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.stars, color: AppColors.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lesson.summary,
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Complete Lesson Button
            Obx(() {
              final bool canComplete = lesson.practice.isEmpty || allQuestionsAnswered.value;
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
                                color: canComplete ? AppColors.success : AppColors.warning,
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
                      onPressed: canComplete ? () {
                        controller.completeLesson(lesson.lessonId);
                        
                        // Update lesson completion in the model
                        lesson.isCompleted = true;
                        lesson.score = ((correctAnswers.value / totalQuestions) * 100).toInt();
                        
                        Get.back();
                        Get.snackbar(
                          'Lesson Complete!',
                          'Score: ${lesson.score}% - Great job! Keep learning.',
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      } : null,
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
                        canComplete ? 'Complete Lesson' : 'Complete Practice Questions First',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.h5,
        ),
      ],
    );
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
            Text(
              example.problem!,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
          ],

          if (example.step1 != null) ...[
            _buildStep('Step 1', example.step1!),
          ],
          if (example.step2 != null) ...[
            _buildStep('Step 2', example.step2!),
          ],
          if (example.step3 != null) ...[
            _buildStep('Step 3', example.step3!),
          ],
          if (example.step4 != null) ...[
            _buildStep('Step 4', example.step4!),
          ],

          if (example.solution != null) ...[
            Text(
              'Solution:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              example.solution!,
              style: AppTextStyles.bodyMedium,
            ),
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
          Expanded(
            child: Text(
              content,
              style: AppTextStyles.bodyMedium,
            ),
          ),
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
            if (question.type == 'multiple_choice' && question.options != null) ...[
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
                    onTap: isCorrect == null ? () {
                      userAnswers[index] = option;
                    } : null,
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
                            color: isSelected ? AppColors.primary : AppColors.gray400,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isCorrect != null && isCorrectOption)
                            Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ] else if (question.type == 'input' || question.type == 'fill_blank') ...[
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
                    fillColor: isCorrect == null ? Colors.white : AppColors.gray100,
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
                          color: isCorrect ? AppColors.success : AppColors.warning,
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
                  Icon(Icons.tips_and_updates, size: 16, color: AppColors.warning),
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
            if (isCorrect == null && userAnswer != null && userAnswer.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final bool correct = userAnswer.trim().toLowerCase() == 
                                       question.answer.trim().toLowerCase();
                    
                    // Update reactive state
                    answerResults[index] = correct;
                    if (correct) {
                      correctAnswers.value++;
                      Get.find<VedicCourseController>().recordPracticeAttempt(true);
                    } else {
                      Get.find<VedicCourseController>().recordPracticeAttempt(false);
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
                        String contentToRead = _prepareContentForReading(lesson);
                        ttsService.speak(contentToRead);
                      }
                    },
                    icon: Icon(
                      isPlaying && !isPaused 
                          ? Icons.pause 
                          : Icons.play_arrow,
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
                      label: '${(ttsService.speechRate.value * 2).toStringAsFixed(1)}x',
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
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
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
