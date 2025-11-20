import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/// Custom AppBar for all Sutra Games
/// Features: Cupertino back button, white text/icons
class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;

  const GameAppBar({
    Key? key,
    required this.title,
    required this.backgroundColor,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CupertinoNavigationBarBackButton(
        color: Colors.white,
        onPressed: () => Get.back(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom Number Pad for all Sutra Games
/// Features: 
/// - 0-9 number buttons
/// - Tick (✓) for submit
/// - Cross (✗) for delete
/// - Optional decimal support with long-press on "1"
class GameNumberPad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onSubmit;
  final VoidCallback onDelete;
  final bool enableDecimal;
  final Color? backgroundColor;
  final Color submitColor;
  final Color deleteColor;

  const GameNumberPad({
    Key? key,
    required this.onNumberPressed,
    required this.onSubmit,
    required this.onDelete,
    this.enableDecimal = false,
    this.backgroundColor,
    this.submitColor = Colors.green,
    this.deleteColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: backgroundColor ?? Colors.grey[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: 1, 2, 3
          Row(
            children: [
              for (int i = 1; i <= 3; i++)
                Expanded(
                  child: i == 1 && enableDecimal
                      ? _buildDecimalNumberButton(i.toString())
                      : _buildNumberButton(i.toString()),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: 4, 5, 6
          Row(
            children: [
              for (int i = 4; i <= 6; i++)
                Expanded(child: _buildNumberButton(i.toString())),
            ],
          ),
          const SizedBox(height: 8),
          // Row 3: 7, 8, 9
          Row(
            children: [
              for (int i = 7; i <= 9; i++)
                Expanded(child: _buildNumberButton(i.toString())),
            ],
          ),
          const SizedBox(height: 8),
          // Row 4: Delete (✗), 0, Submit (✓)
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: '⌫',
                  onPressed: onDelete,
                  color: deleteColor,
                ),
              ),
              Expanded(child: _buildNumberButton('0')),
              Expanded(
                child: _buildActionButton(
                  label: '✓',
                  onPressed: onSubmit,
                  color: submitColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Regular number button
  Widget _buildNumberButton(String digit) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () => onNumberPressed(digit),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          digit,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Number button with long-press support for decimal point (button "1")
  Widget _buildDecimalNumberButton(String digit) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onLongPress: () => onNumberPressed('.'),
        child: ElevatedButton(
          onPressed: () => onNumberPressed(digit),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                digit,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (enableDecimal)
                const Text(
                  '.',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Action button (✓ for submit, ✗ for delete)
  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Game Score Bar - Shows score, lives, time, combo
class GameScoreBar extends StatelessWidget {
  final int score;
  final int lives;
  final int timeLeft;
  final int combo;
  final Color? backgroundColor;

  const GameScoreBar({
    Key? key,
    required this.score,
    required this.lives,
    required this.timeLeft,
    required this.combo,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: backgroundColor ?? Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildScoreItem(
            icon: Icons.star,
            label: score.toString(),
            color: Colors.amber,
          ),
          _buildScoreItem(
            icon: Icons.favorite,
            label: lives.toString(),
            color: Colors.red,
          ),
          _buildScoreItem(
            icon: Icons.timer,
            label: '${timeLeft}s',
            color: timeLeft > 10 ? Colors.blue : Colors.red,
          ),
          if (combo > 1)
            _buildScoreItem(
              icon: Icons.whatshot,
              label: 'x$combo',
              color: Colors.orange,
            ),
        ],
      ),
    );
  }

  Widget _buildScoreItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Game Start Screen - Reusable start screen for all games
class GameStartScreen extends StatelessWidget {
  final String gameName;
  final IconData icon;
  final Color iconColor;
  final String description;
  final List<String> instructions;
  final VoidCallback onStart;
  final Color buttonColor;

  const GameStartScreen({
    Key? key,
    required this.gameName,
    required this.icon,
    required this.iconColor,
    required this.description,
    required this.instructions,
    required this.onStart,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: iconColor),
            const SizedBox(height: 16),
            Text(
              gameName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How to Play:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...instructions.map((instruction) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          instruction,
                          style: const TextStyle(fontSize: 13),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
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
}

/// Game Over Screen - Reusable game over screen
class GameOverScreen extends StatelessWidget {
  final int score;
  final int maxCombo;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;
  final Color buttonColor;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.maxCombo,
    required this.onPlayAgain,
    required this.onExit,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              'Game Over!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildStatRow('Final Score', score.toString(), Icons.star, Colors.amber),
                  const SizedBox(height: 12),
                  _buildStatRow('Max Combo', 'x$maxCombo', Icons.whatshot, Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onPlayAgain,
                  icon: const Icon(Icons.replay),
                  label: const Text('PLAY AGAIN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: onExit,
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('EXIT'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Problem Display Widget - Shows the current math problem
class GameProblemDisplay extends StatelessWidget {
  final String problem;
  final String userAnswer;
  final Color backgroundColor;

  const GameProblemDisplay({
    Key? key,
    required this.problem,
    required this.userAnswer,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            problem,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Text(
              userAnswer.isEmpty ? '_ _ _' : userAnswer,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: userAnswer.isEmpty ? Colors.grey : Colors.blue,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Game Feedback Snackbar - Shows feedback for correct/wrong answers
class GameFeedbackSnackbar {
  static void show(BuildContext context, {
    required bool isCorrect,
    String? message,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message ?? (isCorrect ? 'Correct! 🎉' : 'Wrong Answer ❌'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: isCorrect ? 1000 : 1500),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
