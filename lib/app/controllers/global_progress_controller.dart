import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'enhanced_vedic_course_controller.dart';
import 'vedic_course_controller.dart';

// History entry model
class ProgressHistoryEntry {
  final String section; // 'Math Tables', 'Vedic Sutras', 'Tactics', 'Practice'
  final int points;
  final String description;
  final DateTime timestamp;
  final String type; // 'test', 'lesson', 'practice', 'sutra'

  ProgressHistoryEntry({
    required this.section,
    required this.points,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'section': section,
        'points': points,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
        'type': type,
      };

  factory ProgressHistoryEntry.fromJson(Map<String, dynamic> json) =>
      ProgressHistoryEntry(
        section: json['section'],
        points: json['points'],
        description: json['description'],
        timestamp: DateTime.parse(json['timestamp']),
        type: json['type'],
      );
}

class GlobalProgressController extends GetxController {
  final storage = GetStorage();

  // Reactive variables for overall progress
  final RxInt totalPoints = 0.obs;
  final RxDouble overallAccuracy = 0.0.obs;
  final RxInt totalQuestionsAttempted = 0.obs;
  final RxInt totalCorrectAnswers = 0.obs;

  // History tracking
  final RxList<ProgressHistoryEntry> progressHistory =
      <ProgressHistoryEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
    calculateOverallProgress();
  }

  void _loadHistory() {
    final savedHistory = storage.read<List>('progress_history');
    if (savedHistory != null) {
      progressHistory.clear();
      progressHistory.addAll(
        savedHistory
            .map((json) => ProgressHistoryEntry.fromJson(
                  Map<String, dynamic>.from(json),
                ))
            .toList(),
      );
    }
  }

  void _saveHistory() {
    storage.write(
      'progress_history',
      progressHistory.map((e) => e.toJson()).toList(),
    );
  }

  // Add a new history entry
  void addHistoryEntry({
    required String section,
    required int points,
    required String description,
    required String type,
  }) {
    final entry = ProgressHistoryEntry(
      section: section,
      points: points,
      description: description,
      timestamp: DateTime.now(),
      type: type,
    );

    progressHistory.insert(0, entry); // Add to beginning (most recent first)
    _saveHistory();
    calculateOverallProgress(); // Refresh stats
  }

  // Get history filtered by section
  List<ProgressHistoryEntry> getHistoryBySection(String section) {
    return progressHistory.where((e) => e.section == section).toList();
  }

  // Get history for today
  List<ProgressHistoryEntry> getTodayHistory() {
    final today = DateTime.now();
    return progressHistory.where((e) {
      return e.timestamp.year == today.year &&
          e.timestamp.month == today.month &&
          e.timestamp.day == today.day;
    }).toList();
  }

  void calculateOverallProgress() {
    int totalPointsSum = 0;
    int totalQuestions = 0;
    int totalCorrect = 0;

    // 1. Math Tables Progress
    final mathTablesPoints = storage.read<int>('math_tables_points') ?? 0;
    final mathTablesQuestions =
        storage.read<int>('math_tables_total_questions') ?? 0;
    final mathTablesCorrect =
        storage.read<int>('math_tables_correct_answers') ?? 0;

    totalPointsSum += mathTablesPoints;
    totalQuestions += mathTablesQuestions;
    totalCorrect += mathTablesCorrect;

    print('Math Tables: Points=$mathTablesPoints, Q=$mathTablesQuestions, Correct=$mathTablesCorrect');

    // 2. Vedic Sutras Progress (16 Sutras)
    try {
      final sutrasController = Get.find<EnhancedVedicCourseController>();
      final sutrasProgress = sutrasController.overallProgress;
      final sutrasPoints = sutrasProgress['total_points'] as int? ?? 0;
      final sutrasAccuracy = sutrasProgress['accuracy'] as int? ?? 0;
      final sutrasCompleted = sutrasProgress['completed'] as int? ?? 0;

      totalPointsSum += sutrasPoints;
      // Estimate questions from sutras (each sutra has ~10 practice questions)
      final estimatedSutrasQuestions = sutrasCompleted * 10;
      totalQuestions += estimatedSutrasQuestions;
      totalCorrect +=
          ((estimatedSutrasQuestions * sutrasAccuracy) / 100).round();

      print('Vedic Sutras: Points=$sutrasPoints, Completed=$sutrasCompleted, Accuracy=$sutrasAccuracy%');
    } catch (e) {
      // Controller not initialized yet
      print('Vedic Sutras Controller not found: $e');
    }

    // 3. Vedic Tactics/Lessons Progress
    try {
      final tacticsController = Get.find<VedicCourseController>();
      final allLessons = tacticsController.getAllLessons();

      int tacticsPoints = 0;
      int tacticsQuestions = 0;
      int tacticsCorrect = 0;

      for (var item in allLessons) {
        final lesson = item['lesson'];
        if (lesson.isCompleted) {
          tacticsPoints += 100; // 100 points per completed lesson
        }
        if (lesson.score > 0) {
          tacticsQuestions += 1;
          tacticsCorrect += (lesson.score as num).toInt();
        }
      }

      totalPointsSum += tacticsPoints;
      totalQuestions += tacticsQuestions;
      totalCorrect += tacticsCorrect;

      print('Vedic Tactics: Points=$tacticsPoints, Q=$tacticsQuestions, Correct=$tacticsCorrect');
    } catch (e) {
      // Controller not initialized yet
      print('Vedic Tactics Controller not found: $e');
    }

    // 4. Practice Progress (if stored separately)
    final practicePoints = storage.read<int>('practice_total_points') ?? 0;
    final practiceQuestions =
        storage.read<int>('practice_total_questions') ?? 0;
    final practiceCorrect =
        storage.read<int>('practice_correct_answers') ?? 0;

    totalPointsSum += practicePoints;
    totalQuestions += practiceQuestions;
    totalCorrect += practiceCorrect;

    print('Practice: Points=$practicePoints, Q=$practiceQuestions, Correct=$practiceCorrect');

    // Update reactive variables
    totalPoints.value = totalPointsSum;
    totalQuestionsAttempted.value = totalQuestions;
    totalCorrectAnswers.value = totalCorrect;

    // Calculate overall accuracy
    if (totalQuestions > 0) {
      overallAccuracy.value = (totalCorrect / totalQuestions) * 100;
    } else {
      overallAccuracy.value = 0.0;
    }

    print('TOTAL: Points=$totalPointsSum, Q=$totalQuestions, Correct=$totalCorrect, Accuracy=${overallAccuracy.value.toStringAsFixed(1)}%');
  }

  // Call this method whenever any section updates its progress
  void refreshProgress() {
    calculateOverallProgress();
  }

  // Breakdown by section for detailed view
  Map<String, dynamic> getProgressBreakdown() {
    return {
      'math_tables': {
        'points': storage.read<int>('math_tables_points') ?? 0,
        'questions': storage.read<int>('math_tables_total_questions') ?? 0,
        'correct': storage.read<int>('math_tables_correct_answers') ?? 0,
      },
      'practice': {
        'points': storage.read<int>('practice_total_points') ?? 0,
        'questions': storage.read<int>('practice_total_questions') ?? 0,
        'correct': storage.read<int>('practice_correct_answers') ?? 0,
      },
      'total_points': totalPoints.value,
      'overall_accuracy': overallAccuracy.value,
      'total_questions': totalQuestionsAttempted.value,
      'total_correct': totalCorrectAnswers.value,
    };
  }
}
