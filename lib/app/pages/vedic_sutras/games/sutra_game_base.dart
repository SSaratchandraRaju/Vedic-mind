import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/widgets/game_widgets.dart';
import '../../../ui/theme/app_colors.dart';
import '../../../ui/theme/app_text_styles.dart';

/// Base class for all Sutra mini-games
abstract class SutraGameController extends GetxController {
  final RxInt score = 0.obs;
  final RxInt lives = 3.obs;
  final RxInt combo = 0.obs;
  final RxInt maxCombo = 0.obs;
  final RxInt timeLeft = 60.obs;
  final RxBool isGameActive = false.obs;
  final RxBool isGameOver = false.obs;
  final RxString feedback = ''.obs;

  void startGame();
  void resetGame();
  void endGame();

  void updateScore(int points) {
    score.value += points;
  }

  void incrementCombo() {
    combo.value++;
    if (combo.value > maxCombo.value) {
      maxCombo.value = combo.value;
    }
  }

  void resetCombo() {
    combo.value = 0;
  }

  void loseLife() {
    lives.value--;
    if (lives.value <= 0) {
      endGame();
    }
  }

  void showFeedback(String message, {bool isCorrect = true}) {
    feedback.value = message;

    // Show snackbar with color-coded feedback
    if (Get.context != null) {
      GameFeedbackSnackbar.show(
        Get.context!,
        isCorrect: isCorrect,
        message: message,
      );
    }

    Future.delayed(const Duration(seconds: 2), () {
      feedback.value = '';
    });
  }
}

/// Common game UI components
class GameUI {
  static Widget buildScoreBar({
    required int score,
    required int lives,
    required int combo,
    required int timeLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(Icons.star, '$score', Colors.amber),
          _buildStatItem(Icons.favorite, '$lives', Colors.red),
          _buildStatItem(Icons.flash_on, '${combo}x', Colors.orange),
          _buildStatItem(Icons.timer, '${timeLeft}s', Colors.blue),
        ],
      ),
    );
  }

  static Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  static Widget buildGameOverDialog({
    required int finalScore,
    required int maxCombo,
    required VoidCallback onReplay,
    required VoidCallback onExit,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Game Over!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Final Score: $finalScore',
              style: AppTextStyles.h4.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Max Combo: ${maxCombo}x',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.orange),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReplay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Play Again'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onExit,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Exit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildFeedback(String message, {bool isCorrect = true}) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isCorrect ? Colors.green[900] : Colors.red[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
