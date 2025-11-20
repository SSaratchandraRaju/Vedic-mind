import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../widgets/game_widgets.dart';

/// Sutra 3: Crosswise Matrix - Universal multiplication
class CrosswiseMatrixController extends SutraGameController {
  final RxInt number1 = 12.obs;
  final RxInt number2 = 13.obs;
  final RxString userAnswer = ''.obs;
  final RxInt stage = 1.obs; // 1=units, 2=cross, 3=tens
  final RxList<int> partialAnswers = <int>[].obs;
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
    timeLeft.value = 120;
    isGameActive.value = false;
    isGameOver.value = false;
    userAnswer.value = '';
    stage.value = 1;
    partialAnswers.clear();
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
    number1.value = 11 + random.nextInt(89); // 11-99
    number2.value = 11 + random.nextInt(89);
    stage.value = 1;
    partialAnswers.clear();
    userAnswer.value = '';
  }
  
  int _getUnitsProduct() {
    final n1 = number1.value % 10;
    final n2 = number2.value % 10;
    return n1 * n2;
  }
  
  int _getCrossProduct() {
    final n1Tens = number1.value ~/ 10;
    final n1Units = number1.value % 10;
    final n2Tens = number2.value ~/ 10;
    final n2Units = number2.value % 10;
    return (n1Tens * n2Units) + (n1Units * n2Tens);
  }
  
  int _getTensProduct() {
    final n1Tens = number1.value ~/ 10;
    final n2Tens = number2.value ~/ 10;
    return n1Tens * n2Tens;
  }
  
  String _getCurrentStageInstruction() {
    switch (stage.value) {
      case 1:
        return 'Multiply units vertically:\n${number1.value % 10} × ${number2.value % 10} = ?';
      case 2:
        return 'Cross multiply and add:\n(${number1.value ~/ 10}×${number2.value % 10}) + (${number1.value % 10}×${number2.value ~/ 10}) = ?';
      case 3:
        return 'Multiply tens vertically:\n${number1.value ~/ 10} × ${number2.value ~/ 10} = ?';
      default:
        return '';
    }
  }
  
  void submitStageAnswer() {
    if (userAnswer.value.isEmpty) return;
    
    try {
      final answer = int.parse(userAnswer.value);
      int correctAnswer;
      
      switch (stage.value) {
        case 1:
          correctAnswer = _getUnitsProduct();
          break;
        case 2:
          correctAnswer = _getCrossProduct();
          break;
        case 3:
          correctAnswer = _getTensProduct();
          break;
        default:
          return;
      }
      
      if (answer == correctAnswer) {
        partialAnswers.add(answer);
        showFeedback('✓ Correct!', isCorrect: true);
        
        if (stage.value < 3) {
          stage.value++;
          userAnswer.value = '';
        } else {
          _handleCorrectAnswer();
        }
      } else {
        showFeedback('✗ Wrong! Answer: $correctAnswer', isCorrect: false);
        loseLife();
        resetCombo();
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
    
    showFeedback('🎯 Perfect crosswise! +$points', isCorrect: true);
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
    });
  }
  
  void addDigit(String digit) {
    userAnswer.value += digit;
  }
  
  void deleteDigit() {
    if (userAnswer.value.isNotEmpty) {
      userAnswer.value = userAnswer.value.substring(0, userAnswer.value.length - 1);
    }
  }
  
  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class CrosswiseMatrixGame extends StatelessWidget {
  const CrosswiseMatrixGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CrosswiseMatrixController());
    
    return Scaffold(
      appBar: GameAppBar(
        title: 'Crosswise Matrix',
        backgroundColor: const Color(0xFFFFBE0B),
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
  
  Widget _buildStartScreen(CrosswiseMatrixController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.grid_on, size: 100, color: Color(0xFFFFBE0B)),
            const SizedBox(height: 24),
            const Text(
              'Crosswise Matrix',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Master the universal multiplication method!',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Step 1: Multiply units vertically (3×4)'),
                  Text('• Step 2: Cross multiply and add'),
                  Text('  (2×4 + 3×1)'),
                  Text('• Step 3: Multiply tens vertically (2×1)'),
                  Text('• Combine all parts for final answer!'),
                  SizedBox(height: 8),
                  Text(
                    'Example: 23 × 14 = 322',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
  
  Widget _buildGameScreen(CrosswiseMatrixController controller) {
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${controller.number1.value} × ${controller.number2.value}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFBE0B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Progress indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStageIndicator(1, controller.stage.value >= 1),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.grey),
                      const SizedBox(width: 8),
                      _buildStageIndicator(2, controller.stage.value >= 2),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.grey),
                      const SizedBox(width: 8),
                      _buildStageIndicator(3, controller.stage.value >= 3),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBE0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller._getCurrentStageInstruction(),
                      style: const TextStyle(fontSize: 16).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
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
            ),
          ),
        ),
        
        GameNumberPad(
          onNumberPressed: controller.addDigit,
          onSubmit: controller.submitStageAnswer,
          onDelete: controller.deleteDigit,
        ),
      ],
    );
  }
  
  Widget _buildStageIndicator(int stage, bool isActive) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFBE0B) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$stage',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameOverScreen(CrosswiseMatrixController controller) {
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
