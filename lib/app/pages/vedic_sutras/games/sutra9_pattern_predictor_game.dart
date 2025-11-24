import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vedicmind/app/ui/theme/app_text_styles.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 9: Pattern Predictor - Spot sequences and predict next number
class PatternPredictorController extends SutraGameController {
  final RxList<int> sequence = <int>[].obs;
  final RxString patternType = ''.obs;
  final RxList<int> options = <int>[].obs;
  final RxInt correctAnswer = 0.obs;
  Timer? _gameTimer;

  final List<String> patterns = [
    'squares', // 1, 4, 9, 16, 25...
    'cubes', // 1, 8, 27, 64...
    'fibonacci', // 1, 1, 2, 3, 5, 8...
    'arithmetic', // +2, +3, +4 etc.
    'geometric', // ×2, ×3 etc.
    'triangular', // 1, 3, 6, 10, 15...
  ];

  @override
  void startGame() {
    resetGame();
    isGameActive.value = true;
    _generateNewPattern();
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
    sequence.clear();
    options.clear();
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

  void _generateNewPattern() {
    final random = Random();
    final pattern = patterns[random.nextInt(patterns.length)];
    patternType.value = pattern;

    sequence.clear();

    switch (pattern) {
      case 'squares':
        final start = 1 + random.nextInt(3);
        for (int i = 0; i < 4; i++) {
          sequence.add((start + i) * (start + i));
        }
        correctAnswer.value = (start + 4) * (start + 4);
        break;

      case 'cubes':
        final start = 1 + random.nextInt(3);
        for (int i = 0; i < 4; i++) {
          sequence.add((start + i) * (start + i) * (start + i));
        }
        correctAnswer.value = (start + 4) * (start + 4) * (start + 4);
        break;

      case 'fibonacci':
        int a = 1, b = 1;
        sequence.add(a);
        sequence.add(b);
        for (int i = 0; i < 3; i++) {
          final next = a + b;
          sequence.add(next);
          a = b;
          b = next;
        }
        correctAnswer.value = a + b;
        break;

      case 'arithmetic':
        final start = 5 + random.nextInt(10);
        final diff = 3 + random.nextInt(5);
        for (int i = 0; i < 5; i++) {
          sequence.add(start + i * diff);
        }
        correctAnswer.value = start + 5 * diff;
        break;

      case 'geometric':
        final start = 2 + random.nextInt(3);
        final ratio = 2 + random.nextInt(2);
        int current = start;
        for (int i = 0; i < 4; i++) {
          sequence.add(current);
          current *= ratio;
        }
        correctAnswer.value = current;
        break;

      case 'triangular':
        for (int i = 1; i <= 5; i++) {
          sequence.add(i * (i + 1) ~/ 2);
        }
        correctAnswer.value = 6 * 7 ~/ 2;
        break;
    }

    _generateOptions();
  }

  void _generateOptions() {
    options.clear();
    options.add(correctAnswer.value);

    final random = Random();
    while (options.length < 4) {
      final offset = random.nextInt(20) - 10;
      final option = correctAnswer.value + offset;
      if (option > 0 && !options.contains(option)) {
        options.add(option);
      }
    }

    options.shuffle();
  }

  void selectOption(int option) {
    if (option == correctAnswer.value) {
      _handleCorrectAnswer();
    } else {
      _handleWrongAnswer();
    }
  }

  void _handleCorrectAnswer() {
    incrementCombo();
    final comboBonus = combo.value * 20;
    final points = 150 + comboBonus;
    updateScore(points);

    showFeedback('🎯 Excellent pattern recognition! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewPattern();
    });
  }

  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    showFeedback(
      '❌ Wrong! Answer: ${correctAnswer.value} (${_getPatternHint()})',
      isCorrect: false,
    );
  }

  String _getPatternHint() {
    switch (patternType.value) {
      case 'squares':
        return 'Perfect squares';
      case 'cubes':
        return 'Perfect cubes';
      case 'fibonacci':
        return 'Fibonacci sequence';
      case 'arithmetic':
        return 'Add constant difference';
      case 'geometric':
        return 'Multiply by constant';
      case 'triangular':
        return 'Triangular numbers';
      default:
        return 'Pattern';
    }
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class PatternPredictorGame extends StatelessWidget {
  const PatternPredictorGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatternPredictorController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Pattern Predictor',
        backgroundColor: const Color(0xFF7209B7),
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

  Widget _buildStartScreen(PatternPredictorController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insights, size: 100, color: Color(0xFF7209B7)),
            const SizedBox(height: 24),
            const Text(
              'Pattern Predictor',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Spot the pattern and predict the next number!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7209B7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pattern Types:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Perfect Squares: 1, 4, 9, 16, 25...'),
                  Text('• Perfect Cubes: 1, 8, 27, 64...'),
                  Text('• Fibonacci: 1, 1, 2, 3, 5, 8...'),
                  Text('• Arithmetic: +2, +3, +4 patterns'),
                  Text('• Geometric: ×2, ×3 patterns'),
                  Text('• Triangular: 1, 3, 6, 10, 15...'),
                  SizedBox(height: 8),
                  Text(
                    'Build combos for bonus points!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7209B7),
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

  Widget _buildGameScreen(PatternPredictorController controller) {
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'What comes next?',
                  style: AppTextStyles.h4.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Sequence display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7209B7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF7209B7).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ...controller.sequence.map(
                        (num) => _buildNumberChip(num.toString(), false),
                      ),
                      _buildNumberChip('?', true),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Options grid
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2,
                  children: controller.options
                      .map((option) => _buildOptionButton(controller, option))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberChip(String number, bool isQuestion) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isQuestion ? const Color(0xFF7209B7) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7209B7), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7209B7).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        number,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isQuestion ? Colors.white : const Color(0xFF7209B7),
        ),
      ),
    );
  }

  Widget _buildOptionButton(PatternPredictorController controller, int option) {
    return ElevatedButton(
      onPressed: () => controller.selectOption(option),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF7209B7),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF7209B7), width: 2),
        ),
      ),
      child: Text(
        '$option',
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGameOverScreen(PatternPredictorController controller) {
    return Center(
      child: GameUI.buildGameOverDialog(
        finalScore: controller.score.value,
        maxCombo: controller.maxCombo.value,
        onReplay: controller.startGame,
        onExit: () => Get.back(),
      ),
    );
  }
}
