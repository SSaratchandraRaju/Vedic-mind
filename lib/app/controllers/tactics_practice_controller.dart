import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vedic_course_controller.dart';
import 'global_progress_controller.dart';
import '../data/models/vedic_course_models.dart';
import '../data/repositories/firestore_progress_repository.dart';
import '../services/auth_service.dart';

class TacticsPracticeController extends GetxController {
  final VedicCourseController vedicController =
      Get.find<VedicCourseController>();
  final FirestoreProgressRepository _progressRepo = FirestoreProgressRepository();
  AuthService? _authService;
  String? _userId;

  final isLoading = true.obs;
  final currentQuestionIndex = 0.obs;
  final totalQuestions = 0.obs;
  final currentQuestion = Rxn<PracticeQuestion>();
  final currentTacticName = ''.obs;
  final hintVisible = false.obs;
  final answerController = TextEditingController();
  final userAnswer = ''.obs; // Observable answer for keyboard input

  // Timer and points tracking
  final questionTimeRemaining = 0.obs;
  final questionTimeLimit = 30.obs; // 30 seconds per question
  final totalPoints = 0.obs;
  Timer? _questionTimer;

  List<Map<String, dynamic>> allQuestions = [];
  int correctAnswers = 0;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
    _loadQuestions();
  }

  Future<void> _initAuth() async {
    try {
      _authService = Get.find<AuthService>();
      final user = await _authService!.getCurrentUser();
      _userId = user?.id;
    } catch (_) {}
  }

  @override
  void onClose() {
    _questionTimer?.cancel();
    answerController.dispose();
    super.onClose();
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    questionTimeRemaining.value = questionTimeLimit.value;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (questionTimeRemaining.value > 0) {
        questionTimeRemaining.value--;
      } else {
        // Time's up - mark as incorrect and move to next question
        timer.cancel();
        Get.snackbar(
          '⏰ Time\'s Up!',
          'Moving to next question',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.1),
          duration: const Duration(seconds: 1),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (isLastQuestion) {
            _finishPractice();
          } else {
            nextQuestion();
          }
        });
      }
    });
  }

  Future<void> _loadQuestions() async {
    isLoading.value = true;

    // Wait for course data to load if it hasn't loaded yet
    if (vedicController.chapters.isEmpty) {
      print('Course not loaded yet, loading now...');
      await vedicController.loadCourse();
      // Give a small delay to ensure data is ready
      await Future.delayed(const Duration(milliseconds: 100));
    }

    print('Total chapters available: ${vedicController.chapters.length}');

    // Gather all practice problems from all tactics (lessons)
    final allLessons = vedicController.getAllLessons();
    print('Total lessons available: ${allLessons.length}');

    for (var item in allLessons) {
      final lesson = item['lesson'] as Lesson;
      print(
        'Lesson: ${lesson.lessonTitle}, Practice problems: ${lesson.practice.length}',
      );
      for (var problem in lesson.practice) {
        allQuestions.add({'problem': problem, 'lesson': lesson});
      }
    }

    print('Total questions gathered: ${allQuestions.length}');

    // Shuffle questions for randomness
    allQuestions.shuffle(Random());

    // Limit to 20 questions
    if (allQuestions.length > 20) {
      allQuestions = allQuestions.sublist(0, 20);
    }

    totalQuestions.value = allQuestions.length;

    if (allQuestions.isNotEmpty) {
      _loadCurrentQuestion();
    }

    isLoading.value = false;
  }

  void _loadCurrentQuestion() {
    if (currentQuestionIndex.value < allQuestions.length) {
      final questionData = allQuestions[currentQuestionIndex.value];
      currentQuestion.value = questionData['problem'] as PracticeQuestion;
      currentTacticName.value = (questionData['lesson'] as Lesson).lessonTitle;
      hintVisible.value = false;
      answerController.clear();
      userAnswer.value = ''; // Clear observable answer
      _startQuestionTimer(); // Start timer for the new question
    }
  }

  void showHint() {
    hintVisible.value = true;
  }

  void updateAnswer(String answer) {
    userAnswer.value = answer;
    answerController.text = answer;
  }

  void addCharacter(String character) {
    userAnswer.value += character;
    answerController.text = userAnswer.value;
  }

  void deleteCharacter() {
    if (userAnswer.value.isNotEmpty) {
      userAnswer.value = userAnswer.value.substring(
        0,
        userAnswer.value.length - 1,
      );
      answerController.text = userAnswer.value;
    }
  }

  void submitAnswer() {
    if (answerController.text.trim().isEmpty) {
      Get.snackbar(
        'Empty Answer',
        'Please enter your answer',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _questionTimer?.cancel(); // Stop the timer

    final userAnswer = answerController.text.trim().toLowerCase();
    final correctAnswer = currentQuestion.value!.answer.trim().toLowerCase();

    if (userAnswer == correctAnswer) {
      correctAnswers++;
      // Award points: 10 base points + bonus for time remaining
      final timeBonus = questionTimeRemaining.value;
      final questionPoints = 10 + timeBonus;
      totalPoints.value += questionPoints;

      Get.snackbar(
        '✅ Correct!',
        '+$questionPoints points (${timeBonus}s bonus)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        duration: const Duration(seconds: 1),
      );
    } else {
      Get.snackbar(
        '❌ Incorrect',
        'Correct answer: ${currentQuestion.value!.answer}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 2),
      );
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (isLastQuestion) {
        _finishPractice();
      } else {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < allQuestions.length - 1) {
      currentQuestionIndex.value++;
      _loadCurrentQuestion();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      _loadCurrentQuestion();
    }
  }

  void _finishPractice() {
    _questionTimer?.cancel();

    final accuracy = (correctAnswers / totalQuestions.value * 100).round();

    // Local storage mirrors removed; rely solely on remote repository aggregation.

    // Firestore remote persistence
    if (_userId != null) {
      // Record session granularly
      _progressRepo.recordPracticeSession(
        userId: _userId!,
        mode: 'tactics',
        operation: 'mixed',
        questionsAttempted: totalQuestions.value,
        correctAnswers: correctAnswers,
        pointsEarned: totalPoints.value,
        durationSeconds: totalQuestions.value * questionTimeLimit.value, // rough estimate
        source: 'tactics_practice_controller',
      );
      // No manual totals update needed; recordPracticeSession triggers recomputePracticeTotals.
    }

    // Refresh global progress
    try {
      final globalProgress = Get.find<GlobalProgressController>();
      globalProgress.addHistoryEntry(
        section: 'Tactics Practice',
        points: totalPoints.value,
        description: 'Completed $correctAnswers/$totalQuestions questions',
        type: 'practice',
      );
      globalProgress.refreshProgress();
    } catch (e) {
      print('Global progress controller not found: $e');
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Practice Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              '$correctAnswers/${totalQuestions.value} Correct',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('$accuracy% Accuracy'),
            const SizedBox(height: 8),
            Text(
              '${totalPoints.value} Points Earned',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to practice hub
            },
            child: const Text('Done'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  bool get isLastQuestion =>
      currentQuestionIndex.value >= allQuestions.length - 1;
}
