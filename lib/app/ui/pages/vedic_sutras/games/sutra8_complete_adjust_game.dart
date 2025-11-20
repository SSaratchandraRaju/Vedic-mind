import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../widgets/game_widgets.dart';

/// Sutra 8: Complete & Adjust - By completion or non-completion
class CompleteAdjustController extends SutraGameController {
  final RxInt multiplicand = 98.obs;
  final RxInt multiplier = 96.obs;
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
    // Generate numbers close to 100
    multiplicand.value = 91 + random.nextInt(18); // 91-108
    multiplier.value = 91 + random.nextInt(18);
  }
  
  int _getCorrectAnswer() {
    return multiplicand.value * multiplier.value;
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
    final comboBonus = combo.value * 22;
    final points = 180 + comboBonus;
    updateScore(points);
    
    showFeedback('✨ Perfect completion! +$points', isCorrect: true);
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
      userAnswer.value = userAnswer.value.substring(0, userAnswer.value.length - 1);
    }
  }
  
  String getHint() {
    final diff1 = multiplicand.value - 100;
    final diff2 = multiplier.value - 100;
    return 'Hint: (${multiplicand.value}-100)=${diff1}, (${multiplier.value}-100)=${diff2}\nUse: (a±m)(b±n) method';
  }
  
  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class CompleteAdjustGame extends StatelessWidget {
  const CompleteAdjustGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompleteAdjustController());
    
    return Scaffold(
      appBar: GameAppBar(
        title: 'Complete & Adjust',
        backgroundColor: const Color(0xFFFB5607),
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
  
  Widget _buildStartScreen(CompleteAdjustController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.tune, size: 100, color: Color(0xFFFB5607)),
            const SizedBox(height: 24),
            const Text(
              'Complete & Adjust',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Multiply near 100 using completion!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFB5607).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Multiply numbers near 100'),
                  Text('• Find differences from 100'),
                  Text('• Complete and adjust method'),
                  Text('• Example: 98×96 = 94|08'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB5607),
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
  
  Widget _buildGameScreen(CompleteAdjustController controller) {
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
                  '${controller.multiplicand.value} × ${controller.multiplier.value} = ?',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFB5607),
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
                    border: Border.all(color: const Color(0xFFFB5607), width: 2),
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
