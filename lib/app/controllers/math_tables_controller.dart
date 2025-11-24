import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'global_progress_controller.dart';
import '../data/repositories/firestore_progress_repository.dart';
import '../services/auth_service.dart';

class MathTablesController extends GetxController {
  final selectedOperation = 2.obs; // Default to × (multiplication) - fixed
  final selectedSection = 0.obs;
  final selectedNumber = 1.obs;
  final currentNavIndex = 1.obs;
  final RxSet<int> completedSections =
      <int>{}.obs; // Track completed section indices
  final FirestoreProgressRepository _progressRepo = FirestoreProgressRepository();
  AuthService? _authService;
  String? _userId;
  bool _autoSelectedApplied = false;

  // Progress tracking
  final RxInt totalQuestionsAttempted = 0.obs;
  final RxInt totalCorrectAnswers = 0.obs;
  final RxInt totalPoints = 0.obs;

  static const int totalSections = 20; // Sections from 1-5 to 96-100

  // Computed accuracy
  double get accuracy {
    if (totalQuestionsAttempted.value == 0) return 0.0;
    return (totalCorrectAnswers.value / totalQuestionsAttempted.value) * 100;
  }

  @override
  void onInit() {
    super.onInit();
    _initAuthAndLoad();
    _autoSelectSection();
  }

  Future<void> _initAuthAndLoad() async {
    try {
      _authService = Get.find<AuthService>();
      final user = await _authService!.getCurrentUser();
      _userId = user?.id;
    } catch (_) {}
    if (_userId != null) {
      // Listen to aggregate updates for math tables portion
      _progressRepo.watchAggregate(_userId!).listen((agg) {
        totalQuestionsAttempted.value = agg.mathTablesTotalQuestions;
        totalCorrectAnswers.value = agg.mathTablesCorrectAnswers;
        totalPoints.value = agg.mathTablesPoints;
        completedSections.clear();
        completedSections.addAll(agg.completedMathSections);
        // After first aggregate load, auto-select first unlocked section if not already applied
        if (!_autoSelectedApplied) {
          _autoSelectSection();
          _autoSelectedApplied = true;
        }
      });
    }
  }

  void _autoSelectSection() {
    final idx = getFirstUnlockedNotCompletedSectionIndex();
    selectedSection.value = idx;
    selectedNumber.value = idx * 5 + 1;
  }

  int getFirstUnlockedNotCompletedSectionIndex() {
    // Find the first section that is unlocked and not yet completed
    for (int i = 0; i < totalSections; i++) {
      if (isSectionUnlocked(i) && !isSectionCompleted(i)) {
        return i;
      }
    }
    // If all unlocked are completed (e.g., user finished everything), select highest completed
    if (completedSections.isNotEmpty) {
      return completedSections.reduce((a, b) => a > b ? a : b);
    }
    // Fallback to first section
    return 0;
  }

  void _saveProgress() {
    if (_userId != null) {
      _progressRepo.saveMathTablesProgress(
        userId: _userId!,
        completedSections: completedSections.toList(),
        totalQuestions: totalQuestionsAttempted.value,
        correctAnswers: totalCorrectAnswers.value,
        points: totalPoints.value,
      );
    }
  }

  bool isSectionUnlocked(int sectionIndex) {
    // First section is always unlocked
    if (sectionIndex == 0) return true;
    // Other sections are unlocked if previous section is completed
    return completedSections.contains(sectionIndex - 1);
  }

  bool isSectionCompleted(int sectionIndex) {
    return completedSections.contains(sectionIndex);
  }

  void markSectionCompleted(int sectionIndex) {
    if (!completedSections.contains(sectionIndex)) {
      completedSections.add(sectionIndex);
      _saveProgress();
    }
  }

  void updateProgress({
    required int questionsAttempted,
    required int correctAnswers,
    required int points,
  }) {
    totalQuestionsAttempted.value += questionsAttempted;
    totalCorrectAnswers.value += correctAnswers;
    totalPoints.value += points;
    _saveProgress();

    // Add history entry
    try {
      final globalProgress = Get.find<GlobalProgressController>();
      globalProgress.addHistoryEntry(
        section: 'Math Tables',
        points: points,
        description:
            'Completed test: $correctAnswers/$questionsAttempted correct',
        type: 'test',
      );
    } catch (e) {
      print('Could not add history entry: $e');
    }
  }

  void selectOperation(int index) {
    selectedOperation.value = index;
  }

  void selectSection(int index) {
    // Only allow selecting unlocked sections
    if (isSectionUnlocked(index)) {
      selectedSection.value = index;
      // Auto select first number of section
      selectedNumber.value = index * 5 + 1;
    }
  }

  void selectNumber(int number) {
    selectedNumber.value = number;
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
