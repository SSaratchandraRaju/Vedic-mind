import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../widgets/game_widgets.dart';

/// Sutra 12: Remainder Race - By the remainder remains constant
class RemainderRaceController extends SutraGameController {
  final RxInt number = 123.obs;
  final RxInt divisor = 9.obs;
  final RxString userAnswer = ''.obs;
  Timer? _gameTimer;
  
  final List<int> divisors = [3, 9, 11];
  
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
    number.value = 100 + random.nextInt(900); // 100-999
  }
  
  int _getCorrectAnswer() {
    return number.value % divisor.value;
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
    final comboBonus = combo.value * 15;
    final points = 140 + comboBonus;
    updateScore(points);
    
    showFeedback('⚡ Lightning fast! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
      userAnswer.value = '';
    });
  }
  
  void _handleWrongAnswer() {
    resetCombo();
    loseLife();
    final correct = _getCorrectAnswer();
    showFeedback('❌ Wrong! Remainder: $correct', isCorrect: false);
  }
  
  void addDigit(String digit) {
    userAnswer.value += digit;
  }
  
  void deleteDigit() {
    if (userAnswer.value.isNotEmpty) {
      userAnswer.value = userAnswer.value.substring(0, userAnswer.value.length - 1);
    }
  }
  
  String getHint() {
    if (divisor.value == 9 || divisor.value == 3) {
      return 'Hint: Sum of digits for divisibility by ${divisor.value}';
    }
    return 'Hint: Use Osculation method for ${divisor.value}';
  }
  
  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class RemainderRaceGame extends StatelessWidget {
  const RemainderRaceGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RemainderRaceController());
    
    return Scaffold(
      appBar: GameAppBar(
        title: 'Remainder Race',
        backgroundColor: const Color(0xFFEF476F),
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
  
  Widget _buildStartScreen(RemainderRaceController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 100, color: Color(0xFFEF476F)),
            const SizedBox(height: 24),
            const Text(
              'Remainder Race',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Find remainders at lightning speed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEF476F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Find remainder quickly'),
                  Text('• Divisibility tests for 3, 9, 11'),
                  Text('• Use digit sum method'),
                  Text('• Speed is key!'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF476F),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
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
  
  Widget _buildGameScreen(RemainderRaceController controller) {
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
                  'Find the remainder:',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  '${controller.number.value} ÷ ${controller.divisor.value}',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF476F),
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
                      'R = ',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFEF476F), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        controller.userAnswer.value.isEmpty ? '_' : controller.userAnswer.value,
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
