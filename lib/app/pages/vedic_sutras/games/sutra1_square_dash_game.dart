import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../ui/theme/app_colors.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 1: Square Dash - Fast squaring numbers ending in 5
class SquareDashController extends SutraGameController {
  final RxInt currentNumber = 15.obs;
  final RxString userAnswer = ''.obs;
  final RxList<int> answeredNumbers = <int>[].obs;
  Timer? _gameTimer;

  final List<int> numbers = [15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125];

  @override
  void startGame() {
    resetGame();
    isGameActive.value = true;
    _generateNewProblem();
    _startTimer();
  }

  @override
  void resetGame() {
    score.value = 0;
    lives.value = 3;
    combo.value = 0;
    maxCombo.value = 0;
    timeLeft.value = 60;
    isGameActive.value = false;
    isGameOver.value = false;
    answeredNumbers.clear();
    userAnswer.value = '';
    _gameTimer?.cancel();
  }

  @override
  void endGame() {
    isGameActive.value = false;
    isGameOver.value = true;
    _gameTimer?.cancel();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        endGame();
      }
    });
  }

  void _generateNewProblem() {
    final available = numbers
        .where((n) => !answeredNumbers.contains(n))
        .toList();
    if (available.isEmpty) {
      answeredNumbers.clear();
    }
    currentNumber.value = available[Random().nextInt(available.length)];
  }

  int _calculateCorrectAnswer() {
    final num = currentNumber.value;
    final tens = num ~/ 10;
    return tens * (tens + 1) * 100 + 25;
  }

  void submitAnswer() {
    if (userAnswer.value.isEmpty) return;

    try {
      final answer = int.parse(userAnswer.value);
      final correct = _calculateCorrectAnswer();

      if (answer == correct) {
        _handleCorrectAnswer();
      } else {
        _handleWrongAnswer();
      }
    } catch (e) {
      showFeedback('Invalid number!', isCorrect: false);
    }

    userAnswer.value = '';
  }

  void _handleCorrectAnswer() {
    incrementCombo();
    final comboBonus = combo.value * 10;
    final points = 100 + comboBonus;
    updateScore(points);

    answeredNumbers.add(currentNumber.value);
    showFeedback(
      '🔥 Correct! +$points (${combo.value}x combo)',
      isCorrect: true,
    );
    _generateNewProblem();
  }

  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    showFeedback(
      '❌ Wrong! Answer: ${_calculateCorrectAnswer()}',
      isCorrect: false,
    );
  }

  void addDigit(String digit) {
    userAnswer.value += digit;
  }

  void deleteDigit() {
    if (userAnswer.value.isNotEmpty) {
      userAnswer.value = userAnswer.value.substring(
        0,
        userAnswer.value.length - 1,
      );
    }
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class SquareDashGame extends StatelessWidget {
  const SquareDashGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SquareDashController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Square Dash',
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (!controller.isGameActive.value && !controller.isGameOver.value) {
          return _buildStartScreen(controller);
        }

        if (controller.isGameOver.value) {
          return _buildGameOverScreen(controller);
        }

        return _buildGameScreen(controller);
      }),
    );
  }

  Widget _buildStartScreen(SquareDashController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flash_on, size: 100, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              'Square Dash',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Square numbers ending in 5 as fast as you can!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Square numbers like 25², 35², 45²'),
                  Text('• Formula: n×(n+1), then append 25'),
                  Text('• Example: 35² → 3×4=12, so 1225'),
                  Text('• Build combos for bonus points!'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'START GAME',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameScreen(SquareDashController controller) {
    return Column(
      children: [
        GameUI.buildScoreBar(
          score: controller.score.value,
          lives: controller.lives.value,
          combo: controller.combo.value,
          timeLeft: controller.timeLeft.value,
        ),

        GameUI.buildFeedback(controller.feedback.value),

        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Square this number:',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  '${controller.currentNumber.value}²',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.userAnswer.value.isEmpty
                        ? '_'
                        : controller.userAnswer.value,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),

        GameNumberPad(
          onNumberPressed: controller.addDigit,
          onSubmit: controller.submitAnswer,
          onDelete: controller.deleteDigit,
        ),
      ],
    );
  }

  Widget _buildGameOverScreen(SquareDashController controller) {
    return GameUI.buildGameOverDialog(
      finalScore: controller.score.value,
      maxCombo: controller.maxCombo.value,
      onReplay: controller.startGame,
      onExit: () => Get.back(),
    );
  }
}
