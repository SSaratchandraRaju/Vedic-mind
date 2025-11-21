import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'math_tables_controller.dart';
import 'global_progress_controller.dart';

class MathTablesTestController extends GetxController {
  final currentNavIndex = 1.obs;
  final currentQuestionIndex = 0.obs;
  final score = 0.obs;
  final userAnswer = ''.obs;
  final showFeedback = false.obs;
  final isCorrect = false.obs;
  final questionTimeRemaining = 0.obs;
  final questionTimeLimit = 0.obs;

  late int sectionIndex;
  late int startNumber;
  late int endNumber;
  late List<Question> questions;

  Timer? _questionTimer;

  static const int totalQuestions = 10;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    sectionIndex = args?['section'] ?? 0;
    startNumber = args?['startNumber'] ?? 1;
    endNumber = args?['endNumber'] ?? 5;

    _generateQuestions();
    _startQuestionTimer();
  }

  @override
  void onClose() {
    _questionTimer?.cancel();
    super.onClose();
  }

  int _getTimeForQuestion(int questionIndex) {
    // Easier questions get more time, harder questions get less time
    // Question 1 (easiest): 20 seconds
    // Question 10 (hardest): 10 seconds
    // Linear decrease: 20 - (questionIndex * 1) seconds
    return (20 - questionIndex).clamp(10, 20);
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();

    questionTimeLimit.value = _getTimeForQuestion(currentQuestionIndex.value);
    questionTimeRemaining.value = questionTimeLimit.value;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (questionTimeRemaining.value > 0) {
        questionTimeRemaining.value--;
      } else {
        // Time's up - mark as incorrect and move to next question
        timer.cancel();
        if (!showFeedback.value) {
          isCorrect.value = false;
          showFeedback.value = true;

          Future.delayed(const Duration(milliseconds: 1500), () {
            nextQuestion();
          });
        }
      }
    });
  }

  void _generateQuestions() {
    questions = [];
    final random = Random();

    // Generate 10 questions with gradually increasing difficulty
    for (int i = 0; i < totalQuestions; i++) {
      int tableNumber;
      int multiplier;

      // Gradual difficulty progression from 1-20
      // Question 1: multiplier 1-2
      // Question 2: multiplier 3-4
      // Question 3: multiplier 5-6
      // ...
      // Question 10: multiplier 19-20

      final minMultiplier = (i * 2) + 1;

      tableNumber = startNumber + random.nextInt(endNumber - startNumber + 1);
      multiplier = minMultiplier + random.nextInt(2);

      // Clamp multiplier to max 20
      multiplier = multiplier.clamp(1, 20);

      questions.add(
        Question(
          number1: tableNumber,
          number2: multiplier,
          answer: tableNumber * multiplier,
        ),
      );
    }
  }

  void onNumberTap(String number) {
    if (showFeedback.value) return;

    if (userAnswer.value.length < 4) {
      userAnswer.value += number;
    }
  }

  void onBackspace() {
    if (showFeedback.value) return;

    if (userAnswer.value.isNotEmpty) {
      userAnswer.value = userAnswer.value.substring(
        0,
        userAnswer.value.length - 1,
      );
    }
  }

  void onClear() {
    if (showFeedback.value) return;
    userAnswer.value = '';
  }

  void checkAnswer() {
    if (userAnswer.value.isEmpty || showFeedback.value) return;

    _questionTimer?.cancel();

    final currentQuestion = questions[currentQuestionIndex.value];
    final userAnswerInt = int.tryParse(userAnswer.value) ?? -1;

    isCorrect.value = userAnswerInt == currentQuestion.answer;
    if (isCorrect.value) {
      score.value++;
    }

    showFeedback.value = true;

    // Auto advance after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      userAnswer.value = '';
      showFeedback.value = false;
      isCorrect.value = false;
      _startQuestionTimer();
    } else {
      // Test completed
      _completeTest();
    }
  }

  void _completeTest() {
    _questionTimer?.cancel();

    // Import the main controller to mark section completed and update progress
    final mathTablesController = Get.find<MathTablesController>();

    // Calculate points based on score (10 points per correct answer)
    final points = score.value * 10;

    // Update overall progress
    mathTablesController.updateProgress(
      questionsAttempted: totalQuestions,
      correctAnswers: score.value,
      points: points,
    );

    // Mark section as completed if score is at least 5/10 (50%)
    if (score.value >= 5) {
      mathTablesController.markSectionCompleted(sectionIndex);
    }

    // Refresh global progress
    try {
      final globalProgress = Get.find<GlobalProgressController>();
      globalProgress.refreshProgress();
    } catch (e) {
      print('Global progress controller not found: $e');
    }

    // Navigate to results or back
    Get.back(
      result: {
        'score': score.value,
        'total': totalQuestions,
        'passed': score.value >= 5,
      },
    );
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed(Routes.LEADERBOARD);
        break;
      case 1:
        Get.toNamed(Routes.HOME);
        break;
      case 2:
        Get.toNamed(Routes.HISTORY);
        break;
    }
  }
}

class Question {
  final int number1;
  final int number2;
  final int answer;

  Question({
    required this.number1,
    required this.number2,
    required this.answer,
  });
}
