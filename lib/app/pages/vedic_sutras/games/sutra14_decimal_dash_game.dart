import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 14: Decimal Dash - Straight division using recurring decimals
class DecimalDashController extends SutraGameController {
  final RxInt numerator = 1.obs;
  final RxInt denominator = 9.obs;
  final RxString userAnswer = ''.obs;
  Timer? _gameTimer;

  final List<int> denominators = [9, 99, 999, 11, 33];

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
    denominator.value = denominators[random.nextInt(denominators.length)];
    numerator.value = 1 + random.nextInt(denominator.value - 1);
  }

  String _getCorrectAnswer() {
    final result = numerator.value / denominator.value;
    // Round to 4 decimal places
    return result.toStringAsFixed(4);
  }

  void submitAnswer() {
    if (userAnswer.value.isEmpty) return;

    try {
      final answer = userAnswer.value;
      final correct = _getCorrectAnswer();

      // Accept if first 4 decimals match
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

    showFeedback('✨ Perfect decimal! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
      userAnswer.value = '';
    });
  }

  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    final correct = _getCorrectAnswer();
    showFeedback('❌ Wrong! Answer: $correct', isCorrect: false);
  }

  void addDigit(String digit) {
    if (digit == '.' && userAnswer.value.contains('.')) return;
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

  String getHint() {
    if (denominator.value == 9) {
      return 'Hint: 1/9 = 0.111...  Pattern: digit repeats!';
    } else if (denominator.value == 99) {
      return 'Hint: 1/99 = 0.0101...  Two digits repeat!';
    } else if (denominator.value == 999) {
      return 'Hint: 1/999 = 0.001001...  Three digits repeat!';
    }
    return 'Hint: Find the recurring decimal pattern';
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class DecimalDashGame extends StatelessWidget {
  const DecimalDashGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DecimalDashController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Decimal Dash',
        backgroundColor: const Color(0xFFFFD60A),
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

  Widget _buildStartScreen(DecimalDashController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.percent, size: 100, color: Color(0xFFFFD60A)),
            const SizedBox(height: 24),
            const Text(
              'Decimal Dash',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Master recurring decimal patterns!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD60A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Convert fractions to decimals'),
                  Text('• Find recurring patterns'),
                  Text('• Use straight division method'),
                  Text('• Round to 4 decimal places'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD60A),
                foregroundColor: Colors.black,
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

  Widget _buildGameScreen(DecimalDashController controller) {
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
                  'Convert to decimal:',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  '${controller.numerator.value}/${controller.denominator.value} = ?',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD60A),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.getHint(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFFD60A),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.userAnswer.value.isEmpty
                        ? '0._'
                        : controller.userAnswer.value,
                    style: const TextStyle(
                      fontSize: 40,
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
          enableDecimal: true,
        ),
      ],
    );
  }
}
