import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../ui/widgets/game_widgets.dart';

/// Sutra 15: Product-Sum Spotter - Ekanyunena Purvena
class ProductSumSpotterController extends SutraGameController {
  final RxInt targetSum = 7.obs;
  final RxString userX = ''.obs;
  final RxString userY = ''.obs;
  final RxBool editingX = true.obs;
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
    timeLeft.value = 80;
    isGameActive.value = false;
    isGameOver.value = false;
    userX.value = '';
    userY.value = '';
    editingX.value = true;
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
    targetSum.value = 5 + random.nextInt(11); // 5-15
  }

  List<int> _getCorrectAnswers() {
    // Find x, y where x*y = x+y (special case when sum = product)
    // This happens when x+y = xy, so y = x/(x-1)
    // Valid integer solutions: (2,2), (0, any)
    // For sum = s, we need xy = s and x+y = s
    // This gives x(s-x) = s, or sx - x² = s, or x² - sx + s = 0
    // Using quadratic formula: x = (s ± √(s² - 4s))/2

    // For simplicity, we check small values
    for (int x = 0; x <= targetSum.value; x++) {
      for (int y = 0; y <= targetSum.value; y++) {
        if (x * y == targetSum.value && x + y == targetSum.value) {
          return [x, y];
        }
      }
    }
    return [0, targetSum.value]; // Fallback
  }

  void submitAnswer() {
    if (userX.value.isEmpty || userY.value.isEmpty) return;

    try {
      final x = int.parse(userX.value);
      final y = int.parse(userY.value);

      // Check if x*y = target AND x+y = target
      if (x * y == targetSum.value && x + y == targetSum.value) {
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
    final comboBonus = combo.value * 25;
    final points = 200 + comboBonus;
    updateScore(points);

    showFeedback('🌟 Product-Sum mastered! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
      userX.value = '';
      userY.value = '';
      editingX.value = true;
    });
  }

  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    final correct = _getCorrectAnswers();
    showFeedback(
      '❌ Wrong! Try: x=${correct[0]}, y=${correct[1]}',
      isCorrect: false,
    );
  }

  void addDigit(String digit) {
    if (editingX.value) {
      userX.value += digit;
    } else {
      userY.value += digit;
    }
  }

  void deleteDigit() {
    if (editingX.value) {
      if (userX.value.isNotEmpty) {
        userX.value = userX.value.substring(0, userX.value.length - 1);
      }
    } else {
      if (userY.value.isNotEmpty) {
        userY.value = userY.value.substring(0, userY.value.length - 1);
      }
    }
  }

  void switchField() {
    editingX.value = !editingX.value;
  }

  String getHint() {
    return 'Hint: Find x,y where both x×y=${targetSum.value} AND x+y=${targetSum.value}';
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class ProductSumSpotterGame extends StatelessWidget {
  const ProductSumSpotterGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductSumSpotterController());

    return Scaffold(
      appBar: GameAppBar(
        title: 'Product-Sum Spotter',
        backgroundColor: const Color(0xFFFF5733),
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

  Widget _buildStartScreen(ProductSumSpotterController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.join_inner, size: 100, color: Color(0xFFFF5733)),
            const SizedBox(height: 24),
            const Text(
              'Product-Sum Spotter',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Find pairs where product equals sum!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5733).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Find x,y where x×y = x+y'),
                  Text('• Both must equal target'),
                  Text('• Example: 2×2 = 4, 2+2 = 4'),
                  Text('• Use special case method'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5733),
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

  Widget _buildGameScreen(ProductSumSpotterController controller) {
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
                  'Find x and y:',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  'x × y = ${controller.targetSum.value}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5733),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'x + y = ${controller.targetSum.value}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5733),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'x = ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.editingX.value = true,
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.editingX.value
                                ? const Color(0xFFFF5733)
                                : Colors.grey,
                            width: controller.editingX.value ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          controller.userX.value.isEmpty
                              ? '_'
                              : controller.userX.value,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    const Text(
                      'y = ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.editingX.value = false,
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: !controller.editingX.value
                                ? const Color(0xFFFF5733)
                                : Colors.grey,
                            width: !controller.editingX.value ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          controller.userY.value.isEmpty
                              ? '_'
                              : controller.userY.value,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
