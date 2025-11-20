import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/enhanced_vedic_course_controller.dart';
import '../../../data/models/sutra_simple_model.dart';
import '../../../data/vedic_sutra_examples.dart';
import '../../../services/tts_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class InteractiveLessonViewController extends GetxController {
  final EnhancedVedicCourseController courseController;
  late final TtsService ttsService;
  
  InteractiveLessonViewController(this.courseController);
  
  late SutraSimpleModel sutra;
  late SutraExample example;
  
  final currentStep = 0.obs;
  final currentProblemIndex = 0.obs;
  final currentPracticeStep = 0.obs;
  final userStepAnswers = <String>[].obs;
  final showStepHint = false.obs;
  final showFeedback = false.obs;
  final isCorrect = false.obs;
  final attempts = 0.obs;
  final ttsEnabled = true.obs; // TTS enabled by default
  final isPracticeMode = false.obs;
  
  List<PracticeStep> practiceSteps = [];
  
  @override
  void onInit() {
    super.onInit();
    
    // Initialize TTS service
    ttsService = Get.find<TtsService>();
    
    final args = Get.arguments as Map<String, dynamic>;
    sutra = args['sutra'];
    isPracticeMode.value = args['startPractice'] ?? false;
    
    // Load example for this sutra
    example = VedicSutraExamples.getExample(sutra.sutraId);
    
    // Speak welcome message if TTS enabled
    if (ttsEnabled.value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _speakText(example.steps[0].audioText);
      });
    }
    
    if (isPracticeMode.value) {
      _loadPracticeSteps();
    }
  }
  
  void _loadPracticeSteps() {
    if (sutra.practice.isNotEmpty) {
      final problem = sutra.practice[currentProblemIndex.value].problem;
      practiceSteps = VedicSutraExamples.getPracticeSteps(sutra.sutraId, problem);
      userStepAnswers.value = List.filled(practiceSteps.length, '');
    }
  }
  
  @override
  void onClose() {
    ttsService.stop();
    super.onClose();
  }
  
  void toggleTts() {
    ttsEnabled.value = !ttsEnabled.value;
    if (!ttsEnabled.value) {
      ttsService.stop();
    }
  }
  
  void _speakText(String text) {
    if (ttsEnabled.value) {
      ttsService.speak(text);
    }
  }
  
  void nextStep() {
    if (currentStep.value < example.steps.length - 1) {
      currentStep.value++;
      showFeedback.value = false;
      if (ttsEnabled.value) {
        _speakText(example.steps[currentStep.value].audioText);
      }
    }
  }
  
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      showFeedback.value = false;
      if (ttsEnabled.value) {
        _speakText(example.steps[currentStep.value].audioText);
      }
    }
  }
  
  void speakCurrentStep() {
    if (currentStep.value < example.steps.length) {
      _speakText(example.steps[currentStep.value].audioText);
    }
  }
  
  void toggleStepHint() {
    showStepHint.value = !showStepHint.value;
    if (showStepHint.value) {
      // Track hint usage
      courseController.updateSutraProgress(
        sutraId: sutra.sutraId,
        isCorrect: true, // Don't count as wrong, but will reduce accuracy
        usedHint: true,
      );
      
      if (ttsEnabled.value) {
        final hint = practiceSteps[currentPracticeStep.value].hint;
        _speakText(hint);
      }
    }
  }
  
  void updateStepAnswer(String value) {
    if (currentPracticeStep.value < userStepAnswers.length) {
      userStepAnswers[currentPracticeStep.value] = value;
      userStepAnswers.refresh();
    }
  }
  
  void checkStepAnswer() {
    final step = practiceSteps[currentPracticeStep.value];
    final userAnswer = userStepAnswers[currentPracticeStep.value].trim();
    
    if (userAnswer == step.expectedAnswer) {
      // Correct answer
      isCorrect.value = true;
      showFeedback.value = true;
      showStepHint.value = false;
      
      // Track progress - correct answer
      courseController.updateSutraProgress(
        sutraId: sutra.sutraId,
        isCorrect: true,
        usedHint: showStepHint.value,
      );
      
      if (ttsEnabled.value) {
        _speakText('Correct! Well done.');
      }
      
      // Auto-advance to next step after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        if (currentPracticeStep.value < practiceSteps.length - 1) {
          currentPracticeStep.value++;
          showFeedback.value = false;
          isCorrect.value = false;
          showStepHint.value = false;
        } else {
          // Completed all steps
          _handlePracticeComplete();
        }
      });
    } else {
      // Incorrect answer - show hint
      isCorrect.value = false;
      showFeedback.value = true;
      showStepHint.value = true;
      attempts.value++;
      
      // Track progress - wrong answer
      courseController.updateSutraProgress(
        sutraId: sutra.sutraId,
        isCorrect: false,
        usedHint: false,
      );
      
      if (ttsEnabled.value) {
        _speakText('Not quite right. ${step.hint}');
      }
    }
  }
  
  void _handlePracticeComplete() {
    // Award XP based on attempts
    final xpReward = attempts.value == 0 ? 100 : (attempts.value <= 2 ? 75 : 50);
    courseController.awardXP(xpReward);
    
    if (ttsEnabled.value) {
      _speakText('Excellent! Problem completed. You earned $xpReward XP');
    }
    
    showFeedback.value = true;
    isCorrect.value = true;
    
    // Move to next problem after celebration
    Future.delayed(const Duration(seconds: 2), () {
      nextProblem();
    });
  }
  
  void nextProblem() {
    if (currentProblemIndex.value < sutra.practice.length - 1) {
      currentProblemIndex.value++;
      currentPracticeStep.value = 0;
      attempts.value = 0;
      showFeedback.value = false;
      showStepHint.value = false;
      _loadPracticeSteps();
    } else {
      // Completed all problems
      Get.back();
      Get.snackbar(
        'Congratulations! 🎉',
        'You\'ve completed all practice problems for this sutra!',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        icon: const Icon(Icons.celebration, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  void skipProblem() {
    nextProblem();
  }
}

class InteractiveLessonView extends GetView<EnhancedVedicCourseController> {
  const InteractiveLessonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lessonController = Get.put(InteractiveLessonViewController(controller));
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          lessonController.sutra.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          // TTS Toggle Button
          Obx(() => IconButton(
            icon: Icon(
              lessonController.ttsEnabled.value 
                  ? Icons.volume_up 
                  : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: () => lessonController.toggleTts(),
            tooltip: lessonController.ttsEnabled.value 
                ? 'Disable voice' 
                : 'Enable voice',
          )),
        ],
      ),
      body: Obx(() {
        return lessonController.isPracticeMode.value
            ? _buildPracticeMode(lessonController)
            : _buildExampleMode(lessonController);
      }),
    );
  }
  
  Widget _buildExampleMode(InteractiveLessonViewController lessonController) {
    return SafeArea(
      child: Column(
        children: [
          // Progress Bar
          Obx(() => Container(
            width: double.infinity,
            height: 4,
            color: Colors.grey[200],
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (lessonController.currentStep.value + 1) / 
                          lessonController.example.steps.length,
              child: Container(
                color: AppColors.primary,
              ),
            ),
          )),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Counter with TTS Speaker Icon
                  Obx(() => Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Step ${lessonController.currentStep.value + 1} of ${lessonController.example.steps.length}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Small speaker icon for current step
                      Obx(() => lessonController.ttsEnabled.value
                          ? InkWell(
                              onTap: () => lessonController.speakCurrentStep(),
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
                            )
                          : const SizedBox.shrink()),
                    ],
                  )),
                  
                  const SizedBox(height: 20),
                  
                  // Step Description Card
                  Obx(() => Container(
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
                                lessonController.example.steps[lessonController.currentStep.value].description,
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
                            lessonController.example.steps[lessonController.currentStep.value].display,
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
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // Why This Matters Card
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
                        const Icon(Icons.info_outline, color: AppColors.secondary, size: 24),
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
              ),
            ),
          ),
          
          // Navigation Buttons
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
            child: Obx(() => Row(
              children: [
                // Previous Button
                if (lessonController.currentStep.value > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => lessonController.previousStep(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primary, width: 2),
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
                
                if (lessonController.currentStep.value > 0)
                  const SizedBox(width: 12),
                
                // Next/Start Practice Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (lessonController.currentStep.value < lessonController.example.steps.length - 1) {
                        lessonController.nextStep();
                      } else {
                        lessonController.isPracticeMode.value = true;
                        lessonController.currentProblemIndex.value = 0;
                        lessonController._loadPracticeSteps();
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
                          lessonController.currentStep.value < lessonController.example.steps.length - 1
                              ? 'Next'
                              : 'Start Practice',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          lessonController.currentStep.value < lessonController.example.steps.length - 1
                              ? Icons.arrow_forward
                              : Icons.edit_note,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPracticeMode(InteractiveLessonViewController lessonController) {
    return SafeArea(
      child: Column(
        children: [
          // Problem Counter
          Obx(() => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.gradientEnd],
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Problem ${lessonController.currentProblemIndex.value + 1} of ${lessonController.sutra.practice.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (lessonController.practiceSteps.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Step ${lessonController.currentPracticeStep.value + 1} of ${lessonController.practiceSteps.length}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          )),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                if (lessonController.practiceSteps.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final problem = lessonController.sutra.practice[lessonController.currentProblemIndex.value];
                final currentStep = lessonController.practiceSteps[lessonController.currentPracticeStep.value];
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Problem Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Problem',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            problem.problem,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Current Step Instruction with Hint Icon
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            currentStep.instruction,
                            style: AppTextStyles.h5.copyWith(fontSize: 16),
                          ),
                        ),
                        // Hint Icon with Speaker
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => lessonController.toggleStepHint(),
                              icon: Icon(
                                lessonController.showStepHint.value 
                                    ? Icons.lightbulb 
                                    : Icons.lightbulb_outline,
                                color: AppColors.secondary,
                              ),
                              tooltip: 'Show hint',
                            ),
                            if (lessonController.ttsEnabled.value && lessonController.showStepHint.value)
                              IconButton(
                                onPressed: () {
                                  lessonController.ttsService.speak(currentStep.hint);
                                },
                                icon: const Icon(
                                  Icons.volume_up,
                                  color: AppColors.secondary,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Show Formula/Hint
                    if (lessonController.showStepHint.value) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.secondary.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  color: AppColors.secondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Hint',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentStep.hint,
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Formula: ${currentStep.formula}',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontFamily: 'monospace',
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    // Answer Input
                    Text(
                      'Your Answer',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => lessonController.updateStepAnswer(value),
                      decoration: InputDecoration(
                        hintText: 'Enter your answer for this step',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 18),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Check Answer Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => lessonController.checkStepAnswer(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle),
                            SizedBox(width: 8),
                            Text(
                              'Check Answer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Feedback Card
                    if (lessonController.showFeedback.value)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: lessonController.isCorrect.value
                              ? const Color(0xFF10B981).withOpacity(0.1)
                              : const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: lessonController.isCorrect.value
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              lessonController.isCorrect.value
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: lessonController.isCorrect.value
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lessonController.isCorrect.value
                                        ? 'Correct! 🎉'
                                        : 'Try Again',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: lessonController.isCorrect.value
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFEF4444),
                                    ),
                                  ),
                                  if (!lessonController.isCorrect.value) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Expected: ${currentStep.expectedAnswer}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentStep.hint,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                  if (lessonController.isCorrect.value && 
                                      lessonController.currentPracticeStep.value == lessonController.practiceSteps.length - 1) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Problem completed! +${lessonController.attempts.value == 0 ? 100 : (lessonController.attempts.value <= 2 ? 75 : 50)} XP',
                                      style: const TextStyle(
                                        fontSize: 14,
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
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
