import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/enhanced_vedic_course_controller.dart';
import '../../data/models/interactive_step_model.dart' hide Badge;
import '../../data/models/interactive_step_model.dart' as models;

/// Example UI Implementations for Interactive Learning
/// These are reference implementations for the Flutter team

// ==================== TAP TO REVEAL WIDGET ====================

class TapToRevealCard extends StatefulWidget {
  final InteractiveStep step;
  final VoidCallback onReveal;
  
  const TapToRevealCard({
    Key? key,
    required this.step,
    required this.onReveal,
  }) : super(key: key);

  @override
  State<TapToRevealCard> createState() => _TapToRevealCardState();
}

class _TapToRevealCardState extends State<TapToRevealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    if (!widget.step.isRevealed) {
      widget.onReveal();
      _controller.forward();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * 3.14159; // 180 degrees
          final isUnder = _flipAnimation.value > 0.5;
          
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isUnder
              ? _buildRevealedContent()
              : _buildHiddenContent(),
          );
        },
      ),
    );
  }
  
  Widget _buildHiddenContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade200],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app, size: 48, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            'Tap to Reveal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRevealedContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.step.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.step.content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ==================== FILL IN THE BLANK WIDGET ====================

class FillInBlankWidget extends StatefulWidget {
  final InteractiveStep step;
  final Function(String) onSubmit;
  
  const FillInBlankWidget({
    Key? key,
    required this.step,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<FillInBlankWidget> createState() => _FillInBlankWidgetState();
}

class _FillInBlankWidgetState extends State<FillInBlankWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _shakeController;
  bool? _isCorrect;
  
  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }
  
  void _handleSubmit() {
    final answer = _controller.text.trim();
    final correctAnswer = widget.step.interactionData?['answer'] as String?;
    
    setState(() {
      _isCorrect = answer.toLowerCase() == correctAnswer?.toLowerCase();
    });
    
    if (_isCorrect!) {
      _showSuccessAnimation();
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
    
    widget.onSubmit(answer);
  }
  
  void _showSuccessAnimation() {
    // Show confetti or success animation
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final offset = _shakeController.value * 10;
        return Transform.translate(
          offset: Offset(offset * (offset > 5 ? -1 : 1), 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.step.content,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter your answer',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _isCorrect == null
                    ? Colors.blue
                    : _isCorrect!
                      ? Colors.green
                      : Colors.red,
                  width: 2,
                ),
              ),
              suffixIcon: _isCorrect != null
                ? Icon(
                    _isCorrect! ? Icons.check_circle : Icons.cancel,
                    color: _isCorrect! ? Colors.green : Colors.red,
                  )
                : null,
            ),
            onSubmitted: (_) => _handleSubmit(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Submit'),
          ),
          if (_isCorrect == false && widget.step.interactionData?['hint'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hint: ${widget.step.interactionData!['hint']}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== TTS CONTROL BAR ====================

class TTSControlBar extends StatelessWidget {
  final EnhancedVedicCourseController controller;
  
  const TTSControlBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Play/Pause Button
          IconButton(
            icon: Icon(
              controller.isStepTTSPlaying.value
                ? Icons.pause_circle_filled
                : Icons.play_circle_filled,
              size: 40,
            ),
            color: Colors.blue,
            onPressed: () {
              if (controller.isStepTTSPlaying.value) {
                controller.stopStepTTS();
              } else {
                controller.playStepTTS();
              }
            },
          ),
          
          const SizedBox(width: 16),
          
          // Auto-play Toggle
          Row(
            children: [
              Switch(
                value: controller.isAutoPlayEnabled.value,
                onChanged: (_) => controller.toggleAutoPlay(),
              ),
              const Text('Auto-play'),
            ],
          ),
          
          const Spacer(),
          
          // TTS Enable/Disable
          IconButton(
            icon: Icon(
              controller.isTTSEnabled.value
                ? Icons.volume_up
                : Icons.volume_off,
            ),
            onPressed: controller.toggleTTS,
          ),
        ],
      ),
    ));
  }
}

// ==================== XP PROGRESS BAR ====================

class XPProgressBar extends StatelessWidget {
  final int totalXP;
  final int currentLevel;
  
  const XPProgressBar({
    Key? key,
    required this.totalXP,
    required this.currentLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (totalXP % 500) / 500;
    final xpInLevel = totalXP % 500;
    final xpNeeded = 500;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $currentLevel',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$xpInLevel / $xpNeeded XP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(
                _getLevelColor(currentLevel),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getLevelColor(int level) {
    if (level >= 10) return Colors.purple;
    if (level >= 7) return Colors.deepOrange;
    if (level >= 5) return Colors.amber;
    if (level >= 3) return Colors.green;
    return Colors.blue;
  }
}

// ==================== BADGE CARD ====================

class BadgeCard extends StatelessWidget {
  final models.Badge badge;
  
  const BadgeCard({
    Key? key,
    required this.badge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: badge.isEarned ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: badge.isEarned
            ? LinearGradient(
                colors: [
                  _getTierColor(badge.tier).withOpacity(0.3),
                  _getTierColor(badge.tier).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              size: 48,
              color: badge.isEarned
                ? _getTierColor(badge.tier)
                : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: badge.isEarned ? Colors.black : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (!badge.isEarned) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: badge.progressPercentage,
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 4),
              Text(
                '${badge.currentProgress}/${badge.requirement}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Color _getTierColor(models.BadgeTier tier) {
    switch (tier) {
      case models.BadgeTier.bronze:
        return const Color(0xFFCD7F32);
      case models.BadgeTier.silver:
        return const Color(0xFFC0C0C0);
      case models.BadgeTier.gold:
        return const Color(0xFFFFD700);
      case models.BadgeTier.platinum:
        return const Color(0xFFE5E4E2);
      case models.BadgeTier.diamond:
        return const Color(0xFFB9F2FF);
    }
  }
}

// ==================== STREAK DISPLAY ====================

class StreakDisplay extends StatelessWidget {
  final int streakDays;
  
  const StreakDisplay({
    Key? key,
    required this.streakDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.red.shade400],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$streakDays Day Streak!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Keep it going!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== INTERACTIVE LESSON SCREEN EXAMPLE ====================

class InteractiveLessonScreen extends StatelessWidget {
  final EnhancedVedicCourseController controller = Get.find();
  
  InteractiveLessonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.currentLesson.value?.lessonTitle ?? 'Lesson',
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showLessonInfo,
          ),
        ],
      ),
      body: Obx(() {
        final step = controller.currentStep.value;
        
        if (step == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: controller.lessonProgress.value,
            ),
            
            // Step content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step number
                    Text(
                      'Step ${step.stepNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Step title
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Interactive content based on type
                    _buildInteractiveContent(step),
                  ],
                ),
              ),
            ),
            
            // TTS Controls
            TTSControlBar(controller: controller),
            
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        );
      }),
    );
  }
  
  Widget _buildInteractiveContent(InteractiveStep step) {
    switch (step.interactionType) {
      case InteractionType.tapToReveal:
        return TapToRevealCard(
          step: step,
          onReveal: controller.revealStep,
        );
      
      case InteractionType.fillInBlank:
        return FillInBlankWidget(
          step: step,
          onSubmit: (answer) {
            // Handle answer submission
          },
        );
      
      // Add other interaction types...
      default:
        return Text(step.content);
    }
  }
  
  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Obx(() => ElevatedButton.icon(
            onPressed: controller.currentStepIndex.value > 0
              ? controller.previousStep
              : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
          )),
          const Spacer(),
          Obx(() => ElevatedButton.icon(
            onPressed: controller.nextStep,
            icon: const Icon(Icons.arrow_forward),
            label: Text(
              controller.currentStepIndex.value < controller.lessonSteps.length - 1
                ? 'Next'
                : 'Complete',
            ),
          )),
        ],
      ),
    );
  }
  
  void _showLessonInfo() {
    // Show lesson objective and summary
  }
}
