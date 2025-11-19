import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/practice_controller.dart';
import '../../theme/app_colors.dart';

class PracticeView extends GetView<PracticeController> {
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => _showExitDialog(context),
        ),
        title: const Text(
          'Practice',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() => Stack(
        children: [
          Column(
            children: [
              // Timer and Progress Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildTimerSection(),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Question Display
                      Text(
                        controller.currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // User Input Display
                      Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: controller.userInput.value.isEmpty 
                                  ? Colors.grey[300]! 
                                  : AppColors.primary,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          controller.userInput.value.isEmpty ? '' : controller.userInput.value,
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            color: controller.userInput.value.isEmpty 
                                ? Colors.grey[400] 
                                : AppColors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Number Pad
                      _buildNumberPad(),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Feedback Icon in Top Right Corner (if showing) - subtle and small
          if (controller.showFeedback.value)
            Positioned(
              top: 140,
              right: 16,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value * 0.6, // More subtle
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: controller.isCorrectAnswer.value
                            ? Colors.green.withOpacity(0.9)
                            : Colors.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.isCorrectAnswer.value
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      )),
    );
  }
  
  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Labels Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Full Time Label
              Expanded(
                child: Text(
                  'Full Time',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              // Question Label
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Question: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      controller.currentQuestionNumber.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Time Label
              Expanded(
                child: Text(
                  'Time',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Timer Chips Row
          Row(
            children: [
              // Full Time Chip
              Expanded(
                child: _buildTimerChip(
                  time: controller.formattedTime,
                  color: AppColors.primary,
                  progress: controller.totalTimeProgress,
                ),
              ),
              const SizedBox(width: 12),
              // Question Number Chip (no border progress)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.currentQuestionNumber}/${controller.questions.length}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Q1 Time Chip
              Expanded(
                child: _buildTimerChip(
                  time: controller.questionTimerFormatted,
                  color: _getTimerColor(),
                  progress: controller.questionTimerProgress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimerChip({
    required String time,
    required Color color,
    required double progress,
  }) {
    return CustomPaint(
      foregroundPainter: _ProgressBorderPainter(
        progress: progress,
        color: color,
        borderRadius: 12,
        borderWidth: 3,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 3,
          ),
        ),
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
  
  Color _getTimerColor() {
    final progress = controller.questionTimerProgress;
    if (progress > 0.66) {
      return Colors.green; // > 66% time left
    } else if (progress > 0.33) {
      return Colors.orange; // 33-66% time left
    } else {
      return Colors.red; // < 33% time left
    }
  }
  
  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          _buildNumberRow(['1', '2', '3']),
          const SizedBox(height: 12),
          
          // Row 2: 4, 5, 6
          _buildNumberRow(['4', '5', '6']),
          const SizedBox(height: 12),
          
          // Row 3: 7, 8, 9
          _buildNumberRow(['7', '8', '9']),
          const SizedBox(height: 12),
          
          // Row 4: 0, backspace
          Row(
            children: [
              // 0 button (wider)
              Expanded(
                flex: 2,
                child: _buildNumberButton('0', isWide: true),
              ),
              const SizedBox(width: 12),
              
              // Backspace button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.backspace_outlined,
                  onTap: controller.onBackspace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      children: numbers.map((number) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: number != numbers.last ? 12 : 0,
            ),
            child: _buildNumberButton(number),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildNumberButton(String number, {bool isWide = false}) {
    return GestureDetector(
      onTap: () {
        controller.onNumberTap(number);
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 28,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
  
  void _showExitDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Exit Practice?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        content: const Text(
          'Your progress will be lost. Are you sure you want to exit?',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.pauseAndExit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Exit',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for progress border that decreases in length
class _ProgressBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double borderRadius;
  final double borderWidth;

  _ProgressBorderPainter({
    required this.progress,
    required this.color,
    required this.borderRadius,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    // Create the rect with proper insets for the border
    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    
    // Create path and calculate length
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;
    
    // Calculate how much of the border to draw based on progress
    final drawLength = totalLength * progress.clamp(0.0, 1.0);

    // Extract only the portion of the path we want to draw
    final extractPath = pathMetrics.extractPath(0, drawLength);
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(_ProgressBorderPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
