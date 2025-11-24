import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressService {
  final FirebaseFirestore _firestore;
  ProgressService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String userId) => _firestore.collection('users').doc(userId);
  DocumentReference<Map<String, dynamic>> _leaderboardDoc(String userId) => _firestore.collection('user_progress').doc(userId);

  // Combined collections with summary doc inside
  CollectionReference<Map<String, dynamic>> _sutraStatsCol(String userId) => _userDoc(userId).collection('sutra_stats');
  CollectionReference<Map<String, dynamic>> _tacticsStatsCol(String userId) => _userDoc(userId).collection('tactics_stats');
  CollectionReference<Map<String, dynamic>> _practiceStatsCol(String userId) => _userDoc(userId).collection('practice_stats');

  DocumentReference<Map<String, dynamic>> _sutraSummary(String userId) => _sutraStatsCol(userId).doc('summary');
  DocumentReference<Map<String, dynamic>> _tacticsSummary(String userId) => _tacticsStatsCol(userId).doc('summary');
  DocumentReference<Map<String, dynamic>> _practiceSummary(String userId) => _practiceStatsCol(userId).doc('summary');

  Future<Map<int, Map<String, dynamic>>> loadAllSutraProgress(String userId) async {
    final qs = await _sutraStatsCol(userId).get();
    final map = <int, Map<String, dynamic>>{};
    for (final doc in qs.docs) {
      if (doc.id == 'summary') continue;
      final d = doc.data();
      final id = d['sutraId'] ?? int.tryParse(doc.id);
      if (id is int) map[id] = d;
    }
    return map;
  }

  Future<Map<int, Map<String, dynamic>>> loadAllLessonProgress(String userId) async {
    final qs = await _tacticsStatsCol(userId).get();
    final map = <int, Map<String, dynamic>>{};
    for (final doc in qs.docs) {
      if (doc.id == 'summary') continue;
      final d = doc.data();
      final id = d['lessonId'] ?? int.tryParse(doc.id);
      if (id is int) map[id] = d;
    }
    return map;
  }

  Future<Map<String, dynamic>> loadUserCore(String userId) async {
    final snap = await _userDoc(userId).get();
    return snap.data() ?? {};
  }

  Future<void> upsertSutra({
    required String userId,
    required int sutraId,
    required Map<String, dynamic> fields,
  }) async {
    final docRef = _sutraStatsCol(userId).doc('$sutraId');
    await docRef.set({
      'sutraId': sutraId,
      'userId': userId,
      ...fields,
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _updateSutraAggregate(userId);
  }

  Future<void> upsertLesson({
    required String userId,
    required int lessonId,
    required Map<String, dynamic> fields,
  }) async {
    if (userId.isEmpty) return; // guard
    final docRef = _tacticsStatsCol(userId).doc('$lessonId');
    await docRef.set({
      'lessonId': lessonId,
      'userId': userId,
      ...fields,
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _updateLessonAggregate(userId);
  }

  Future<void> _updateSutraAggregate(String userId) async {
    final qs = await _sutraStatsCol(userId).get();
    int completed = 0;
    int totalPoints = 0;
    double accuracySum = 0;
    int withAttempts = 0;
    for (final doc in qs.docs) {
      if (doc.id == 'summary') continue;
      final m = doc.data();
      if (m['is_completed'] == true) completed++;
      totalPoints += (m['points'] ?? 0) as int;
      final attempts = (m['total_attempts'] ?? 0) as int;
      final acc = (m['accuracy'] ?? 0).toDouble();
      if (attempts > 0) {
        accuracySum += acc;
        withAttempts++;
      }
    }
    final avgAcc = withAttempts == 0 ? 0 : (accuracySum / withAttempts).round();
    await _sutraSummary(userId).set({
      'completed': completed,
      'total_points': totalPoints,
      'accuracy': avgAcc,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _recomputeLeaderboard(userId);
  }

  Future<void> _updateLessonAggregate(String userId) async {
    if (userId.isEmpty) return; // guard
    final qs = await _tacticsStatsCol(userId).get();
    int completed = 0;
    int totalPoints = 0;
    int attemptsSum = 0;
    int correctSum = 0;
    for (final doc in qs.docs) {
      if (doc.id == 'summary') continue;
      final m = doc.data();
      // Legacy alias support
      final bool isCompleted = m['is_completed'] == true || m['completed'] == true;
      if (isCompleted) completed++;
      totalPoints += (m['points'] ?? m['total_points'] ?? 0) as int;
      attemptsSum += (m['total_attempts'] ?? m['attempts'] ?? 0) as int;
      correctSum += (m['correct_answers'] ?? m['correct'] ?? 0) as int;
    }
    final accuracy = attemptsSum == 0 ? 0 : ((correctSum / attemptsSum) * 100).round();
    await _tacticsSummary(userId).set({
      'completed': completed,
      'total_points': totalPoints,
      'accuracy': accuracy,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _recomputeLeaderboard(userId);
  }

  Future<void> _recomputeLeaderboard(String userId) async {
    final futures = await Future.wait([
      _sutraSummary(userId).get(),
      _tacticsSummary(userId).get(),
      _practiceSummary(userId).get(),
      _userDoc(userId).get(),
      _leaderboardDoc(userId).get(),
    ]);
    final sutras = futures[0].data() ?? {};
    final tactics = futures[1].data() ?? {};
    final practice = futures[2].data() ?? {};
    final root = futures[3].data() ?? {};
    final existingLb = futures[4].data() ?? {};
    final math = existingLb['math_tables'] ?? {}; // still written by other repository

    final mathQuestions = (math['total_questions'] ?? 0) as int;
    final mathCorrect = (math['correct_answers'] ?? 0) as int;
    final practiceQuestions = (practice['total_questions'] ?? 0) as int;
    final practiceCorrect = (practice['correct_answers'] ?? 0) as int;
    final mathAcc = mathQuestions == 0 ? 0 : ((mathCorrect / mathQuestions) * 100).round();
    final practiceAcc = practiceQuestions == 0 ? 0 : ((practiceCorrect / practiceQuestions) * 100).round();
    final sutraAcc = (sutras['accuracy'] ?? 0) as int;
    final tacticsAcc = (tactics['accuracy'] ?? 0) as int;
    final overallAccuracy = ((mathAcc + practiceAcc + sutraAcc + tacticsAcc) / 4).round();

    final totalPoints = (math['points'] ?? 0) + (practice['total_points'] ?? 0) + (sutras['total_points'] ?? 0) + (tactics['total_points'] ?? 0);
    final totalQuestions = mathQuestions + practiceQuestions;

    await _leaderboardDoc(userId).set({
      'userId': userId,
      // Ensure top-level display_name is always present for leaderboard UI
      'display_name': (root['user_core'] is Map && (root['user_core'] as Map)['display_name'] != null)
          ? (root['user_core'] as Map)['display_name']
          : (root['display_name'] ?? userId),
      'sutra_stats': sutras,
      'tactics_stats': tactics,
      'practice_totals': practice,
      'overall': {
        'total_points': totalPoints,
        'total_questions': totalQuestions,
        'overall_accuracy': overallAccuracy,
      },
      'total_xp': root['total_xp'] ?? 0,
      'current_level': root['current_level'] ?? 1,
      'streak': root['streak'] ?? 0,
      'earned_badges': root['earned_badges'] ?? [],
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> ensureInitialDocs({required String userId, List<int>? sutraIds, List<int>? lessonIds}) async {
    final batch = _firestore.batch();
    if (sutraIds != null) {
      for (final id in sutraIds) {
        batch.set(_sutraStatsCol(userId).doc('$id'), {
          'sutraId': id,
          'total_attempts': 0,
          'correct_answers': 0,
          'wrong_answers': 0,
          'hints_used': 0,
          'has_completed_interactive': false,
          'is_completed': false,
          'accuracy': 0,
          'points': 0,
          'userId': userId,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }
    if (lessonIds != null) {
      for (final id in lessonIds) {
        batch.set(_tacticsStatsCol(userId).doc('$id'), {
          'lessonId': id,
          'total_attempts': 0,
          'correct_answers': 0,
          'is_completed': false,
          'points': 0,
          'userId': userId,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }
    batch.set(_sutraSummary(userId), {'updated_at': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    batch.set(_tacticsSummary(userId), {'updated_at': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    batch.set(_practiceSummary(userId), {'updated_at': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await batch.commit();
    await _updateSutraAggregate(userId);
    await _updateLessonAggregate(userId);
  }

  Future<void> migrateLegacyEmbeddedMaps(String userId) async {
    final userRef = _userDoc(userId);
    final snap = await userRef.get();
    final data = snap.data() ?? {};
    final sutrasGranular = data['sutras_granular'];
    final lessonsGranular = data['lessons_granular'];
    final batch = _firestore.batch();

    if (sutrasGranular is Map) {
      sutrasGranular.forEach((key, value) {
        if (value is Map) {
          final id = int.tryParse(key) ?? value['sutraId'] ?? key;
          batch.set(_sutraStatsCol(userId).doc('$id'), {
            ...value,
            'sutraId': id is int ? id : int.tryParse(id.toString()),
            'userId': userId,
            'migrated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      });
    }
    if (lessonsGranular is Map) {
      lessonsGranular.forEach((key, value) {
        if (value is Map) {
          final id = int.tryParse(key) ?? value['lessonId'] ?? key;
          batch.set(_tacticsStatsCol(userId).doc('$id'), {
            ...value,
            'lessonId': id is int ? id : int.tryParse(id.toString()),
            'userId': userId,
            'migrated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      });
    }

    batch.set(userRef, {
      'sutras_granular': FieldValue.delete(),
      'lessons_granular': FieldValue.delete(),
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await batch.commit();
    await _updateSutraAggregate(userId);
    await _updateLessonAggregate(userId);
  }
}
