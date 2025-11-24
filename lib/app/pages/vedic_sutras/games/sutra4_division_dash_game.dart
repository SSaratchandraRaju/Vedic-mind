import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vedicmind/app/ui/theme/app_text_styles.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 4: Division Dash - Transpose and divide
class DivisionDashController extends SutraGameController {
  final RxInt dividend = 100.obs;
  final RxInt divisor = 19.obs;
  final RxString userAnswer = ''.obs;
  Timer? _gameTimer;

  final List<int> divisors = [9, 11, 19, 21, 29, 31, 39, 41, 49, 51];

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
    timeLeft.value = 90;
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
    divisor.value = divisors[random.nextInt(divisors.length)];
    dividend.value = (10 + random.nextInt(90)) * 10; // 100-1000 multiples of 10
  }

  double _getCorrectAnswer() {
    return dividend.value / divisor.value;
  }

  void submitAnswer() {
    if (userAnswer.value.isEmpty) return;

    try {
      final answer = double.parse(userAnswer.value);
      final correct = _getCorrectAnswer();

      // Accept if within 0.5 tolerance
      if ((answer - correct).abs() < 0.5) {
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
    final comboBonus = combo.value * 15;
    final points = 150 + comboBonus;
    updateScore(points);

    showFeedback('🎯 Correct division! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
      userAnswer.value = '';
    });
  }

  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    final correct = _getCorrectAnswer().toStringAsFixed(1);
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
    // Transpose hint
    final base = (divisor.value ~/ 10 + 1) * 10;
    final diff = base - divisor.value;
    return 'Hint: Think of $divisor as ($base - $diff)';
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class DivisionDashGame extends StatelessWidget {
  const DivisionDashGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DivisionDashController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Division Dash',
        backgroundColor: const Color(0xFF8338EC),
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

  Widget _buildStartScreen(DivisionDashController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate, size: 100, color: Color(0xFF8338EC)),
            const SizedBox(height: 24),
            const Text(
              'Division Dash',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transpose divisors and solve quickly!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8338EC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Divide numbers by transposing'),
                  Text('• Think: 19 = (20 - 1)'),
                  Text('• Use base method for faster division'),
                  Text('• Round to 1 decimal place'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8338EC),
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

  Widget _buildGameScreen(DivisionDashController controller) {
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
                  '${controller.dividend.value} ÷ ${controller.divisor.value} = ?',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8338EC),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.getHint(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
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
                      color: const Color(0xFF8338EC),
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
          enableDecimal: true, // Division needs decimal support
        ),
      ],
    );
  }
}
