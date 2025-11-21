import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/practice_controller.dart';
import '../../controllers/global_progress_controller.dart';
import '../../ui/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class PracticeResultsView extends StatefulWidget {
  const PracticeResultsView({super.key});

  @override
  State<PracticeResultsView> createState() => _PracticeResultsViewState();
}

class _PracticeResultsViewState extends State<PracticeResultsView> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    // Save practice results when view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _savePracticeResults();
    });
  }

  void _savePracticeResults() {
    final args = Get.arguments as Map<String, dynamic>;
    final questions = args['questions'] as List<PracticeQuestion>;

    final questionsAnswered = questions.where((q) => q.userAnswer != null).length;
    final correctAnswers = questions.where((q) => q.isCorrect).length;

    // Calculate points (10 points per correct answer)
    final pointsEarned = correctAnswers * 10;

    // Get existing totals
    final existingPoints = storage.read<int>('practice_total_points') ?? 0;
    final existingQuestions = storage.read<int>('practice_total_questions') ?? 0;
    final existingCorrect = storage.read<int>('practice_correct_answers') ?? 0;

    // Update totals
    storage.write('practice_total_points', existingPoints + pointsEarned);
    storage.write('practice_total_questions', existingQuestions + questionsAnswered);
    storage.write('practice_correct_answers', existingCorrect + correctAnswers);

    // Add history entry
    if (pointsEarned > 0) {
      try {
        final globalProgress = Get.find<GlobalProgressController>();
        globalProgress.addHistoryEntry(
          section: 'Practice',
          points: pointsEarned,
          description: 'Practice session: $correctAnswers/$questionsAnswered correct',
          type: 'practice',
        );
      } catch (e) {
        print('Error adding practice history: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get results from navigation arguments
    final args = Get.arguments as Map<String, dynamic>;
    final questions = args['questions'] as List<PracticeQuestion>;
    final totalTime = args['totalTime'] as int;

    final questionsAnswered = questions
        .where((q) => q.userAnswer != null)
        .length;
    final correctAnswers = questions.where((q) => q.isCorrect).length;
    final score = questionsAnswered > 0
        ? ((correctAnswers / questionsAnswered) * 100).round()
        : 0;

    final minutes = (totalTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalTime % 60).toString().padLeft(2, '0');
    final formattedTime = '$minutes:$seconds';

    // Calculate points earned (10 points per correct answer)
    final pointsEarned = correctAnswers * 10;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Get.offAllNamed(Routes.HOME),
                  ),
                  const Expanded(
                    child: Text(
                      'Practice Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the close button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Success Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: score >= 70
                            ? Colors.green.withOpacity(0.1)
                            : score >= 50
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        score >= 70
                            ? Icons.emoji_events
                            : score >= 50
                            ? Icons.thumbs_up_down
                            : Icons.sentiment_dissatisfied,
                        size: 50,
                        color: score >= 70
                            ? Colors.green
                            : score >= 50
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      score >= 70
                          ? 'Excellent Work!'
                          : score >= 50
                          ? 'Good Effort!'
                          : 'Keep Practicing!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'You\'ve completed the practice session',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Score Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: score >= 70
                              ? [
                                  const Color(0xFF4CAF50),
                                  const Color(0xFF66BB6A),
                                ]
                              : score >= 50
                              ? [
                                  const Color(0xFFFF9800),
                                  const Color(0xFFFFB74D),
                                ]
                              : [
                                  const Color(0xFFE91E63),
                                  const Color(0xFFF06292),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (score >= 70
                                        ? const Color(0xFF4CAF50)
                                        : score >= 50
                                        ? const Color(0xFFFF9800)
                                        : const Color(0xFFE91E63))
                                    .withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your Score',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$score%',
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$correctAnswers out of $questionsAnswered correct',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Points Earned Badge
                    if (pointsEarned > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+$pointsEarned Points Earned!',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.check_circle_outline,
                            label: 'Questions\nAnswered',
                            value: questionsAnswered.toString(),
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.access_time,
                            label: 'Total Time\nTaken',
                            value: formattedTime,
                            color: const Color(0xFFFF6B6B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.star_outline,
                            label: 'Correct\nAnswers',
                            value: correctAnswers.toString(),
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.error_outline,
                            label: 'Wrong\nAnswers',
                            value: (questionsAnswered - correctAnswers)
                                .toString(),
                            color: const Color(0xFFE91E63),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to detailed answers view
                          Get.to(
                            () => PracticeAnswersView(questions: questions),
                            transition: Transition.rightToLeft,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.visibility_outlined, size: 20),
                        label: const Text(
                          'View All Answers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed(Routes.MATH_TABLES),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Practice Again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Get.offAllNamed(Routes.HOME),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              fontFamily: 'Poppins',
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Detailed Answers View
class PracticeAnswersView extends StatelessWidget {
  final List<PracticeQuestion> questions;

  const PracticeAnswersView({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Your Answers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final isAnswered = question.userAnswer != null;
          final isCorrect = question.isCorrect;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: !isAnswered
                    ? Colors.grey[300]!
                    : isCorrect
                    ? Colors.green.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Number and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Q${(index + 1).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: !isAnswered
                            ? Colors.grey[100]
                            : isCorrect
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            !isAnswered
                                ? Icons.remove_circle_outline
                                : isCorrect
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 16,
                            color: !isAnswered
                                ? Colors.grey[600]
                                : isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            !isAnswered
                                ? 'Skipped'
                                : isCorrect
                                ? 'Correct'
                                : 'Wrong',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: !isAnswered
                                  ? Colors.grey[600]
                                  : isCorrect
                                  ? Colors.green
                                  : Colors.red,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Question
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 20),

                // User Answer
                if (isAnswered) ...[
                  _buildAnswerRow(
                    label: 'Your Answer',
                    value: question.userAnswer.toString(),
                    isCorrect: isCorrect,
                    isUserAnswer: true,
                  ),

                  if (!isCorrect) ...[
                    const SizedBox(height: 12),
                    _buildAnswerRow(
                      label: 'Correct Answer',
                      value: question.correctAnswer.toString(),
                      isCorrect: true,
                      isUserAnswer: false,
                    ),
                  ],
                ] else ...[
                  _buildAnswerRow(
                    label: 'Correct Answer',
                    value: question.correctAnswer.toString(),
                    isCorrect: true,
                    isUserAnswer: false,
                  ),
                ],

                const SizedBox(height: 12),

                // Time spent
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Time: ${question.timeSpent}s',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnswerRow({
    required String label,
    required String value,
    required bool isCorrect,
    required bool isUserAnswer,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUserAnswer && !isCorrect
            ? Colors.red.withOpacity(0.05)
            : Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUserAnswer && !isCorrect
              ? Colors.red.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isUserAnswer && !isCorrect
                    ? Icons.close_rounded
                    : Icons.check_rounded,
                color: isUserAnswer && !isCorrect ? Colors.red : Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isUserAnswer && !isCorrect ? Colors.red : Colors.green,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
