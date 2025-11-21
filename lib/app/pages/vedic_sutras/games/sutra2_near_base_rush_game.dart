import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 2: Near-Base Rush - Multiply numbers near bases
class NearBaseRushController extends SutraGameController {
  final RxInt number1 = 97.obs;
  final RxInt number2 = 96.obs;
  final RxInt selectedBase = 100.obs;
  final RxString userAnswer = ''.obs;
  final RxInt stage = 1.obs; // 1=base selection, 2=answer
  Timer? _gameTimer;

  final List<int> bases = [10, 100, 1000];
  final List<Map<String, int>> problems = [];

  @override
  void startGame() {
    resetGame();
    _generateProblems();
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
    stage.value = 1;
    problems.clear();
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

  void _generateProblems() {
    final random = Random();
    // Generate problems near base 100
    for (int i = 0; i < 10; i++) {
      problems.add({
        'num1': 90 + random.nextInt(10), // 90-99
        'num2': 90 + random.nextInt(10),
        'base': 100,
      });
    }
    // Generate problems near base 10
    for (int i = 0; i < 5; i++) {
      problems.add({
        'num1': 7 + random.nextInt(3), // 7-9
        'num2': 7 + random.nextInt(3),
        'base': 10,
      });
    }
  }

  void _generateNewProblem() {
    if (problems.isEmpty) {
      _generateProblems();
    }
    final problem = problems.removeAt(0);
    number1.value = problem['num1']!;
    number2.value = problem['num2']!;
    selectedBase.value = problem['base']!;
    stage.value = 1;
    userAnswer.value = '';
  }

  void selectBase(int base) {
    selectedBase.value = base;
    stage.value = 2;
  }

  int _calculateCorrectAnswer() {
    final base = selectedBase.value;
    final n1 = number1.value;
    final n2 = number2.value;

    final def1 = base - n1;
    final def2 = base - n2;
    final leftPart = n1 - def2; // or n2 - def1
    final rightPart = def1 * def2;

    return leftPart * base + rightPart;
  }

  int _getCorrectBase() {
    // Determine which base is closest
    final avg = (number1.value + number2.value) / 2;
    if (avg > 500) return 1000;
    if (avg > 50) return 100;
    return 10;
  }

  void submitAnswer() {
    if (stage.value == 1) {
      // Check if correct base selected
      final correctBase = _getCorrectBase();
      if (selectedBase.value == correctBase) {
        showFeedback('✓ Correct base!', isCorrect: true);
        stage.value = 2;
      } else {
        showFeedback('✗ Wrong base! Try ${correctBase}', isCorrect: false);
        loseLife();
        resetCombo();
      }
      return;
    }

    if (userAnswer.value.isEmpty) return;

    try {
      final answer = int.parse(userAnswer.value);
      final correct = _calculateCorrectAnswer();

      if (answer == correct) {
        _handleCorrectAnswer();
      } else {
        _handleWrongAnswer(correct);
      }
    } catch (e) {
      showFeedback('Invalid number!', isCorrect: false);
    }
  }

  void _handleCorrectAnswer() {
    incrementCombo();
    final comboBonus = combo.value * 15;
    final baseBonus = selectedBase.value == 1000
        ? 50
        : selectedBase.value == 100
        ? 30
        : 10;
    final points = 100 + comboBonus + baseBonus;
    updateScore(points);

    showFeedback(
      '🎯 Perfect! +$points (${combo.value}x combo)',
      isCorrect: true,
    );
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
    });
  }

  void _handleWrongAnswer(int correct) {
    resetCombo();
    loseLife();
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

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class NearBaseRushGame extends StatelessWidget {
  const NearBaseRushGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NearBaseRushController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Near-Base Rush',
        backgroundColor: const Color(0xFF4ECDC4),
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

  Widget _buildStartScreen(NearBaseRushController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.speed, size: 100, color: Color(0xFF4ECDC4)),
            const SizedBox(height: 24),
            const Text(
              'Near-Base Rush',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Multiply numbers near bases using the Nikhilam method!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Choose the correct base (10, 100, or 1000)'),
                  Text('2. Find deficiency from base for each number'),
                  Text('3. Cross-subtract for left part'),
                  Text('4. Multiply deficiencies for right part'),
                  SizedBox(height: 8),
                  Text('Example: 97×96 (base 100)'),
                  Text('  Deficit: 3 & 4'),
                  Text('  Left: 97-4 = 93'),
                  Text('  Right: 3×4 = 12'),
                  Text('  Answer: 9312'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ECDC4),
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

  Widget _buildGameScreen(NearBaseRushController controller) {
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
                if (controller.stage.value == 1) ...[
                  Text(
                    'Choose the best base:',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${controller.number1.value} × ${controller.number2.value}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBaseButton(controller, 10),
                      const SizedBox(width: 16),
                      _buildBaseButton(controller, 100),
                      const SizedBox(width: 16),
                      _buildBaseButton(controller, 1000),
                    ],
                  ),
                ] else ...[
                  Text(
                    'Base: ${controller.selectedBase.value}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.number1.value} × ${controller.number2.value} = ?',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF4ECDC4),
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
              ],
            ),
          ),
        ),

        if (controller.stage.value == 2)
          GameNumberPad(
            onNumberPressed: controller.addDigit,
            onSubmit: controller.submitAnswer,
            onDelete: controller.deleteDigit,
          ),
      ],
    );
  }

  Widget _buildBaseButton(NearBaseRushController controller, int base) {
    return ElevatedButton(
      onPressed: () => controller.selectBase(base),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        '$base',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGameOverScreen(NearBaseRushController controller) {
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
