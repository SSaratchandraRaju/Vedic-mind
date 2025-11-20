import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Sample GetX Controller for Sutra 3: Ūrdhva-Tiryagbhyām (Vertically and Crosswise)
/// Demonstrates how interactive lessons integrate with TTS, animations, gamification
///
/// This is a REFERENCE IMPLEMENTATION - replicate pattern for all 16 sutras
class Sutra03Controller extends GetxController {
  // ===========================
  // DEPENDENCIES
  // ===========================
  final FlutterTts _tts = FlutterTts();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // ===========================
  // STATE VARIABLES (Reactive)
  // ===========================
  
  // Lesson Progress
  final currentStepIndex = 0.obs;
  final totalSteps = 6.obs; // 6 interactive steps in the example
  final isStepCompleted = <int, bool>{}.obs; // Track which steps are done
  final isLessonComplete = false.obs;
  
  // Interactive Example Data (from JSON)
  final exampleProblem = "23 × 14".obs;
  final currentInstruction = "".obs;
  final currentAnimation = "".obs;
  
  // User Input & Validation
  final userAnswer = "".obs;
  final isAnswerCorrect = false.obs;
  final showHint = false.obs;
  final currentHint = "".obs;
  
  // Practice Problems (5 problems)
  final practiceProblems = <Map<String, dynamic>>[].obs;
  final currentPracticeIndex = 0.obs;
  final practiceScore = 0.obs;
  final practiceAttempts = <int, int>{}.obs; // problemIndex -> attempts
  
  // Mini-Game (Crosswise Matrix game)
  final gameScore = 0.obs;
  final gameLevel = 1.obs;
  final gameTimeLeft = 120.obs; // 2 minutes
  final isGameActive = false.obs;
  final comboMultiplier = 1.0.obs;
  
  // Micro-Quiz (3 questions)
  final quizAnswers = <int, String>{}.obs; // questionIndex -> selectedAnswer
  final quizScore = 0.obs;
  final isQuizComplete = false.obs;
  
  // Gamification
  final xpEarned = 0.obs;
  final totalXP = 0.obs; // User's total XP from profile
  final badgeUnlocked = false.obs;
  final streakDays = 0.obs;
  
  // TTS State
  final isTTSPlaying = false.obs;
  final ttsSpeed = 0.5.obs; // 0.0 to 1.0
  final ttsLanguage = "en-US".obs;
  
  // Animation State
  final showParticleEffect = false.obs;
  final highlightedDigit = "".obs;
  final crosswiseLinesVisible = false.obs;
  
  // UI State
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final showCelebration = false.obs;
  
  // ===========================
  // LIFECYCLE
  // ===========================
  
  @override
  void onInit() {
    super.onInit();
    _initializeTTS();
    _loadLessonData();
    _loadUserProgress();
  }
  
  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
  
  // ===========================
  // INITIALIZATION
  // ===========================
  
  Future<void> _initializeTTS() async {
    await _tts.setLanguage(ttsLanguage.value);
    await _tts.setSpeechRate(ttsSpeed.value);
    await _tts.setVolume(1.0);
    
    _tts.setStartHandler(() {
      isTTSPlaying.value = true;
    });
    
    _tts.setCompletionHandler(() {
      isTTSPlaying.value = false;
    });
    
    _tts.setErrorHandler((msg) {
      isTTSPlaying.value = false;
      errorMessage.value = "TTS Error: $msg";
    });
  }
  
  Future<void> _loadLessonData() async {
    isLoading.value = true;
    try {
      // In production: Load from 16_SUTRAS_COMPLETE.json or Firestore
      // For now, using hardcoded data from JSON structure
      
      practiceProblems.value = [
        {"problem": "12×13", "answer": "156", "hint": "2×3=6, 1×3+2×1=5, 1×1=1"},
        {"problem": "34×25", "answer": "850", "hint": "Crosswise middle digits"},
        {"problem": "123×12", "answer": "1476", "hint": "3-digit × 2-digit"},
        {"problem": "99×99", "answer": "9801", "hint": "Works beautifully!"},
        {"problem": "456×78", "answer": "35568", "hint": "Multi-crosswise"}
      ];
      
      totalSteps.value = 6;
      currentInstruction.value = "TAP to identify the two numbers to multiply";
      
    } catch (e) {
      errorMessage.value = "Failed to load lesson: $e";
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _loadUserProgress() async {
    try {
      final userId = Get.find<AuthController>().currentUserId.value; // Assuming auth controller exists
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        final data = userDoc.data()!;
        totalXP.value = data['total_xp'] ?? 0;
        streakDays.value = data['streak_days'] ?? 0;
        
        // Check if this sutra was previously completed
        final completedSutras = List<int>.from(data['completed_sutras'] ?? []);
        if (completedSutras.contains(3)) {
          isLessonComplete.value = true;
        }
      }
    } catch (e) {
      print("Error loading user progress: $e");
    }
  }
  
  // ===========================
  // INTERACTIVE LESSON ACTIONS
  // ===========================
  
  /// Move to next step in interactive example
  void nextStep() {
    if (currentStepIndex.value < totalSteps.value - 1) {
      currentStepIndex.value++;
      _updateStepContent();
      _triggerStepAnimation();
      _trackAnalytics('step_revealed', {
        'sutra_id': 3,
        'step_number': currentStepIndex.value + 1,
      });
    } else {
      // Completed all interactive steps
      _completeInteractiveExample();
    }
  }
  
  /// Go back to previous step
  void previousStep() {
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
      _updateStepContent();
    }
  }
  
  /// Update instruction and animation based on current step
  void _updateStepContent() {
    // Step content from JSON structure
    final steps = [
      {
        "instruction": "TAP to identify the two numbers to multiply",
        "animation": "number_highlight_bounce.json",
        "action": "tap_highlight"
      },
      {
        "instruction": "SWIPE to separate units and tens digits",
        "animation": "digit_separation_slide.json",
        "action": "swipe_separate"
      },
      {
        "instruction": "TAP the units digits to multiply vertically (3×4)",
        "animation": "vertical_multiply_glow.json",
        "action": "tap_multiply"
      },
      {
        "instruction": "DRAG crosswise lines to show cross-multiplication",
        "animation": "crosswise_lines_draw.json",
        "action": "drag_lines"
      },
      {
        "instruction": "TAP to calculate cross products and add (2×4 + 3×1)",
        "animation": "cross_add_cascade.json",
        "action": "tap_calculate"
      },
      {
        "instruction": "TAP tens digits to multiply vertically (2×1)",
        "animation": "final_multiply_sparkle.json",
        "action": "tap_final"
      }
    ];
    
    final stepData = steps[currentStepIndex.value];
    currentInstruction.value = stepData["instruction"] as String;
    currentAnimation.value = stepData["animation"] as String;
  }
  
  /// Trigger Lottie/SVG animation for current step
  void _triggerStepAnimation() {
    // In production: Trigger actual Lottie animation via UI
    // Animation files from assets:
    // - number_highlight_bounce.json
    // - digit_separation_slide.json
    // - vertical_multiply_glow.json
    // - crosswise_lines_draw.json
    // - cross_add_cascade.json
    // - final_multiply_sparkle.json
    
    showParticleEffect.value = true;
    
    Future.delayed(Duration(milliseconds: 300), () {
      showParticleEffect.value = false;
    });
  }
  
  /// Handle user interaction (TAP/SWIPE/DRAG/TYPE)
  void handleUserAction(String action) {
    // Validate action matches expected action for current step
    final expectedActions = [
      "tap_highlight",
      "swipe_separate", 
      "tap_multiply",
      "drag_lines",
      "tap_calculate",
      "tap_final"
    ];
    
    if (action == expectedActions[currentStepIndex.value]) {
      isStepCompleted[currentStepIndex.value] = true;
      _playSuccessSound();
      _awardXP(10); // 10 XP per step completed
      
      // Auto-advance after 1 second
      Future.delayed(Duration(seconds: 1), () {
        nextStep();
      });
    }
  }
  
  /// Complete interactive example section
  void _completeInteractiveExample() {
    showCelebration.value = true;
    _awardXP(50); // Bonus for completing all steps
    _playSuccessSound();
    
    Future.delayed(Duration(seconds: 2), () {
      showCelebration.value = false;
      // Navigate to practice problems
    });
  }
  
  // ===========================
  // PRACTICE PROBLEMS
  // ===========================
  
  /// Submit answer for current practice problem
  void submitPracticeAnswer(String answer) {
    final problem = practiceProblems[currentPracticeIndex.value];
    final correctAnswer = problem["answer"] as String;
    
    final attempts = practiceAttempts[currentPracticeIndex.value] ?? 0;
    practiceAttempts[currentPracticeIndex.value] = attempts + 1;
    
    if (answer.trim() == correctAnswer) {
      isAnswerCorrect.value = true;
      practiceScore.value++;
      
      // XP based on attempts (100 for first try, 75 for second, 50 for third+)
      final xp = attempts == 0 ? 100 : (attempts == 1 ? 75 : 50);
      _awardXP(xp);
      
      _playSuccessSound();
      
      _trackAnalytics('practice_submitted', {
        'sutra_id': 3,
        'problem_id': currentPracticeIndex.value,
        'correct': true,
        'attempts': attempts + 1,
        'time_taken': 0 // TODO: Add timer
      });
      
      // Move to next problem after 1.5 seconds
      Future.delayed(Duration(milliseconds: 1500), () {
        nextPracticeProblem();
      });
      
    } else {
      isAnswerCorrect.value = false;
      _playErrorSound();
      
      _trackAnalytics('practice_submitted', {
        'sutra_id': 3,
        'problem_id': currentPracticeIndex.value,
        'correct': false,
        'attempts': attempts + 1,
      });
      
      // Show hint after 2 failed attempts
      if (attempts >= 1) {
        showHint.value = true;
        currentHint.value = problem["hint"] as String;
      }
    }
  }
  
  void nextPracticeProblem() {
    if (currentPracticeIndex.value < practiceProblems.length - 1) {
      currentPracticeIndex.value++;
      userAnswer.value = "";
      isAnswerCorrect.value = false;
      showHint.value = false;
    } else {
      _completePracticeSection();
    }
  }
  
  void _completePracticeSection() {
    final accuracy = (practiceScore.value / practiceProblems.length * 100).round();
    
    if (accuracy >= 60) {
      _awardXP(200); // Completion bonus
      // Unlock mini-game
    }
  }
  
  // ===========================
  // MINI-GAME (Crosswise Matrix)
  // ===========================
  
  void startMiniGame() {
    isGameActive.value = true;
    gameScore.value = 0;
    gameLevel.value = 1;
    gameTimeLeft.value = 120;
    comboMultiplier.value = 1.0;
    
    _startGameTimer();
    
    _trackAnalytics('mini_game_started', {
      'sutra_id': 3,
      'game_name': 'Crosswise Matrix'
    });
  }
  
  void _startGameTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (isGameActive.value && gameTimeLeft.value > 0) {
        gameTimeLeft.value--;
        _startGameTimer();
      } else if (gameTimeLeft.value == 0) {
        _endMiniGame();
      }
    });
  }
  
  void handleGameAction(String action, Map<String, dynamic> data) {
    // Game-specific logic: drag crosswise lines, multiply digits
    // Award points based on speed and accuracy
    
    final points = (100 * comboMultiplier.value).round();
    gameScore.value += points;
    
    // Increase combo for consecutive correct answers
    comboMultiplier.value = (comboMultiplier.value + 0.1).clamp(1.0, 5.0);
  }
  
  void _endMiniGame() {
    isGameActive.value = false;
    
    final xp = gameScore.value ~/ 2; // Convert score to XP
    _awardXP(xp);
    
    _trackAnalytics('mini_game_completed', {
      'sutra_id': 3,
      'score': gameScore.value,
      'xp_earned': xp
    });
  }
  
  // ===========================
  // MICRO-QUIZ
  // ===========================
  
  void submitQuizAnswer(int questionIndex, String answer) {
    quizAnswers[questionIndex] = answer;
    
    // Check against correct answers (from JSON)
    final correctAnswers = ["B", "A", "C"]; // Example
    
    if (answer == correctAnswers[questionIndex]) {
      quizScore.value++;
      _awardXP(50);
      
      _trackAnalytics('quiz_answered', {
        'sutra_id': 3,
        'question_id': questionIndex,
        'correct': true
      });
    } else {
      _trackAnalytics('quiz_answered', {
        'sutra_id': 3,
        'question_id': questionIndex,
        'correct': false
      });
    }
    
    // If all 3 questions answered, complete quiz
    if (quizAnswers.length == 3) {
      _completeQuiz();
    }
  }
  
  void _completeQuiz() {
    isQuizComplete.value = true;
    
    if (quizScore.value >= 2) { // 2/3 to pass
      _awardXP(100); // Completion bonus
    }
  }
  
  // ===========================
  // LESSON COMPLETION
  // ===========================
  
  Future<void> completeLesson() async {
    isLessonComplete.value = true;
    badgeUnlocked.value = true;
    
    // Award badge: "Universal Multiplier" + 200 XP
    _awardXP(200);
    
    _trackAnalytics('badge_earned', {
      'badge_name': 'Universal Multiplier',
      'sutra_id': 3,
      'total_xp': totalXP.value
    });
    
    // Save to Firestore
    await _saveProgress();
    
    // Show celebration animation
    showCelebration.value = true;
    
    // Check if user can unlock Sutra 4 (needs 60s drill)
    _checkDrillUnlock();
  }
  
  void _checkDrillUnlock() {
    // Navigate to 60-second drill challenge
    // Must score 60%+ accuracy to unlock next sutra
  }
  
  Future<void> _saveProgress() async {
    try {
      final userId = Get.find<AuthController>().currentUserId.value;
      
      await _firestore.collection('users').doc(userId).update({
        'total_xp': totalXP.value,
        'completed_sutras': FieldValue.arrayUnion([3]),
        'sutra_3_completed_at': FieldValue.serverTimestamp(),
        'sutra_3_score': {
          'practice_accuracy': (practiceScore.value / practiceProblems.length * 100).round(),
          'quiz_score': quizScore.value,
          'game_score': gameScore.value,
          'total_xp_earned': xpEarned.value
        }
      });
      
    } catch (e) {
      errorMessage.value = "Failed to save progress: $e";
    }
  }
  
  // ===========================
  // TTS (Text-to-Speech)
  // ===========================
  
  Future<void> playStepTTS() async {
    if (isTTSPlaying.value) {
      await _tts.stop();
      return;
    }
    
    await _tts.speak(currentInstruction.value);
  }
  
  Future<void> playSanskritPronunciation() async {
    // Play pre-recorded MP3 for "Ūrdhva-Tiryagbhyām"
    // Asset: assets/audio/sutra_03_pronunciation.mp3
  }
  
  void adjustTTSSpeed(double speed) {
    ttsSpeed.value = speed.clamp(0.3, 1.0);
    _tts.setSpeechRate(ttsSpeed.value);
  }
  
  // ===========================
  // GAMIFICATION
  // ===========================
  
  void _awardXP(int amount) {
    xpEarned.value += amount;
    totalXP.value += amount;
    
    // Trigger particle animation
    showParticleEffect.value = true;
    Future.delayed(Duration(milliseconds: 500), () {
      showParticleEffect.value = false;
    });
  }
  
  void _playSuccessSound() {
    // Play: assets/audio/success_chime.mp3
  }
  
  void _playErrorSound() {
    // Play: assets/audio/error_buzz.mp3
  }
  
  // ===========================
  // ANALYTICS
  // ===========================
  
  void _trackAnalytics(String eventName, Map<String, dynamic> payload) {
    // Send to Firebase Analytics or custom analytics service
    // Events defined in JSON: lesson_started, step_revealed, practice_submitted, etc.
    
    _firestore.collection('analytics_events').add({
      'event_name': eventName,
      'payload': payload,
      'user_id': Get.find<AuthController>().currentUserId.value,
      'timestamp': FieldValue.serverTimestamp()
    });
  }
  
  // ===========================
  // API ENDPOINTS (Future Integration)
  // ===========================
  
  Future<void> fetchLessonFromServer() async {
    // GET /api/sutras/3
    // Returns full JSON data for Sutra 3
  }
  
  Future<void> submitDrillResult(int accuracy, int timeSeconds) async {
    // POST /api/sutras/3/drill
    // Body: {accuracy: 75, time_seconds: 58}
    // Response: {unlock_next: true, xp_awarded: 150}
  }
  
  Future<void> fetchLeaderboard() async {
    // GET /api/sutras/3/leaderboard
    // Returns top 100 users by score
  }
}

/// Helper extension for AuthController (assumed to exist)
class AuthController extends GetxController {
  final currentUserId = "user_123".obs; // Mock user ID
}
