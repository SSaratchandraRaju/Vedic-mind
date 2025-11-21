import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 16: Factorization Finale - Factor quadratics rapidly
class FactorizationFinaleController extends SutraGameController {
  final RxInt a = 1.obs; // Coefficient of x²
  final RxInt b = 5.obs; // Coefficient of x
  final RxInt c = 6.obs; // Constant term
  final RxString userP = ''.obs; // First factor
  final RxString userQ = ''.obs; // Second factor
  final RxBool editingP = true.obs;
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
    timeLeft.value = 90;
    isGameActive.value = false;
    isGameOver.value = false;
    userP.value = '';
    userQ.value = '';
    editingP.value = true;
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
    // Generate factorizable quadratic: x² + bx + c = (x+p)(x+q)
    // where p*q = c and p+q = b
    final p = 1 + random.nextInt(9);
    final q = 1 + random.nextInt(9);

    a.value = 1; // Keep it simple with a=1
    b.value = p + q;
    c.value = p * q;
  }

  List<int> _getCorrectFactors() {
    // Find p, q such that p*q = c and p+q = b
    for (int p = -20; p <= 20; p++) {
      for (int q = -20; q <= 20; q++) {
        if (p * q == c.value && p + q == b.value) {
          return [p, q];
        }
      }
    }
    return [0, 0];
  }

  void submitAnswer() {
    if (userP.value.isEmpty || userQ.value.isEmpty) return;

    try {
      final p = int.parse(userP.value);
      final q = int.parse(userQ.value);

      // Check if p*q = c and p+q = b (order doesn't matter)
      if ((p * q == c.value && p + q == b.value) ||
          (q * p == c.value && q + p == b.value)) {
        _handleCorrectAnswer();
      } else {
        _handleWrongAnswer();
      }
    } catch (e) {
      showFeedback('Invalid numbers!', isCorrect: false);
    }
  }

  void _handleCorrectAnswer() {
    incrementCombo();
    final comboBonus = combo.value * 30;
    final points = 220 + comboBonus;
    updateScore(points);

    showFeedback('🎉 Perfect factorization! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
      userP.value = '';
      userQ.value = '';
      editingP.value = true;
    });
  }

  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    final correct = _getCorrectFactors();
    showFeedback(
      '❌ Wrong! Factors: ${correct[0]}, ${correct[1]}',
      isCorrect: false,
    );
  }

  void addDigit(String digit) {
    if (editingP.value) {
      userP.value += digit;
    } else {
      userQ.value += digit;
    }
  }

  void deleteDigit() {
    if (editingP.value) {
      if (userP.value.isNotEmpty) {
        userP.value = userP.value.substring(0, userP.value.length - 1);
      }
    } else {
      if (userQ.value.isNotEmpty) {
        userQ.value = userQ.value.substring(0, userQ.value.length - 1);
      }
    }
  }

  void addNegative() {
    if (editingP.value) {
      if (userP.value.isEmpty || !userP.value.startsWith('-')) {
        userP.value = '-' + userP.value;
      }
    } else {
      if (userQ.value.isEmpty || !userQ.value.startsWith('-')) {
        userQ.value = '-' + userQ.value;
      }
    }
  }

  void switchField() {
    editingP.value = !editingP.value;
  }

  String getExpression() {
    if (a.value == 1) {
      return 'x² + ${b.value}x + ${c.value}';
    }
    return '${a.value}x² + ${b.value}x + ${c.value}';
  }

  String getHint() {
    return 'Hint: Find p,q where p×q=${c.value} and p+q=${b.value}';
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class FactorizationFinaleGame extends StatelessWidget {
  const FactorizationFinaleGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FactorizationFinaleController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Factorization Finale',
        backgroundColor: const Color(0xFF9C27B0),
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

  Widget _buildStartScreen(FactorizationFinaleController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.widgets, size: 100, color: Color(0xFF9C27B0)),
            const SizedBox(height: 24),
            const Text(
              'Factorization Finale',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Master quadratic factorization!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Factor quadratic expressions'),
                  Text('• Find (x+p)(x+q) form'),
                  Text('• p×q = constant, p+q = coefficient'),
                  Text('• Example: x²+5x+6 = (x+2)(x+3)'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
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

  Widget _buildGameScreen(FactorizationFinaleController controller) {
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
                  'Factor the expression:',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.getExpression(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C27B0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '( x + ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.editingP.value = true,
                        child: Container(
                          width: 60,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.editingP.value
                                  ? const Color(0xFF9C27B0)
                                  : Colors.grey,
                              width: controller.editingP.value ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.userP.value.isEmpty
                                ? '_'
                                : controller.userP.value,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Text(
                        ' )( x + ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.editingP.value = false,
                        child: Container(
                          width: 60,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: !controller.editingP.value
                                  ? const Color(0xFF9C27B0)
                                  : Colors.grey,
                              width: !controller.editingP.value ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.userQ.value.isEmpty
                                ? '_'
                                : controller.userQ.value,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Text(
                        ' )',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
