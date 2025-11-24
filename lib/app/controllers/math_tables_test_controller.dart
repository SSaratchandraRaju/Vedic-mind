import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
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
  late bool retakeMode;

  Timer? _questionTimer;

  static const int totalQuestions = 10;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    sectionIndex = args?['section'] ?? 0;
    startNumber = args?['startNumber'] ?? 1;
    endNumber = args?['endNumber'] ?? 5;
    retakeMode = args?['retake'] ?? false;

    _generateQuestions();
    _startQuestionTimer();
  }

  @override
  void onClose() {
    _questionTimer?.cancel();
    super.onClose();
  }

  int _getTimeForQuestion(int questionIndex) {
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
        timer.cancel();
        if (!showFeedback.value) {
          isCorrect.value = false;
          showFeedback.value = true;
          _hapticError();
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

    for (int i = 0; i < totalQuestions; i++) {
      final minMultiplier = (i * 2) + 1;
      final tableNumber = startNumber + random.nextInt(endNumber - startNumber + 1);
      int multiplier = minMultiplier + random.nextInt(2);
      multiplier = multiplier.clamp(1, 20);
      questions.add(Question(number1: tableNumber, number2: multiplier, answer: tableNumber * multiplier));
    }
  }

  void onNumberTap(String number) {
    if (showFeedback.value) return;
    if (userAnswer.value.length < 4) {
      userAnswer.value += number;
      _attemptAutoSubmit();
    }
  }

  void _attemptAutoSubmit() {
    if (showFeedback.value) return;
    final currentQuestion = questions[currentQuestionIndex.value];
    final expectedLength = currentQuestion.answer.toString().length;
    if (userAnswer.value.length >= expectedLength) {
      checkAnswer();
    }
  }

  void onBackspace() {
    if (showFeedback.value) return;
    if (userAnswer.value.isNotEmpty) {
      userAnswer.value = userAnswer.value.substring(0, userAnswer.value.length - 1);
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
      _hapticSuccess();
    } else {
      _hapticError();
    }

    showFeedback.value = true;

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
      _completeTest();
    }
  }

  void _completeTest() {
    _questionTimer?.cancel();
    final mathTablesController = Get.find<MathTablesController>();
    final points = score.value * 10;
    if (!retakeMode) {
      mathTablesController.updateProgress(
        questionsAttempted: totalQuestions,
        correctAnswers: score.value,
        points: points,
      );
      if (score.value >= 5) {
        mathTablesController.markSectionCompleted(sectionIndex);
      }
    }
    try {
      final globalProgress = Get.find<GlobalProgressController>();
      globalProgress.refreshProgress();
    } catch (e) {
      print('Global progress controller not found: $e');
    }
    Get.back(result: {
      'score': score.value,
      'total': totalQuestions,
      'passed': score.value >= 5,
    });
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

  Future<void> _hapticSuccess() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 40, amplitude: 140);
      }
    } catch (_) {}
  }

  Future<void> _hapticError() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(pattern: [0, 30, 70], intensities: [100, 180]);
      }
    } catch (_) {}
  }
}

class Question {
  final int number1;
  final int number2;
  final int answer;
  Question({required this.number1, required this.number2, required this.answer});
}
