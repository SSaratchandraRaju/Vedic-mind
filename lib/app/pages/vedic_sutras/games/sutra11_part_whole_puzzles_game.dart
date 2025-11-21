import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 11: Part-Whole Puzzles - The product of the sum is the sum of the products
class PartWholePuzzlesController extends SutraGameController {
  final RxInt a = 2.obs;
  final RxInt b = 3.obs;
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
    timeLeft.value = 70;
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
    a.value = 2 + random.nextInt(9);
    b.value = 2 + random.nextInt(9);
  }

  int _getCorrectAnswer() {
    // (x+a)(x+b) = x² + (a+b)x + ab
    // We're asking for the constant term: ab
    return a.value * b.value;
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
    final comboBonus = combo.value * 18;
    final points = 165 + comboBonus;
    updateScore(points);

    showFeedback('🧩 Perfect expansion! +$points', isCorrect: true);
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

  String getExpression() {
    return '(x + ${a.value})(x + ${b.value})';
  }

  String getHint() {
    final sum = a.value + b.value;
    return 'Hint: Expands to x² + ${sum}x + ?';
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class PartWholePuzzlesGame extends StatelessWidget {
  const PartWholePuzzlesGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PartWholePuzzlesController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Part-Whole Puzzles',
        backgroundColor: const Color(0xFF9D4EDD),
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

  Widget _buildStartScreen(PartWholePuzzlesController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.extension, size: 100, color: Color(0xFF9D4EDD)),
            const SizedBox(height: 24),
            const Text(
              'Part-Whole Puzzles',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Master polynomial expansion!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9D4EDD).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Expand (x+a)(x+b)'),
                  Text('• Find the constant term'),
                  Text('• Use FOIL: First, Outer, Inner, Last'),
                  Text('• Constant = a × b'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D4EDD),
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

  Widget _buildGameScreen(PartWholePuzzlesController controller) {
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
                  'Find the constant term:',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.getExpression(),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9D4EDD),
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF9D4EDD),
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
