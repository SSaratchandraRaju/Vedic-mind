import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/math_tables_test_controller.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/bottom_nav_bar.dart';

class MathTablesTestView extends GetView<MathTablesTestController> {
  const MathTablesTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            'Question ${controller.currentQuestionIndex.value + 1}/${MathTablesTestController.totalQuestions}',
            style: AppTextStyles.h5,
          ),
        ),
        centerTitle: true,
        actions: [
          // Timer Display
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Obx(() {
                final timeRemaining = controller.questionTimeRemaining.value;
                final timeLimit = controller.questionTimeLimit.value;
                final percentage = timeLimit > 0
                    ? timeRemaining / timeLimit
                    : 0.0;

                Color timerColor;
                if (percentage > 0.5) {
                  timerColor = Colors.green;
                } else if (percentage > 0.25) {
                  timerColor = Colors.orange;
                } else {
                  timerColor = Colors.red;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: timerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: timerColor, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, color: timerColor, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${timeRemaining}s',
                        style: TextStyle(
                          color: timerColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Score Display
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.score.value}/${MathTablesTestController.totalQuestions}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Obx(
            () => LinearProgressIndicator(
              value:
                  (controller.currentQuestionIndex.value + 1) /
                  MathTablesTestController.totalQuestions,
              backgroundColor: AppColors.gray100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 4,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                final question =
                    controller.questions[controller.currentQuestionIndex.value];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Question Section
                    Column(
                      children: [
                        const SizedBox(height: 20),

                        // Question Display
                        Text(
                          '${question.number1} × ${question.number2}',
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontFamily: 'Poppins',
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // Answer Input with Feedback
                        Obx(() {
                          final answer = controller.userAnswer.value;
                          final showFeedback = controller.showFeedback.value;
                          final isCorrect = controller.isCorrect.value;

                          return Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                height: 70,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: showFeedback
                                          ? (isCorrect
                                                ? Colors.green
                                                : Colors.red)
                                          : (answer.isEmpty
                                                ? Colors.grey[300]!
                                                : AppColors.primary),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  answer.isEmpty ? '' : answer,
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    color: showFeedback
                                        ? (isCorrect
                                              ? Colors.green
                                              : Colors.red)
                                        : (answer.isEmpty
                                              ? Colors.grey[400]
                                              : AppColors.textPrimary),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // Feedback Icon
                              if (showFeedback)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                    size: 32,
                                  ),
                                ),
                            ],
                          );
                        }),

                        // Show correct answer if wrong
                        Obx(() {
                          if (controller.showFeedback.value &&
                              !controller.isCorrect.value) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Correct answer: ${question.answer}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            );
                          }
                          return const SizedBox(height: 40);
                        }),
                      ],
                    ),

                    // Number Pad Section
                    Obx(() {
                      final showFeedback = controller.showFeedback.value;

                      return IgnorePointer(
                        ignoring: showFeedback,
                        child: Opacity(
                          opacity: showFeedback ? 0.5 : 1.0,
                          child: _buildNumberPad(),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),
          ),

          // Submit Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Obx(() {
              final showFeedback = controller.showFeedback.value;
              final hasAnswer = controller.userAnswer.value.isNotEmpty;

              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: hasAnswer && !showFeedback
                      ? controller.checkAnswer
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.gray100,
                    disabledForegroundColor: AppColors.textSecondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Answer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              );
            }),
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

  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: 1, 2, 3
          _buildNumberRow(['1', '2', '3']),
          const SizedBox(height: 12),

          // Row 2: 4, 5, 6
          _buildNumberRow(['4', '5', '6']),
          const SizedBox(height: 12),

          // Row 3: 7, 8, 9
          _buildNumberRow(['7', '8', '9']),
          const SizedBox(height: 12),

          // Row 4: 0, backspace
          Row(
            children: [
              // 0 button (wider)
              Expanded(flex: 2, child: _buildNumberButton('0', isWide: true)),
              const SizedBox(width: 12),

              // Backspace button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.backspace_outlined,
                  onTap: controller.onBackspace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      children: numbers.map((number) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: number != numbers.last ? 12 : 0),
            child: _buildNumberButton(number),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumberButton(String number, {bool isWide = false}) {
    return GestureDetector(
      onTap: () => controller.onNumberTap(number),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 28, color: AppColors.textPrimary),
      ),
    );
  }
}
