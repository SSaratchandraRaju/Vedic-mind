import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sutra_game_base.dart';
import '../../../widgets/game_widgets.dart';

/// Sutra 6: Ratio Racer - By mere observation using proportions
class RatioRacerController extends SutraGameController {
  final RxInt a = 2.obs;
  final RxInt b = 3.obs;
  final RxInt c = 4.obs;
  final RxInt d = 0.obs; // This is what we need to find (x in a/b = c/x)
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
    a.value = 2 + random.nextInt(8);
    b.value = 2 + random.nextInt(8);
    c.value = 2 + random.nextInt(12);
    // Calculate d such that a/b = c/d
    d.value = (b.value * c.value) ~/ a.value;
  }
  
  int _getCorrectAnswer() {
    return d.value;
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
    final points = 160 + comboBonus;
    updateScore(points);
    
    showFeedback('⚡ Perfect ratio! +$points', isCorrect: true);
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
  
  String getRatio() {
    return '$a : $b = $c : x';
  }
  
  String getHint() {
    return 'Hint: Cross multiply! ${a.value} × x = ${b.value} × ${c.value}';
  }
  
  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }
}

class RatioRacerGame extends StatelessWidget {
  const RatioRacerGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RatioRacerController());
    
    return Scaffold(
      appBar: GameAppBar(
        title: 'Ratio Racer',
        backgroundColor: const Color(0xFF06D6A0),
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
  
  Widget _buildStartScreen(RatioRacerController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.speed, size: 100, color: Color(0xFF06D6A0)),
            const SizedBox(height: 24),
            const Text(
              'Ratio Racer',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Solve proportions at lightning speed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF06D6A0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Solve ratio problems quickly'),
                  Text('• Use cross multiplication'),
                  Text('• Example: 2:3 = 4:x'),
                  Text('• 2×x = 3×4, so x = 6'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06D6A0),
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
  
  Widget _buildGameScreen(RatioRacerController controller) {
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
                  'Solve the proportion:',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.getRatio(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF06D6A0),
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
                        border: Border.all(color: const Color(0xFF06D6A0), width: 2),
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
