import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/repositories/firestore_progress_repository.dart';
import '../services/auth_service.dart';
// Removed direct dependency on lesson controller; rely solely on Firestore aggregates.

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
  final FirestoreProgressRepository _progressRepo = FirestoreProgressRepository();
  AuthService? _authService;
  String? _userId;


  // Reactive variables for overall progress
  final RxInt totalPoints = 0.obs;
  final RxDouble overallAccuracy = 0.0.obs;
  final RxInt totalQuestionsAttempted = 0.obs;
  final RxInt totalCorrectAnswers = 0.obs;
  // Firestore-driven sutra aggregate reactive fields
  final RxInt sutrasCompleted = 0.obs;
  final RxInt sutrasAccuracy = 0.obs;
  final RxInt sutrasPoints = 0.obs;

  // Loading state for initial aggregate
  final RxBool isProgressLoaded = false.obs;

  // History tracking
  final RxList<ProgressHistoryEntry> progressHistory =
      <ProgressHistoryEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      _authService = Get.find<AuthService>();
    } catch (_) {}
    if (_authService != null) {
      final user = await _authService!.getCurrentUser();
      _userId = user?.id;
      // Seed leaderboard doc if missing
      if (_userId != null) {
        final firestore = FirebaseFirestore.instance;
        final lbDoc = await firestore.collection('user_progress').doc(_userId).get();
        if (!lbDoc.exists) {
          await firestore.collection('user_progress').doc(_userId).set({
            'userId': _userId,
            'display_name': user?.displayName ?? _userId,
            'total_xp': 0,
            'current_level': 1,
            'total_problems_attempted': 0,
            'total_problems_correct': 0,
            'streak': 0,
            'math_tables': {
              'completed_sections': [],
              'total_questions': 0,
              'correct_answers': 0,
              'points': 0,
            },
            'practice_totals': {
              'total_questions': 0,
              'correct_answers': 0,
              'total_points': 0,
            },
            'sutra_stats': {
              'completed': 0,
              'total_points': 0,
              'accuracy': 0,
            },
            'tactics_stats': {
              'completed': 0,
              'total_points': 0,
              'accuracy': 0,
            },
            'earned_badges': [],
            'last_updated': FieldValue.serverTimestamp(),
          });
        }
      }
    }
    _subscribeHistory();
    _subscribeAggregate();
  }

  void _subscribeHistory() {
    if (_userId == null) return;
    _progressRepo.watchHistory(_userId!, limit: 200).listen((list) {
      progressHistory.assignAll(list.map((data) => ProgressHistoryEntry.fromJson({
            'section': data['section'],
            'points': data['points'],
            'description': data['description'],
            'timestamp': (data['timestamp'] is Timestamp)
                ? (data['timestamp'] as Timestamp).toDate().toIso8601String()
                : DateTime.now().toIso8601String(),
            'type': data['type'],
          })).toList());
    }, onError: (err) {
      // Failed-precondition (missing composite index) or offline; skip history until resolved.
      if (err.toString().contains('failed-precondition')) {
        print('History stream requires Firestore composite index. Visit console to create index. Suppressing crash.');
        // Fallback to unordered stream avoiding index.
        _progressRepo.watchHistoryNoOrder(_userId!, limit: 200).listen((list) {
          list.sort((a, b) {
            final ta = a['timestamp'];
            final tb = b['timestamp'];
            DateTime da;
            DateTime db;
            if (ta is Timestamp) {
              da = ta.toDate();
            } else if (ta is DateTime) {
              da = ta;
            } else {
              da = DateTime.fromMillisecondsSinceEpoch(0);
            }
            if (tb is Timestamp) {
              db = tb.toDate();
            } else if (tb is DateTime) {
              db = tb;
            } else {
              db = DateTime.fromMillisecondsSinceEpoch(0);
            }
            return db.compareTo(da); // descending
          });
          progressHistory.assignAll(list.map((data) => ProgressHistoryEntry.fromJson({
                'section': data['section'],
                'points': data['points'],
                'description': data['description'],
                'timestamp': (data['timestamp'] is Timestamp)
                    ? (data['timestamp'] as Timestamp).toDate().toIso8601String()
                    : DateTime.now().toIso8601String(),
                'type': data['type'],
              })).toList());
        });
      } else if (err.toString().contains('unavailable')) {
        print('History stream unavailable (offline). Will retry automatically when connection restores.');
      } else {
        print('History stream error: $err');
      }
    });
  }

  void _subscribeAggregate() {
    if (_userId == null) return;
    _progressRepo.watchAggregate(_userId!).listen((agg) {
      calculateOverallProgress(aggregate: agg);
      if (!isProgressLoaded.value) {
        isProgressLoaded.value = true; // mark loaded after first snapshot
      }
    });
  }

  // Add a new history entry
  void addHistoryEntry({
    required String section,
    required int points,
    required String description,
    required String type,
  }) {
    if (_userId == null) return; // Require auth
    // Write only to Firestore; rely on stream for UI update (removes local-only fallback)
    _progressRepo.addHistoryEntry(
      userId: _userId!,
      section: section,
      points: points,
      description: description,
      type: type,
    );
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

  void calculateOverallProgress({UserProgressAggregate? aggregate, double? overrideOverallAccuracy}) {
    if (aggregate == null) return; // Require Firestore data only
    sutrasPoints.value = aggregate.sutrasTotalPoints;
    sutrasAccuracy.value = aggregate.sutrasAccuracy;
    sutrasCompleted.value = aggregate.sutrasCompleted;

    totalPoints.value = aggregate.mathTablesPoints + aggregate.sutrasTotalPoints + aggregate.practiceTotalPoints + aggregate.tacticsTotalPoints;
    totalQuestionsAttempted.value = aggregate.mathTablesTotalQuestions + aggregate.practiceTotalQuestions;
    totalCorrectAnswers.value = aggregate.mathTablesCorrectAnswers + aggregate.practiceCorrectAnswers;

    if (overrideOverallAccuracy != null) {
      overallAccuracy.value = overrideOverallAccuracy;
    } else {
      // New rule: overall accuracy derived from total correct answers divided by total attempted questions.
      if (totalQuestionsAttempted.value == 0) {
        overallAccuracy.value = 0;
      } else {
        overallAccuracy.value = ((totalCorrectAnswers.value / totalQuestionsAttempted.value) * 100).clamp(0, 100);
      }
    }
  }

  // Call this method whenever any section updates its progress
  void refreshProgress() {
    // No-op: progress reacts to Firestore stream only now.
  }

  // Breakdown by section for detailed view
  Map<String, dynamic> getProgressBreakdown() {
    return {
      'total_points': totalPoints.value,
      'overall_accuracy': overallAccuracy.value,
      'total_questions': totalQuestionsAttempted.value,
      'total_correct': totalCorrectAnswers.value,
    };
  }

  /// Fetch a complete stats snapshot from Firestore only (no local persistence).
  /// Returns null if user not authenticated yet.
  Future<FullUserStats?> loadFullStats({int practiceSessionsLimit = 200, int historyLimit = 200}) async {
    if (_userId == null) return null;
    try {
      return await _progressRepo.fetchFullUserStats(
        userId: _userId!,
        practiceSessionsLimit: practiceSessionsLimit,
        historyLimit: historyLimit,
      );
    } catch (e) {
      print('Failed to load full stats: $e');
      return null;
    }
  }
}
