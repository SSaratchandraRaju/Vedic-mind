import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'enhanced_vedic_course_controller.dart';
import 'global_progress_controller.dart';
import '../data/models/sutra_simple_model.dart';

class SutrasPracticeController extends GetxController {
  final EnhancedVedicCourseController vedicController =
      Get.find<EnhancedVedicCourseController>();
  final storage = GetStorage();

  final isLoading = true.obs;
  final currentQuestionIndex = 0.obs;
  final totalQuestions = 0.obs;
  final currentQuestion = Rxn<PracticeProblem>();
  final currentSutraName = ''.obs;
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
    _loadQuestions();
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

    // Wait for sutras to load if they haven't loaded yet
    if (vedicController.allSutras.isEmpty) {
      print('Sutras not loaded yet, loading now...');
      await vedicController.loadSutrasFromJson();
      // Give a small delay to ensure data is ready
      await Future.delayed(const Duration(milliseconds: 100));
    }

    print('Total sutras available: ${vedicController.allSutras.length}');

    // Gather all practice problems from all sutras
    for (var sutra in vedicController.allSutras) {
      print(
        'Sutra: ${sutra.name}, Practice problems: ${sutra.practice.length}',
      );
      for (var problem in sutra.practice) {
        allQuestions.add({'problem': problem, 'sutra': sutra});
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
      currentQuestion.value = questionData['problem'] as PracticeProblem;
      currentSutraName.value = (questionData['sutra'] as SutraSimpleModel).name;
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

    // Save progress to storage
    final currentPoints = storage.read<int>('practice_sutras_points') ?? 0;
    final currentQuestions =
        storage.read<int>('practice_sutras_questions') ?? 0;
    final currentCorrect = storage.read<int>('practice_sutras_correct') ?? 0;

    storage.write('practice_sutras_points', currentPoints + totalPoints.value);
    storage.write(
      'practice_sutras_questions',
      currentQuestions + totalQuestions.value,
    );
    storage.write('practice_sutras_correct', currentCorrect + correctAnswers);

    // Update global practice stats
    final globalPoints = storage.read<int>('practice_total_points') ?? 0;
    final globalQuestions = storage.read<int>('practice_total_questions') ?? 0;
    final globalCorrect = storage.read<int>('practice_correct_answers') ?? 0;

    storage.write('practice_total_points', globalPoints + totalPoints.value);
    storage.write(
      'practice_total_questions',
      globalQuestions + totalQuestions.value,
    );
    storage.write('practice_correct_answers', globalCorrect + correctAnswers);

    // Refresh global progress
    try {
      final globalProgress = Get.find<GlobalProgressController>();
      globalProgress.addHistoryEntry(
        section: 'Sutra Practice',
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
