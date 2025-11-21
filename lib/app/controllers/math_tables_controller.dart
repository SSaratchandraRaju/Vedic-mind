import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';
import 'global_progress_controller.dart';

class MathTablesController extends GetxController {
  final selectedOperation = 2.obs; // Default to × (multiplication) - fixed
  final selectedSection = 0.obs;
  final selectedNumber = 1.obs;
  final currentNavIndex = 1.obs;
  final RxSet<int> completedSections =
      <int>{}.obs; // Track completed section indices
  final storage = GetStorage();

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
    _loadProgress();
    _autoSelectSection();
  }

  void _loadProgress() {
    // Load completed sections from storage
    final saved = storage.read<List>('completed_math_sections');
    if (saved != null) {
      completedSections.clear();
      completedSections.addAll(saved.cast<int>());
    }

    // Load progress statistics
    totalQuestionsAttempted.value =
        storage.read<int>('math_tables_total_questions') ?? 0;
    totalCorrectAnswers.value =
        storage.read<int>('math_tables_correct_answers') ?? 0;
    totalPoints.value = storage.read<int>('math_tables_points') ?? 0;
  }

  void _autoSelectSection() {
    // Auto-select the last completed section, or first section if none completed
    if (completedSections.isNotEmpty) {
      // Find the highest completed section
      final lastCompleted = completedSections.reduce((a, b) => a > b ? a : b);
      // Select it (or the next one if it's not the last section)
      final sectionToSelect =
          lastCompleted < totalSections - 1 ? lastCompleted + 1 : lastCompleted;
      selectedSection.value = sectionToSelect;
      selectedNumber.value = sectionToSelect * 5 + 1;
    } else {
      // No sections completed, select first
      selectedSection.value = 0;
      selectedNumber.value = 1;
    }
  }

  void _saveProgress() {
    storage.write('completed_math_sections', completedSections.toList());
    storage.write('math_tables_total_questions', totalQuestionsAttempted.value);
    storage.write('math_tables_correct_answers', totalCorrectAnswers.value);
    storage.write('math_tables_points', totalPoints.value);
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
