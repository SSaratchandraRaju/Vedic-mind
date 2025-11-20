import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../widgets/game_widgets.dart';

/// Sutra 7: Equation Eliminator - Solve simultaneous equations by elimination
class EquationEliminatorController extends SutraGameController {
  // Equation 1: a1*x + b1*y = c1
  // Equation 2: a2*x + b2*y = c2
  final RxInt a1 = 2.obs;
  final RxInt b1 = 3.obs;
  final RxInt c1 = 12.obs;
  final RxInt a2 = 4.obs;
  final RxInt b2 = 1.obs;
  final RxInt c2 = 14.obs;
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
    // Generate solution first
    final x = 1 + random.nextInt(9);
    final y = 1 + random.nextInt(9);
    
    // Generate coefficients
    a1.value = 1 + random.nextInt(5);
    b1.value = 1 + random.nextInt(5);
    a2.value = 1 + random.nextInt(5);
    b2.value = 1 + random.nextInt(5);
    
    // Calculate constants to match solution
    c1.value = a1.value * x + b1.value * y;
    c2.value = a2.value * x + b2.value * y;
  }
  
  int _getCorrectAnswer() {
    // Solve using elimination: x = (c1*b2 - c2*b1) / (a1*b2 - a2*b1)
    final denominator = a1.value * b2.value - a2.value * b1.value;
    if (denominator == 0) return 0;
    return (c1.value * b2.value - c2.value * b1.value) ~/ denominator;
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
    final comboBonus = combo.value * 25;
    final points = 200 + comboBonus;
    updateScore(points);
    
    showFeedback('🎯 Eliminated perfectly! +$points', isCorrect: true);
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
      userAnswer.value = userAnswer.value.substring(0, userAnswer.value.length - 1);
    }
  }
  
  String getEquation1() {
    return '${a1.value}x + ${b1.value}y = ${c1.value}';
  }
  
  String getEquation2() {
    return '${a2.value}x + ${b2.value}y = ${c2.value}';
  }
  
  String getHint() {
    return 'Hint: Use elimination method to solve for x';
  }
  
  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class EquationEliminatorGame extends StatelessWidget {
  const EquationEliminatorGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquationEliminatorController());
    
    return Scaffold(
      appBar: GameAppBar(
        title: 'Equation Eliminator',
        backgroundColor: const Color(0xFFFFBE0B),
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
  
  Widget _buildStartScreen(EquationEliminatorController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.clear_all, size: 100, color: Color(0xFFFFBE0B)),
            const SizedBox(height: 24),
            const Text(
              'Equation Eliminator',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Master simultaneous equations!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFBE0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Solve two equations for x'),
                  Text('• Use elimination method'),
                  Text('• Multiply and subtract equations'),
                  Text('• Solve quickly for high score!'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFBE0B),
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
  
  Widget _buildGameScreen(EquationEliminatorController controller) {
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFBE0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        controller.getEquation1(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFBE0B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.getEquation2(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFBE0B),
                        ),
                      ),
                    ],
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
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFBE0B), width: 2),
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
