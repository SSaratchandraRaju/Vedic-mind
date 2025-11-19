import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/vedic_course_controller.dart';
import '../../../data/models/vedic_course_models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LessonPracticeView extends GetView<VedicCourseController> {
  const LessonPracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Lesson lesson = Get.arguments as Lesson;
    final Example? firstExample = lesson.examples.isNotEmpty ? lesson.examples.first : null;
    
    // Generate practice problems based on the lesson example
    final List<String> practiceProblems = _generatePracticeProblems(firstExample);
    
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
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.help_outline, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Break second number into tens ans ones',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Practice Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: practiceProblems.length,
                  itemBuilder: (context, index) {
                    return _buildPracticeCard(practiceProblems[index]);
                  },
                ),
              ),
            ),
            
            // Start Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to lesson detail to do actual practice
                    Get.back();
                    Get.back();
                    
                    Get.snackbar(
                      'Ready to Practice!',
                      'Complete the practice exercises below',
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
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
                    'Start',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPracticeCard(String problem) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          problem,
          style: AppTextStyles.h5.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  
  List<String> _generatePracticeProblems(Example? example) {
    // Generate 10 similar practice problems
    if (example == null || example.problem == null) {
      return List.generate(10, (index) => '52 + 19');
    }
    
    // Parse the original problem to get the pattern
    final problem = example.problem!;
    final operatorMatch = RegExp(r'[+\-×÷]').firstMatch(problem);
    final operator = operatorMatch?.group(0) ?? '+';
    
    final numbers = RegExp(r'\d+').allMatches(problem).map((m) => int.tryParse(m.group(0)!) ?? 0).toList();
    
    if (numbers.length < 2) {
      return List.generate(10, (index) => '52 + 19');
    }
    
    final baseNum1 = numbers[0];
    final baseNum2 = numbers[1];
    
    // Generate similar problems
    final List<String> problems = [];
    for (int i = 0; i < 10; i++) {
      final num1 = baseNum1 + (i % 3) * 5 - 5; // Vary around base
      final num2 = baseNum2 + (i % 4) * 3 - 3; // Vary around base
      problems.add('$num1 $operator $num2');
    }
    
    return problems;
  }
}
