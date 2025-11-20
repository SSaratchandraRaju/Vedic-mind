import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../data/models/vedic_course_models.dart';
import '../data/models/interactive_step_model.dart';
import '../data/models/sutra_simple_model.dart';
import '../data/models/sutra_progress_model.dart';
import '../services/tts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Enhanced Vedic Course Controller with TTS and Gamification
/// Manages course progress, interactive learning, and achievements
class EnhancedVedicCourseController extends GetxController {
  final TtsService _ttsService = Get.find<TtsService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable state
  final Rx<VedicCourse?> currentCourse = Rx<VedicCourse?>(null);
  final Rx<Chapter?> currentChapter = Rx<Chapter?>(null);
  final Rx<Lesson?> currentLesson = Rx<Lesson?>(null);
  final Rx<InteractiveStep?> currentStep = Rx<InteractiveStep?>(null);
  
  // Progress tracking
  final RxInt currentStepIndex = 0.obs;
  final RxList<InteractiveStep> lessonSteps = <InteractiveStep>[].obs;
  final RxBool isStepCompleted = false.obs;
  final RxDouble lessonProgress = 0.0.obs;
  
  // 16 Sutras Data
  final allSutras = <SutraSimpleModel>[].obs;
  final isLoading = false.obs;
  
  // Gamification
  final RxInt totalXP = 0.obs;
  final RxInt currentLevel = 1.obs;
  final RxInt streak = 0.obs;
  final RxList<Badge> earnedBadges = <Badge>[].obs;
  final RxList<Badge> availableBadges = <Badge>[].obs;
  final RxList<Challenge> activeChallenges = <Challenge>[].obs;
  
  // TTS Control
  final RxBool isTTSEnabled = true.obs;
  final RxBool isAutoPlayEnabled = false.obs;
  final RxBool isStepTTSPlaying = false.obs;
  
  // User progress
  final RxMap<int, bool> completedLessons = <int, bool>{}.obs;
  final RxMap<int, int> lessonScores = <int, int>{}.obs;
  final RxInt totalProblemsAttempted = 0.obs;
  final RxInt totalProblemsCorrect = 0.obs;
  
  // Sutra-specific progress tracking
  final RxMap<int, SutraProgress> sutraProgress = <int, SutraProgress>{}.obs;
  
  String? userId;
  
  @override
  void onInit() {
    super.onInit();
    _initializeCourse();
    _loadUserProgress();
    _initializeBadges();
    loadSutrasFromJson();
  }
  
  @override
  void onClose() {
    stopStepTTS();
    super.onClose();
  }
  
  /// Initialize course data
  Future<void> _initializeCourse() async {
    try {
      // Load course from data source
      update();
    } catch (e) {
      print('Error initializing course: $e');
    }
  }
  
  /// Load user progress from Firestore
  Future<void> _loadUserProgress() async {
    if (userId == null) return;
    
    try {
      final doc = await _firestore
          .collection('user_progress')
          .doc(userId)
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        completedLessons.value = Map<int, bool>.from(data['completed_lessons'] ?? {});
        lessonScores.value = Map<int, int>.from(data['lesson_scores'] ?? {});
        totalProblemsAttempted.value = data['total_problems_attempted'] ?? 0;
        totalProblemsCorrect.value = data['total_problems_correct'] ?? 0;
        totalXP.value = data['total_xp'] ?? 0;
        currentLevel.value = data['current_level'] ?? 1;
        streak.value = data['streak'] ?? 0;
        
        if (data['earned_badges'] != null) {
          List<String> badgeIds = List<String>.from(data['earned_badges']);
          _loadEarnedBadges(badgeIds);
        }
      }
    } catch (e) {
      print('Error loading user progress: $e');
    }
  }
  
  /// Save user progress to Firestore
  Future<void> _saveUserProgress() async {
    if (userId == null) return;
    
    try {
      await _firestore.collection('user_progress').doc(userId).set({
        'completed_lessons': Map<String, dynamic>.from(completedLessons),
        'lesson_scores': Map<String, dynamic>.from(lessonScores),
        'total_problems_attempted': totalProblemsAttempted.value,
        'total_problems_correct': totalProblemsCorrect.value,
        'total_xp': totalXP.value,
        'current_level': currentLevel.value,
        'streak': streak.value,
        'earned_badges': earnedBadges.map((b) => b.id).toList(),
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user progress: $e');
    }
  }
  
  /// Start a lesson with interactive steps
  Future<void> startLesson(Lesson lesson, List<InteractiveStep> steps) async {
    currentLesson.value = lesson;
    lessonSteps.value = steps;
    currentStepIndex.value = 0;
    lessonProgress.value = 0.0;
    
    if (steps.isNotEmpty) {
      currentStep.value = steps[0];
      
      if (isAutoPlayEnabled.value && isTTSEnabled.value) {
        await playStepTTS();
      }
    }
  }
  
  /// Navigate to next step
  Future<void> nextStep() async {
    if (currentStep.value != null) {
      currentStep.value!.complete();
    }
    
    stopStepTTS();
    
    if (currentStepIndex.value < lessonSteps.length - 1) {
      currentStepIndex.value++;
      currentStep.value = lessonSteps[currentStepIndex.value];
      _updateLessonProgress();
      
      if (isAutoPlayEnabled.value && isTTSEnabled.value) {
        await playStepTTS();
      }
    } else {
      await _completeLesson();
    }
  }
  
  /// Navigate to previous step
  void previousStep() {
    stopStepTTS();
    
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
      currentStep.value = lessonSteps[currentStepIndex.value];
      _updateLessonProgress();
    }
  }
  
  /// Play TTS for current step
  Future<void> playStepTTS() async {
    if (currentStep.value == null || !isTTSEnabled.value) return;
    
    final textToRead = currentStep.value!.textForTTS;
    isStepTTSPlaying.value = true;
    
    await _ttsService.speak(textToRead);
  }
  
  /// Stop TTS playback
  void stopStepTTS() {
    _ttsService.stop();
    isStepTTSPlaying.value = false;
  }
  
  /// Toggle TTS on/off
  void toggleTTS() {
    isTTSEnabled.value = !isTTSEnabled.value;
    if (!isTTSEnabled.value) {
      stopStepTTS();
    }
  }
  
  /// Toggle auto-play
  void toggleAutoPlay() {
    isAutoPlayEnabled.value = !isAutoPlayEnabled.value;
  }
  
  /// Reveal an interactive step
  void revealStep() {
    if (currentStep.value != null) {
      currentStep.value!.reveal();
      currentStep.refresh();
    }
  }
  
  /// Update lesson progress
  void _updateLessonProgress() {
    if (lessonSteps.isEmpty) return;
    
    final completedSteps = lessonSteps.where((s) => s.isCompleted).length;
    lessonProgress.value = completedSteps / lessonSteps.length;
  }
  
  /// Complete current lesson
  Future<void> _completeLesson() async {
    if (currentLesson.value == null) return;
    
    final lessonId = currentLesson.value!.lessonId;
    completedLessons[lessonId] = true;
    
    final xpEarned = _calculateLessonXP();
    await awardXP(xpEarned);
    await _checkBadgeEligibility();
    await _saveUserProgress();
    
    Get.snackbar(
      '🎉 Lesson Complete!',
      'You earned $xpEarned XP!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Calculate XP earned for lesson
  int _calculateLessonXP() {
    int baseXP = 50;
    
    if (lessonProgress.value == 1.0) {
      baseXP += 25;
    }
    
    if (streak.value >= 7) {
      baseXP += 10;
    }
    
    return baseXP;
  }
  
  /// Award XP and check for level up
  Future<void> awardXP(int xp) async {
    totalXP.value += xp;
    
    final newLevel = (totalXP.value / 500).floor() + 1;
    if (newLevel > currentLevel.value) {
      currentLevel.value = newLevel;
      _showLevelUpDialog();
    }
  }
  
  /// Show level up dialog
  void _showLevelUpDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('🎊 Level Up!'),
        content: Text('You reached Level ${currentLevel.value}!'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
  
  /// Submit answer to practice question
  Future<void> submitAnswer(PracticeQuestion question, String answer) async {
    question.checkAnswer(answer);
    totalProblemsAttempted.value++;
    
    if (question.isCorrect == true) {
      totalProblemsCorrect.value++;
      await awardXP(10);
      
      Get.snackbar(
        '✅ Correct!',
        'Great job!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      );
    } else {
      Get.snackbar(
        '❌ Incorrect',
        'Try again! Hint: ${question.hint ?? "Review the lesson"}',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
      );
    }
  }
  
  /// Initialize badges
  void _initializeBadges() {
    availableBadges.value = [
      Badge(
        id: 'first_lesson',
        title: 'First Steps',
        description: 'Complete your first lesson',
        iconName: 'star',
        category: BadgeCategory.completion,
        tier: BadgeTier.bronze,
        requirement: 1,
        xpReward: 50,
      ),
      Badge(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Complete 10 problems in 60 seconds',
        iconName: 'flash',
        category: BadgeCategory.speed,
        tier: BadgeTier.silver,
        requirement: 10,
        xpReward: 100,
      ),
      Badge(
        id: '50_problems',
        title: 'Practice Makes Perfect',
        description: 'Solve 50 problems',
        iconName: 'trending_up',
        category: BadgeCategory.practice,
        tier: BadgeTier.bronze,
        requirement: 50,
        xpReward: 75,
      ),
      Badge(
        id: 'week_streak',
        title: 'Dedicated Learner',
        description: 'Practice 7 days in a row',
        iconName: 'calendar',
        category: BadgeCategory.streak,
        tier: BadgeTier.silver,
        requirement: 7,
        xpReward: 150,
      ),
      Badge(
        id: 'perfect_accuracy',
        title: 'Perfectionist',
        description: 'Get 50 problems correct in a row',
        iconName: 'verified',
        category: BadgeCategory.accuracy,
        tier: BadgeTier.gold,
        requirement: 50,
        xpReward: 250,
      ),
    ];
  }
  
  /// Load earned badges
  void _loadEarnedBadges(List<String> badgeIds) {
    earnedBadges.value = availableBadges
        .where((badge) => badgeIds.contains(badge.id))
        .map((badge) {
          badge.isEarned = true;
          return badge;
        })
        .toList();
  }
  
  /// Check if user is eligible for any badges
  Future<void> _checkBadgeEligibility() async {
    for (var badge in availableBadges) {
      if (badge.isEarned) continue;
      
      bool eligible = false;
      
      switch (badge.id) {
        case 'first_lesson':
          eligible = completedLessons.length >= 1;
          break;
        case '50_problems':
          eligible = totalProblemsAttempted.value >= 50;
          break;
        case 'week_streak':
          eligible = streak.value >= 7;
          break;
      }
      
      if (eligible) {
        await _awardBadge(badge);
      }
    }
  }
  
  /// Award a badge to the user
  Future<void> _awardBadge(Badge badge) async {
    badge.isEarned = true;
    badge.earnedAt = DateTime.now();
    earnedBadges.add(badge);
    
    await awardXP(badge.xpReward);
    
    Get.dialog(
      AlertDialog(
        title: const Text('🏆 Badge Earned!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 64, color: _getBadgeColor(badge.tier)),
            const SizedBox(height: 16),
            Text(
              badge.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(badge.description),
            const SizedBox(height: 8),
            Text('+${badge.xpReward} XP', style: const TextStyle(color: Colors.green)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
  
  /// Get badge color based on tier
  Color _getBadgeColor(BadgeTier tier) {
    switch (tier) {
      case BadgeTier.bronze:
        return const Color(0xFFCD7F32);
      case BadgeTier.silver:
        return const Color(0xFFC0C0C0);
      case BadgeTier.gold:
        return const Color(0xFFFFD700);
      case BadgeTier.platinum:
        return const Color(0xFFE5E4E2);
      case BadgeTier.diamond:
        return const Color(0xFFB9F2FF);
    }
  }
  
  /// Get accuracy percentage
  double get accuracyPercentage {
    if (totalProblemsAttempted.value == 0) return 0;
    return (totalProblemsCorrect.value / totalProblemsAttempted.value) * 100;
  }
  
  /// Get current level progress
  double get levelProgress {
    final xpInCurrentLevel = totalXP.value % 500;
    return xpInCurrentLevel / 500;
  }
  
  /// Load all sutras from JSON file
  Future<void> loadSutrasFromJson() async {
    isLoading.value = true;
    try {
      final String response = await rootBundle.loadString('assets/data/16_SUTRAS_COMPLETE.json');
      final Map<String, dynamic> data = jsonDecode(response);
      final List<dynamic> sutrasJson = data['sutras'];
      
      allSutras.value = sutrasJson
          .map((json) => SutraSimpleModel.fromJson(json))
          .toList();
      
      // Initialize progress for all sutras
      _initializeSutraProgress();
      
      print('✅ Loaded ${allSutras.length} sutras successfully');
    } catch (e) {
      print('❌ Error loading sutras: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Initialize progress for all sutras
  void _initializeSutraProgress() {
    for (var sutra in allSutras) {
      if (!sutraProgress.containsKey(sutra.sutraId)) {
        sutraProgress[sutra.sutraId] = SutraProgress(sutraId: sutra.sutraId);
      }
    }
  }
  
  /// Update sutra progress when practice is completed
  void updateSutraProgress({
    required int sutraId,
    required bool isCorrect,
    bool usedHint = false,
  }) {
    final current = sutraProgress[sutraId] ?? SutraProgress(sutraId: sutraId);
    
    final updated = current.copyWith(
      totalAttempts: current.totalAttempts + 1,
      correctAnswers: isCorrect ? current.correctAnswers + 1 : current.correctAnswers,
      wrongAnswers: !isCorrect ? current.wrongAnswers + 1 : current.wrongAnswers,
      hintsUsed: usedHint ? current.hintsUsed + 1 : current.hintsUsed,
      lastAttemptDate: DateTime.now(),
    );
    
    sutraProgress[sutraId] = updated;
    
    // Update global stats
    totalProblemsAttempted.value++;
    if (isCorrect) {
      totalProblemsCorrect.value++;
    }
  }
  
  /// Mark sutra as completed
  void markSutraCompleted(int sutraId) {
    final current = sutraProgress[sutraId] ?? SutraProgress(sutraId: sutraId);
    
    sutraProgress[sutraId] = current.copyWith(
      isCompleted: true,
      completedDate: DateTime.now(),
    );
  }
  
  /// Get overall progress statistics
  Map<String, dynamic> get overallProgress {
    final completedCount = sutraProgress.values.where((p) => p.isCompleted).length;
    final totalSutras = allSutras.length;
    final completionPercentage = totalSutras > 0 
        ? (completedCount / totalSutras * 100).toInt() 
        : 0;
    
    // Calculate average accuracy across all sutras
    double avgAccuracy = 0.0;
    if (sutraProgress.isNotEmpty) {
      final totalAccuracy = sutraProgress.values
          .map((p) => p.accuracy)
          .reduce((a, b) => a + b);
      avgAccuracy = totalAccuracy / sutraProgress.length;
    }
    
    // Calculate total points earned
    final totalPoints = sutraProgress.values
        .map((p) => p.points)
        .fold(0, (sum, points) => sum + points);
    
    return {
      'completed': completedCount,
      'total': totalSutras,
      'completion_percentage': completionPercentage,
      'accuracy': avgAccuracy.toInt(),
      'total_points': totalPoints,
    };
  }
}
