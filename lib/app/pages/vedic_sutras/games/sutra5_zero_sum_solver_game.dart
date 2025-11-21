import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 5: Zero Sum Solver - When sum or difference is the same
class ZeroSumSolverController extends SutraGameController {
  final RxInt a = 1.obs; // Coefficient for first term
  final RxInt b = 1.obs; // Coefficient for second term
  final RxInt targetSum = 0.obs; // Target sum/constant
  final RxString userAnswer = ''.obs;
  Timer? _gameTimer;

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
    timeLeft.value = 75;
    isGameActive.value = false;
    isGameOver.value = false;
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
    final random = Random();
    // Generate equations where ax + by = targetSum
    // Special case: when a + b = target, use Shunyam Samyasamuccaye
    a.value = 1 + random.nextInt(9);
    b.value = 1 + random.nextInt(9);
    targetSum.value = a.value + b.value; // This creates the special case
  }

  int _getCorrectAnswer() {
    // When sum of coefficients equals constant, x = y = 0
    if (a.value + b.value == targetSum.value) {
      return 0;
    }
    // For other cases, find value that satisfies equation
    return targetSum.value ~/ (a.value + b.value);
  }

  void submitAnswer() {
    if (userAnswer.value.isEmpty) return;

    try {
      final answer = int.parse(userAnswer.value);
      final correct = _getCorrectAnswer();

      if (answer == correct) {
        _handleCorrectAnswer();
      } else {
        _handleWrongAnswer();
      }
    } catch (e) {
      showFeedback('Invalid number!', isCorrect: false);
    }
  }

  void _handleCorrectAnswer() {
    incrementCombo();
    final comboBonus = combo.value * 20;
    final points = 180 + comboBonus;
    updateScore(points);

    showFeedback('✨ Perfect! Zero sum principle! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
      userAnswer.value = '';
    });
  }

  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    final correct = _getCorrectAnswer();
    showFeedback('❌ Wrong! x = $correct', isCorrect: false);
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

  void addNegative() {
    if (userAnswer.value.isEmpty) {
      userAnswer.value = '-';
    }
  }

  String getEquation() {
    return '${a.value}x + ${b.value}y = ${targetSum.value}';
  }

  String getHint() {
    if (a.value + b.value == targetSum.value) {
      return 'Hint: Sum of coefficients (${a.value}+${b.value}) = constant ($targetSum)';
    }
    return 'Hint: Try small values for x and y';
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class ZeroSumSolverGame extends StatelessWidget {
  const ZeroSumSolverGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ZeroSumSolverController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Zero Sum Solver',
        backgroundColor: const Color(0xFFFF006E),
      ),
      body: Obx(() {
        if (!controller.isGameActive.value && !controller.isGameOver.value) {
          return _buildStartScreen(controller);
        }

        if (controller.isGameOver.value) {
          return Center(
            child: GameUI.buildGameOverDialog(
              finalScore: controller.score.value,
              maxCombo: controller.maxCombo.value,
              onReplay: controller.startGame,
              onExit: () => Get.back(),
            ),
          );
        }

        return _buildGameScreen(controller);
      }),
    );
  }

  Widget _buildStartScreen(ZeroSumSolverController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.functions, size: 100, color: Color(0xFFFF006E)),
            const SizedBox(height: 24),
            const Text(
              'Zero Sum Solver',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Master the Shunyam Samyasamuccaye!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF006E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Solve equations using zero sum'),
                  Text('• When sum = constant, x = 0'),
                  Text('• Example: 3x + 5y = 8'),
                  Text('• 3+5 = 8, so x = y = 0!'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF006E),
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

  Widget _buildGameScreen(ZeroSumSolverController controller) {
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
                const Text(
                  'Solve for x:',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.getEquation(),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF006E),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.getHint(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'x = ',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFFF006E),
                          width: 2,
                        ),
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
              ],
            ),
          ),
        ),
        GameNumberPad(
          onNumberPressed: controller.addDigit,
          onSubmit: controller.submitAnswer,
          onDelete: controller.deleteDigit,
          enableDecimal: false,
        ),
      ],
    );
  }
}
