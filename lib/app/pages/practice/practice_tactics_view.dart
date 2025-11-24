import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tactics_practice_controller.dart';
import '../../ui/widgets/game_widgets.dart';

class PracticeTacticsView extends GetView<TacticsPracticeController> {
  const PracticeTacticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        title: const Text(
          'Tactics Practice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6B4CE6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
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
                  timerColor = Colors.greenAccent;
                } else if (percentage > 0.25) {
                  timerColor = Colors.orangeAccent;
                } else {
                  timerColor = Colors.redAccent;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
          // Points Display
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFFF9800),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.totalPoints.value}',
                        style: const TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B4CE6)),
            ),
          );
        }

        if (controller.allQuestions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No practice questions available',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4CE6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        final question = controller.currentQuestion.value;
        if (question == null) {
          return const Center(child: Text('Loading question...'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${controller.currentQuestionIndex.value + 1}/${controller.totalQuestions.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B4CE6),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B4CE6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() => Text(
                          controller.currentTacticName.value,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B4CE6),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Question card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Question',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Answer box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF6B4CE6).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Your Answer',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            controller.userAnswer.value.isEmpty
                                ? '...'
                                : controller.userAnswer.value,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: controller.userAnswer.value.isEmpty
                                  ? Colors.grey[400]
                                  : const Color(0xFF1A1A1A),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(height: 8),
            // Hint section (collapsible) limited height
            if (question.hint != null && question.hint!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD54F),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: controller.showHint,
                            child: Row(
                              children: [
                                const Icon(Icons.lightbulb_outline,
                                    color: Color(0xFFFF9800), size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  controller.hintVisible.value ? 'Hint' : 'Show Hint',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFF9800),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  controller.hintVisible.value
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: const Color(0xFFFF9800),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          if (controller.hintVisible.value) ...[
                            const SizedBox(height: 8),
                            Text(
                              question.hint!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5D4037),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ],
                      ),
                    )),
              ),
            const SizedBox(height: 8),
            // Keyboard and actions occupy remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: PracticeKeyboard(
                        onCharacterPressed: controller.addCharacter,
                        onDelete: controller.deleteCharacter,
                        onSubmit: controller.submitAnswer,
                        submitColor: const Color(0xFF10B981),
                        deleteColor: const Color(0xFFEF4444),
                        tabColor: const Color(0xFF6B4CE6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controller.submitAnswer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B4CE6),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: controller.currentQuestionIndex.value > 0
                                  ? controller.previousQuestion
                                  : null,
                              icon: const Icon(Icons.arrow_back, size: 18),
                              label: const Text('Prev'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: Color(0xFF6B4CE6)),
                                foregroundColor: const Color(0xFF6B4CE6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: !controller.isLastQuestion
                                  ? controller.nextQuestion
                                  : null,
                              icon: const Icon(Icons.arrow_forward, size: 18),
                              label: const Text('Next'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: Color(0xFF6B4CE6)),
                                foregroundColor: const Color(0xFF6B4CE6),
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
          ],
        );
      }),
    );
  }
}
