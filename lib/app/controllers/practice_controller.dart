import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../routes/app_routes.dart';

class PracticeQuestion {
  final int num1;
  final int num2;
  final String operator;
  final int correctAnswer;
  int? userAnswer;
  int timeSpent = 0;

  PracticeQuestion({
    required this.num1,
    required this.num2,
    required this.operator,
    required this.correctAnswer,
  });

  String get question {
    return '$num1 $operator $num2 = ';
  }

  bool get isCorrect => userAnswer == correctAnswer;
}

class PracticeController extends GetxController {
  final questions = <PracticeQuestion>[].obs;
  final currentQuestionIndex = 0.obs;
  final userInput = ''.obs;
  final questionTimer = 10.obs; // seconds per question
  final totalTimeElapsed = 0.obs; // Total time elapsed
  final totalTimeLimit = 0.obs; // Total time limit set by user
  final isActive = false.obs;
  final showFeedback = false.obs; // Show tick/cross feedback
  final isCorrectAnswer = false.obs; // Track if answer was correct

  Timer? _questionTimer;
  Timer? _totalTimer;
  DateTime? _practiceStartTime;

  int selectedOperation = 0; // 0: +, 1: -, 2: ×, 3: ÷
  List<int> selectedOperations = []; // Multiple operations support
  int numberOfQuestions = 20;
  int questionTimeLimit = 10; // Time limit per question in seconds

  @override
  void onInit() {
    super.onInit();

    // Get parameters from navigation
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      selectedOperation = args['operation'] ?? 0;
      selectedOperations = (args['selectedOperations'] as List<dynamic>?)
              ?.cast<int>() ?? [selectedOperation];
      numberOfQuestions = args['tasks'] ?? 20;
      questionTimeLimit = args['timePerQuestion'] ?? 10;
      final totalMinutes = args['totlTime'] ?? 0;

      totalTimeLimit.value = (totalMinutes * 60)
          .toInt(); // Convert minutes to seconds and to int
    }

    _generateQuestions();
    _startPractice();
  }

  @override
  void onClose() {
    _questionTimer?.cancel();
    _totalTimer?.cancel();
    super.onClose();
  }

  void _generateQuestions() {
    final random = Random();
    final operators = ['+', '−', '×', '÷'];

    for (int i = 0; i < numberOfQuestions; i++) {
      // Pick random operation from selected operations
      final operationIndex = selectedOperations.isNotEmpty
          ? selectedOperations[random.nextInt(selectedOperations.length)]
          : selectedOperation;
      
      final operator = operators[operationIndex];
      
      int num1, num2, answer;

      // Progressive difficulty: easy -> medium -> hard
      int difficulty = (i ~/ 7).clamp(
        0,
        2,
      ); // 0-6: easy, 7-13: medium, 14-19: hard

      switch (operationIndex) {
        case 0: // Addition
          if (difficulty == 0) {
            num1 = random.nextInt(10) + 1; // 1-10
            num2 = random.nextInt(10) + 1;
          } else if (difficulty == 1) {
            num1 = random.nextInt(20) + 10; // 10-29
            num2 = random.nextInt(20) + 10;
          } else {
            num1 = random.nextInt(50) + 20; // 20-69
            num2 = random.nextInt(50) + 20;
          }
          answer = num1 + num2;
          break;

        case 1: // Subtraction
          if (difficulty == 0) {
            num1 = random.nextInt(10) + 5; // 5-14
            num2 = random.nextInt(num1); // num2 < num1
          } else if (difficulty == 1) {
            num1 = random.nextInt(20) + 15; // 15-34
            num2 = random.nextInt(num1);
          } else {
            num1 = random.nextInt(50) + 30; // 30-79
            num2 = random.nextInt(num1);
          }
          answer = num1 - num2;
          break;

        case 2: // Multiplication
          if (difficulty == 0) {
            num1 = random.nextInt(9) + 2; // 2-10
            num2 = random.nextInt(9) + 2;
          } else if (difficulty == 1) {
            num1 = random.nextInt(8) + 5; // 5-12
            num2 = random.nextInt(8) + 5;
          } else {
            num1 = random.nextInt(10) + 10; // 10-19
            num2 = random.nextInt(10) + 5; // 5-14
          }
          answer = num1 * num2;
          break;

        case 3: // Division
          if (difficulty == 0) {
            num2 = random.nextInt(8) + 2; // 2-9
            answer = random.nextInt(9) + 2; // 2-10
          } else if (difficulty == 1) {
            num2 = random.nextInt(7) + 4; // 4-10
            answer = random.nextInt(10) + 5; // 5-14
          } else {
            num2 = random.nextInt(8) + 5; // 5-12
            answer = random.nextInt(15) + 10; // 10-24
          }
          num1 = num2 * answer; // Ensure exact division
          break;

        default:
          num1 = 0;
          num2 = 0;
          answer = 0;
      }

      questions.add(
        PracticeQuestion(
          num1: num1,
          num2: num2,
          operator: operator,
          correctAnswer: answer,
        ),
      );
    }
  }

  void _startPractice() {
    isActive.value = true;
    _practiceStartTime = DateTime.now();
    _startQuestionTimer();
    _startTotalTimer();
  }

  void _startQuestionTimer() {
    questionTimer.value = questionTimeLimit;
    _questionTimer?.cancel();

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (questionTimer.value > 0) {
        questionTimer.value--;
        questions[currentQuestionIndex.value].timeSpent++;
      } else {
        // Time's up, move to next question
        _nextQuestion();
      }
    });
  }

  void _startTotalTimer() {
    _totalTimer?.cancel();
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_practiceStartTime != null) {
        totalTimeElapsed.value = DateTime.now()
            .difference(_practiceStartTime!)
            .inSeconds;

        // Check if total time limit exceeded
        if (totalTimeLimit.value > 0 &&
            totalTimeElapsed.value >= totalTimeLimit.value) {
          _endPractice(); // Auto-submit when time is up
        }
      }
    });
  }

  void onNumberTap(String number) {
    if (userInput.value.length < 4) {
      // Max 4 digits
      userInput.value += number;

      // Auto-submit when answer length matches expected answer length
      final expectedLength = currentQuestion.correctAnswer.toString().length;
      if (userInput.value.length >= expectedLength &&
          userInput.value.length >= 1) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (userInput.value.isNotEmpty && !showFeedback.value) {
            onSubmit();
          }
        });
      }
    }
  }

  void onBackspace() {
    if (userInput.value.isNotEmpty) {
      userInput.value = userInput.value.substring(
        0,
        userInput.value.length - 1,
      );
    }
  }

  void onSubmit() {
    if (userInput.value.isEmpty || showFeedback.value) return;

    // Store user's answer
    questions[currentQuestionIndex.value].userAnswer = int.tryParse(
      userInput.value,
    );

    // Check if answer is correct
    final isCorrect = questions[currentQuestionIndex.value].isCorrect;
    isCorrectAnswer.value = isCorrect;

    // Show feedback animation
    showFeedback.value = true;

    // Trigger haptic feedback
    _triggerHapticFeedback(isCorrect);

    // Hide feedback and move to next question after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      showFeedback.value = false;
      _nextQuestion();
    });
  }

  Future<void> _triggerHapticFeedback(bool isCorrect) async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        if (isCorrect) {
          // Medium vibration for correct answer (50ms)
          await Vibration.vibrate(duration: 50, amplitude: 128);
        } else {
          // Strong vibration pattern for wrong answer
          await Vibration.vibrate(
            pattern: [0, 100, 50, 100], // vibrate-pause-vibrate pattern
            intensities: [0, 255, 0, 255], // high intensity
          );
        }
      }
    } catch (e) {
      // Vibration not supported, skip
      print('Vibration not supported: $e');
    }
  }

  void _nextQuestion() {
    userInput.value = '';
    showFeedback.value = false;

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      _startQuestionTimer();
    } else {
      _endPractice();
    }
  }

  void _endPractice() {
    _questionTimer?.cancel();
    _totalTimer?.cancel();
    isActive.value = false;

    // Navigate to results
    Get.offNamed(
      Routes.PRACTICE_RESULTS,
      arguments: {'questions': questions, 'totalTime': totalTimeElapsed.value},
    );
  }

  void pauseAndExit() {
    _questionTimer?.cancel();
    _totalTimer?.cancel();
    isActive.value = false;
    Get.back();
  }

  // Helper getters
  PracticeQuestion get currentQuestion => questions[currentQuestionIndex.value];
  int get questionsAnswered =>
      questions.where((q) => q.userAnswer != null).length;
  int get correctAnswers => questions.where((q) => q.isCorrect).length;
  int get currentQuestionNumber => currentQuestionIndex.value + 1;

  String get formattedTime {
    // Calculate remaining time (countdown from total limit)
    final remainingTime = totalTimeLimit.value > 0
        ? (totalTimeLimit.value - totalTimeElapsed.value).clamp(
            0,
            totalTimeLimit.value,
          )
        : totalTimeElapsed.value;

    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get questionTimerFormatted {
    return '0:${questionTimer.value.toString().padLeft(2, '0')}';
  }

  // Get timer progress for border animation (1.0 = full, 0.0 = empty)
  double get questionTimerProgress {
    if (questionTimeLimit == 0) return 1.0;
    return questionTimer.value.toDouble() / questionTimeLimit.toDouble();
  }

  // Get total time progress (1.0 = full, 0.0 = empty)
  double get totalTimeProgress {
    if (totalTimeLimit.value == 0) return 1.0;
    return (totalTimeLimit.value - totalTimeElapsed.value).toDouble() /
        totalTimeLimit.value.toDouble();
  }
}
