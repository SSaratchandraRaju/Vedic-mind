import 'package:flutter/material.dart';
import '../theme/color_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/// Custom AppBar for all Sutra Games
/// Features: Cupertino back button, white text/icons
class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;

  const GameAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.actions,
  });

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
    super.key,
    required this.onNumberPressed,
    required this.onSubmit,
    required this.onDelete,
    this.enableDecimal = false,
    this.backgroundColor,
    this.submitColor = Colors.green,
    this.deleteColor = Colors.red,
  });

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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
  final int? maxTime; // Optional total time to render progress
  final int heartsThreshold; // Max hearts to render as icons before switching to numeric display

  /// When [maxTime] is provided, a progress bar will visualize remaining time.
  /// When [lives] <= [heartsThreshold], hearts are rendered instead of a raw number.

  const GameScoreBar({
    super.key,
    required this.score,
    required this.lives,
    required this.timeLeft,
    required this.combo,
    this.backgroundColor,
    this.maxTime,
    this.heartsThreshold = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
  border: Border(bottom: BorderSide(color: Colors.black.withOpacityCompat(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: GameStatTile(
              icon: Icons.star,
              color: Colors.amber,
              label: 'Score',
              value: score.toString(),
              tooltip: 'Total points earned',
              semanticsLabel: 'Score',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GameStatTile(
              icon: Icons.favorite,
              color: Colors.red,
              label: 'Lives',
              value: lives.toString(),
              tooltip: 'Remaining attempts',
              semanticsLabel: 'Lives',
              customContent: _buildLivesContent(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GameStatTile(
              icon: Icons.timer,
              color: timeLeft > (maxTime != null ? maxTime! * 0.2 : 10) ? Colors.blue : Colors.red,
              label: 'Time',
              value: '${timeLeft}s',
              tooltip: 'Time remaining',
              semanticsLabel: 'Time left',
              progress: _timeProgress(),
            ),
          ),
          if (combo > 1) ...[
            const SizedBox(width: 8),
            Expanded(
              child: GameStatTile(
                icon: Icons.whatshot,
                color: Colors.orange,
                label: 'Combo',
                value: 'x$combo',
                tooltip: 'Current streak multiplier',
                semanticsLabel: 'Combo multiplier',
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build hearts or numeric lives
  Widget _buildLivesContent() {
    if (lives <= heartsThreshold && lives > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(heartsThreshold, (index) {
          final filled = index < lives;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Icon(
              filled ? Icons.favorite : Icons.favorite_border,
              color: filled ? Colors.red : Colors.red.withOpacityCompat(0.3),
              size: 18,
            ),
          );
        }),
      );
    }
    if (lives == 0) {
      return const Text(
        'None',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    }
    return Text(
      lives.toString(),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }

  double? _timeProgress() {
    if (maxTime == null || maxTime == 0) return null;
    final clamped = timeLeft.clamp(0, maxTime!);
    return clamped / maxTime!;
  }
}

/// A reusable stat tile to make game stats clearer & consistent.
class GameStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? tooltip;
  final String? semanticsLabel;
  final double? progress; // 0..1 optional progress bar
  final Widget? customContent; // Override value rendering (e.g., hearts)

  const GameStatTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.tooltip,
    this.semanticsLabel,
    this.progress,
    this.customContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityCompat(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
  border: Border.all(color: color.withOpacityCompat(0.4), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          customContent ?? Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          if (progress != null) ...[
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress!.clamp(0, 1),
                minHeight: 6,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ],
      ),
    );

    final wrapped = Semantics(
      label: semanticsLabel ?? label,
      value: value,
      child: tooltip != null ? Tooltip(message: tooltip!, child: tile) : tile,
    );
    return wrapped;
  }
}

/// Optional legend widget explaining each stat (can be placed on start/help screens).
class GameStatsLegend extends StatelessWidget {
  final Color? textColor;
  const GameStatsLegend({Key? key, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Colors.grey[800];
    final styleTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color);
    final styleItem = TextStyle(fontSize: 13, color: color);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game Stats', style: styleTitle),
        const SizedBox(height: 6),
        _legendRow(Icons.star, 'Score: Points you have earned by solving problems.' , styleItem),
        _legendRow(Icons.favorite, 'Lives: Remaining attempts. Lose one for each wrong answer.' , styleItem),
        _legendRow(Icons.timer, 'Time: Seconds left. Bar shrinks to zero when time runs out.' , styleItem),
        _legendRow(Icons.whatshot, 'Combo: Streak multiplier. Higher combo = bonus points.' , styleItem),
      ],
    );
  }

  Widget _legendRow(IconData icon, String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: style)),
        ],
      ),
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
                color: Colors.blue.withOpacityCompat(0.1),
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
                  ...instructions.map(
                    (instruction) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        instruction,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
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
            const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
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
                  _buildStatRow(
                    'Final Score',
                    score.toString(),
                    Icons.star,
                    Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'Max Combo',
                    'x$maxCombo',
                    Icons.whatshot,
                    Colors.orange,
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
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
            color: Colors.black.withOpacityCompat(0.1),
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

/// Practice Keyboard - Comprehensive keyboard for all practice problems
/// Features:
/// - Numbers (0-9)
/// - Alphabets (A-Z)
/// - Special characters (negative sign, decimal point)
/// - Tab switching between numbers and alphabets
/// - Delete and Submit buttons
class PracticeKeyboard extends StatefulWidget {
  final Function(String) onCharacterPressed;
  final VoidCallback onSubmit;
  final VoidCallback onDelete;
  final Color? backgroundColor;
  final Color submitColor;
  final Color deleteColor;
  final Color tabColor;

  const PracticeKeyboard({
    super.key,
    required this.onCharacterPressed,
    required this.onSubmit,
    required this.onDelete,
    this.backgroundColor,
    this.submitColor = Colors.green,
    this.deleteColor = Colors.red,
    this.tabColor = Colors.blue,
  });

  @override
  State<PracticeKeyboard> createState() => _PracticeKeyboardState();
}

class _PracticeKeyboardState extends State<PracticeKeyboard> {
  bool _showNumbers = true; // true = numbers, false = alphabets

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: widget.backgroundColor ?? Colors.grey[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tab switcher
          Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  label: '123',
                  isActive: _showNumbers,
                  onTap: () => setState(() => _showNumbers = true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTabButton(
                  label: 'ABC',
                  isActive: !_showNumbers,
                  onTap: () => setState(() => _showNumbers = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Keyboard content
          _showNumbers ? _buildNumberKeyboard() : _buildAlphabetKeyboard(),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? widget.tabColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberKeyboard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: 1, 2, 3
        Row(
          children: [
            for (int i = 1; i <= 3; i++)
              Expanded(child: _buildKeyButton(i.toString())),
          ],
        ),
        const SizedBox(height: 6),

        // Row 2: 4, 5, 6
        Row(
          children: [
            for (int i = 4; i <= 6; i++)
              Expanded(child: _buildKeyButton(i.toString())),
          ],
        ),
        const SizedBox(height: 6),

        // Row 3: 7, 8, 9
        Row(
          children: [
            for (int i = 7; i <= 9; i++)
              Expanded(child: _buildKeyButton(i.toString())),
          ],
        ),
        const SizedBox(height: 6),

        // Row 4: -, 0, .
        Row(
          children: [
            Expanded(child: _buildKeyButton('-')),
            Expanded(child: _buildKeyButton('0')),
            Expanded(child: _buildKeyButton('.')),
          ],
        ),
        const SizedBox(height: 6),

        // Row 5: Delete, Submit
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: '⌫',
                onPressed: widget.onDelete,
                color: widget.deleteColor,
              ),
            ),
            Expanded(
              child: _buildActionButton(
                label: '✓',
                onPressed: widget.onSubmit,
                color: widget.submitColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlphabetKeyboard() {
    // QWERTY keyboard layout
    final rows = [
      'QWERTYUIOP'.split(''),
      'ASDFGHJKL'.split(''),
      'ZXCVBNM'.split(''),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Q W E R T Y U I O P
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final char in rows[0])
              Expanded(child: _buildKeyButton(char, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 6),

        // Row 2: A S D F G H J K L
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 15), // Offset for QWERTY layout
            for (final char in rows[1])
              Expanded(child: _buildKeyButton(char, fontSize: 16)),
            const SizedBox(width: 15), // Offset for QWERTY layout
          ],
        ),
        const SizedBox(height: 6),

        // Row 3: Z X C V B N M
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30), // Offset for QWERTY layout
            for (final char in rows[2])
              Expanded(child: _buildKeyButton(char, fontSize: 16)),
            const SizedBox(width: 30), // Offset for QWERTY layout
          ],
        ),
        const SizedBox(height: 6),

        // Row 4: Delete, Space, Submit
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: '⌫',
                onPressed: widget.onDelete,
                color: widget.deleteColor,
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildKeyButton('Space', isSpaceBar: true),
            ),
            Expanded(
              child: _buildActionButton(
                label: '✓',
                onPressed: widget.onSubmit,
                color: widget.submitColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyButton(
    String character, {
    double fontSize = 18,
    bool isSpaceBar = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ElevatedButton(
        onPressed: () {
          if (isSpaceBar) {
            widget.onCharacterPressed(' ');
          } else {
            widget.onCharacterPressed(character);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(
            vertical: isSpaceBar ? 12 : 14,
            horizontal: 4,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          character,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Game Feedback Snackbar - Shows feedback for correct/wrong answers
class GameFeedbackSnackbar {
  static void show(
    BuildContext context, {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
