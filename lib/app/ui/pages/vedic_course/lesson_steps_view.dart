import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/vedic_course_controller.dart';
import '../../../data/models/vedic_course_models.dart';
import '../../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LessonStepsView extends GetView<VedicCourseController> {
  const LessonStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Lesson lesson = Get.arguments as Lesson;
    
    // Use first example for the step-by-step demonstration
    final Example? firstExample = lesson.examples.isNotEmpty ? lesson.examples.first : null;
    
    if (firstExample == null) {
      // If no examples, go directly to practice
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(Routes.LESSON_PRACTICE, arguments: lesson);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final RxInt currentStep = 0.obs;
    final int totalSteps = _countSteps(firstExample) + 1; // +1 for final all-steps view
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          lesson.lessonTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              // Progress Indicator
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Break second number into tens ans ones',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildStepContent(currentStep.value, firstExample, lesson),
                ),
              ),
              
              // Bottom Button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentStep.value < totalSteps - 1) {
                        currentStep.value++;
                      } else {
                        // Go to practice grid
                        Get.toNamed(Routes.LESSON_PRACTICE, arguments: lesson);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _getButtonText(currentStep.value, totalSteps),
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
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
  
  String _getButtonText(int currentStep, int totalSteps) {
    if (currentStep == 0) return 'Step 1';
    if (currentStep == totalSteps - 2) return 'Step ${currentStep + 1}';
    if (currentStep == totalSteps - 1) return 'Practice';
    return 'Step ${currentStep + 1}';
  }
  
  Widget _buildStepContent(int step, Example example, Lesson lesson) {
    if (step == 0) {
      // Initial problem display
      return _buildProblemDisplay(example);
    }
    
    // Build progressive steps
    List<Widget> steps = [];
    int stepCounter = 1;
    
    if (step >= 1 && example.step1 != null) {
      steps.add(_buildStepCard(stepCounter++, example.step1!, example));
    }
    if (step >= 2 && example.step2 != null) {
      steps.add(const SizedBox(height: 16));
      steps.add(_buildStepCard(stepCounter++, example.step2!, example));
    }
    if (step >= 3 && example.step3 != null) {
      steps.add(const SizedBox(height: 16));
      steps.add(_buildStepCard(stepCounter++, example.step3!, example));
    }
    if (step >= 4 && example.step4 != null) {
      steps.add(const SizedBox(height: 16));
      steps.add(_buildStepCard(stepCounter++, example.step4!, example));
    }
    
    // Check if this is the final all-steps view
    final int totalPossibleSteps = _countSteps(example);
    if (step == totalPossibleSteps) {
      return _buildAllStepsView(example);
    }
    
    return Column(
      children: [
        _buildProblemDisplay(example),
        const SizedBox(height: 24),
        ...steps,
        const SizedBox(height: 20),
      ],
    );
  }
  
  Widget _buildProblemDisplay(Example example) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            example.problem ?? 'Problem',
            style: AppTextStyles.h2.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepCard(int stepNumber, String stepContent, Example example) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Step number badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$stepNumber',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            stepContent,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          
          // Show breakdown/calculation if available
          if (_hasBreakdown(example, stepNumber)) ...[
            const SizedBox(height: 24),
            _buildCalculationBreakdown(example, stepNumber),
          ],
        ],
      ),
    );
  }
  
  bool _hasBreakdown(Example example, int stepNumber) {
    // For step 1, show the breakdown if available in solution
    return stepNumber <= 2 && example.solution != null;
  }
  
  Widget _buildCalculationBreakdown(Example example, int stepNumber) {
    // Parse the problem to extract numbers
    final problem = example.problem ?? '';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Example: Show "52 = 50 + 2" for step 1
          if (stepNumber == 1) ...[
            Text(
              _extractFirstNumber(problem),
              style: AppTextStyles.h3.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '=',
              style: AppTextStyles.h4,
            ),
            const SizedBox(height: 12),
            Text(
              _getBreakdownText(problem, stepNumber),
              style: AppTextStyles.h3.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          
          // For other steps, show progressive calculation
          if (stepNumber > 1) ...[
            Text(
              example.solution ?? '',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
  
  String _extractFirstNumber(String problem) {
    final match = RegExp(r'(\d+)').firstMatch(problem);
    return match?.group(1) ?? '52';
  }
  
  String _getBreakdownText(String problem, int stepNumber) {
    // Extract first number and break it down
    final numStr = _extractFirstNumber(problem);
    final num = int.tryParse(numStr) ?? 52;
    
    final tens = (num ~/ 10) * 10;
    final ones = num % 10;
    
    return '$tens\n$ones';
  }
  
  Widget _buildAllStepsView(Example example) {
    List<Widget> allSteps = [];
    int stepCounter = 1;
    
    // Add step number indicator at top
    allSteps.add(
      Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$stepCounter',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Break second number into tens ans ones',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
    
    if (example.step1 != null) {
      allSteps.add(const SizedBox(height: 16));
      allSteps.add(_buildCompactStepCard(stepCounter++, example.step1!, example));
    }
    
    if (example.step2 != null) {
      allSteps.add(const SizedBox(height: 16));
      allSteps.add(_buildCompactStepCard(stepCounter++, example.step2!, example));
    }
    
    if (example.step3 != null) {
      allSteps.add(const SizedBox(height: 16));
      allSteps.add(_buildCompactStepCard(stepCounter++, example.step3!, example));
    }
    
    if (example.step4 != null) {
      allSteps.add(const SizedBox(height: 16));
      allSteps.add(_buildCompactStepCard(stepCounter++, example.step4!, example));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: allSteps,
    );
  }
  
  Widget _buildCompactStepCard(int stepNumber, String stepContent, Example example) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  stepContent,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
          
          if (_hasBreakdown(example, stepNumber)) ...[
            const SizedBox(height: 16),
            Center(
              child: _buildCalculationBreakdown(example, stepNumber),
            ),
          ],
        ],
      ),
    );
  }
}
