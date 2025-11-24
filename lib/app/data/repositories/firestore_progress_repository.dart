import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sutra_progress_model.dart';

/// Data model for aggregated user progress (subset replacing GetStorage keys)
class UserProgressAggregate {
  final int mathTablesPoints;
  final int mathTablesTotalQuestions;
  final int mathTablesCorrectAnswers;
  final List<int> completedMathSections;

  final int practiceTotalPoints;
  final int practiceTotalQuestions;
  final int practiceCorrectAnswers;

  final int totalXP;
  final int currentLevel;
  final int streak;

  final int sutrasCompleted; // derived/cached
  final int sutrasTotalPoints; // derived/cached
  final int sutrasAccuracy; // percent int
  final int sutrasTotalAttempts; // attempts across sutras (for inclusion)
  final int tacticsCompleted; // derived/cached
  final int tacticsTotalPoints;
  final int tacticsAccuracy;
  final int tacticsTotalAttempts; // attempts across tactics (for inclusion)

  UserProgressAggregate({
    required this.mathTablesPoints,
    required this.mathTablesTotalQuestions,
    required this.mathTablesCorrectAnswers,
    required this.completedMathSections,
    required this.practiceTotalPoints,
    required this.practiceTotalQuestions,
    required this.practiceCorrectAnswers,
    required this.totalXP,
    required this.currentLevel,
    required this.streak,
    required this.sutrasCompleted,
    required this.sutrasTotalPoints,
    required this.sutrasAccuracy,
    required this.sutrasTotalAttempts,
    required this.tacticsCompleted,
    required this.tacticsTotalPoints,
    required this.tacticsAccuracy,
    required this.tacticsTotalAttempts,
  });

  factory UserProgressAggregate.empty() => UserProgressAggregate(
        mathTablesPoints: 0,
        mathTablesTotalQuestions: 0,
        mathTablesCorrectAnswers: 0,
        completedMathSections: const [],
        practiceTotalPoints: 0,
        practiceTotalQuestions: 0,
        practiceCorrectAnswers: 0,
        totalXP: 0,
        currentLevel: 1,
        streak: 0,
        sutrasCompleted: 0,
        sutrasTotalPoints: 0,
        sutrasAccuracy: 0,
        sutrasTotalAttempts: 0,
        tacticsCompleted: 0,
        tacticsTotalPoints: 0,
        tacticsAccuracy: 0,
        tacticsTotalAttempts: 0,
      );

  factory UserProgressAggregate.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) return UserProgressAggregate.empty();
    Map<String, dynamic> _asMap(dynamic v) {
      if (v is Map) return Map<String, dynamic>.from(v);
      return <String, dynamic>{};
    }
    final math = _asMap(data['math_tables']);
    final practice = _asMap(data['practice_totals']);
    final sutras = _asMap(data['sutra_stats']);
    final tactics = _asMap(data['tactics_stats']);
    return UserProgressAggregate(
      mathTablesPoints: math['points'] ?? 0,
      mathTablesTotalQuestions: math['total_questions'] ?? 0,
      mathTablesCorrectAnswers: math['correct_answers'] ?? 0,
      completedMathSections: List<int>.from(math['completed_sections'] ?? const []),
      practiceTotalPoints: practice['total_points'] ?? 0,
      practiceTotalQuestions: practice['total_questions'] ?? 0,
      practiceCorrectAnswers: practice['correct_answers'] ?? 0,
      totalXP: data['total_xp'] ?? 0,
      currentLevel: data['current_level'] ?? 1,
      streak: data['streak'] ?? 0,
      sutrasCompleted: sutras['completed'] ?? 0,
      sutrasTotalPoints: sutras['total_points'] ?? 0,
      sutrasAccuracy: sutras['accuracy'] ?? 0,
      sutrasTotalAttempts: sutras['total_attempts'] ?? 0,
      tacticsCompleted: tactics['completed'] ?? 0,
      tacticsTotalPoints: tactics['total_points'] ?? 0,
      tacticsAccuracy: tactics['accuracy'] ?? 0,
      tacticsTotalAttempts: tactics['total_attempts'] ?? 0,
    );
  }
}

class FirestoreProgressRepository {
  final FirebaseFirestore _firestore;
  FirestoreProgressRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Basic guard: ensure path userId matches provided and non-empty.
  bool _validateUserId(String userId) {
    final valid = userId.isNotEmpty;
    if (!valid) {
      // ignore: print_used
      print('[progress][warn] invalid/empty userId; skipping write');
    }
    return valid;
  }

  // Main user doc
  DocumentReference<Map<String, dynamic>> _progressDoc(String userId) => _firestore.collection('users').doc(userId);
  // Direct summary docs per aggregate area
  DocumentReference<Map<String, dynamic>> _mathTablesSummary(String userId) => _progressDoc(userId).collection('math_tables').doc('summary');
  DocumentReference<Map<String, dynamic>> _practiceSummary(String userId) => _progressDoc(userId).collection('practice_stats').doc('summary');
  DocumentReference<Map<String, dynamic>> _sutraSummary(String userId) => _progressDoc(userId).collection('sutra_stats').doc('summary');
  DocumentReference<Map<String, dynamic>> _tacticsSummary(String userId) => _progressDoc(userId).collection('tactics_stats').doc('summary');

  // Leaderboard aggregate mirror collection (single doc per user aggregating all sections)
  DocumentReference<Map<String, dynamic>> _leaderboardProgressDoc(String userId) =>
      _firestore.collection('user_progress').doc(userId);

  // History is now stored as a per-user subcollection: users/{userId}/history
  CollectionReference<Map<String, dynamic>> _historyCol(String userId) =>
    _firestore.collection('users').doc(userId).collection('history');

  // Removed separate sutra_progress collection (consolidated into users doc)

  /// Stream aggregate from summary docs + root progress (xp/level/streak).
  /// No external packages; manual fan-in of five streams.
  Stream<UserProgressAggregate> watchAggregate(String userId) {
    final controller = StreamController<UserProgressAggregate>();
    Map<String, dynamic>? math;
    Map<String, dynamic>? practice;
    Map<String, dynamic>? sutras;
    Map<String, dynamic>? tactics;
    Map<String, dynamic>? root;

    void emit() {
      // We only emit once we have at least root + the four summaries (may emit empty defaults if null)
      final map = <String, dynamic>{
        'math_tables': math ?? {},
        'practice_totals': practice ?? {},
        'sutra_stats': sutras ?? {},
        'tactics_stats': tactics ?? {},
        'total_xp': (root ?? {})['total_xp'],
        'current_level': (root ?? {})['current_level'],
        'streak': (root ?? {})['streak'],
        'user_core': (root ?? {})['user_core'],
      };
      // Compute live overall snapshot (same formula as leaderboard)
      final mathQuestions = (math?['total_questions'] ?? 0) as int;
      final mathCorrect = (math?['correct_answers'] ?? 0) as int;
      final practiceQuestions = (practice?['total_questions'] ?? 0) as int;
      final practiceCorrect = (practice?['correct_answers'] ?? 0) as int;
    final mathAcc = mathQuestions == 0 ? 0 : ((mathCorrect / mathQuestions) * 100).round();
    final practiceAcc = practiceQuestions == 0 ? 0 : ((practiceCorrect / practiceQuestions) * 100).round();
    final sutraAcc = (sutras?['accuracy'] ?? 0) as int;
    final tacticsAcc = (tactics?['accuracy'] ?? 0) as int;
    // New rule: overall accuracy strictly = (total correct across question-based sections) / (total attempted) * 100
    final totalCorrect = mathCorrect + practiceCorrect; // (sutras/tactics correctness currently not question-count based in aggregate)
    final totalAttempted = mathQuestions + practiceQuestions;
    final overallAccuracy = totalAttempted == 0 ? 0 : ((totalCorrect / totalAttempted) * 100).round();
      final totalQuestions = mathQuestions + practiceQuestions;
      final totalXP = (root ?? {})['total_xp'] ?? 0;
      map['overall'] = {
        'total_points': totalXP,
        'total_questions': totalQuestions,
        'overall_accuracy': overallAccuracy,
        'math_accuracy': mathAcc,
        'practice_accuracy': practiceAcc,
        'sutra_accuracy': sutraAcc,
        'tactics_accuracy': tacticsAcc,
        'sections_points_sum': (math?['points'] ?? 0) + (practice?['total_points'] ?? 0) + (sutras?['total_points'] ?? 0) + (tactics?['total_points'] ?? 0),
      };
      controller.add(UserProgressAggregate.fromFirestore(map));
    }

  final subs = <StreamSubscription>[];
    subs.add(_mathTablesSummary(userId).snapshots().listen((s) { math = s.data(); emit(); }));
    subs.add(_practiceSummary(userId).snapshots().listen((s) { practice = s.data(); emit(); }));
    subs.add(_sutraSummary(userId).snapshots().listen((s) { sutras = s.data(); emit(); }));
    subs.add(_tacticsSummary(userId).snapshots().listen((s) { tactics = s.data(); emit(); }));
    subs.add(_progressDoc(userId).snapshots().listen((s) { root = s.data(); emit(); }));

    controller.onCancel = () {
      for (final sub in subs) {
        sub.cancel();
      }
    };
    return controller.stream;
  }

  // Recompute & write leaderboard doc combining all four sections + overall scores.
  Future<void> _recomputeLeaderboard(String userId) async {
    final futures = await Future.wait([
      _mathTablesSummary(userId).get(),
      _practiceSummary(userId).get(),
      _sutraSummary(userId).get(),
      _tacticsSummary(userId).get(),
      _progressDoc(userId).get(), // xp/level/streak/badges
    ]);
    final math = futures[0].data() ?? {};
    final practice = futures[1].data() ?? {};
    final sutras = futures[2].data() ?? {};
    final tactics = futures[3].data() ?? {};
    final root = futures[4].data() ?? {};

    final mathQuestions = (math['total_questions'] ?? 0) as int;
    final mathCorrect = (math['correct_answers'] ?? 0) as int;
    final practiceQuestions = (practice['total_questions'] ?? 0) as int;
    final practiceCorrect = (practice['correct_answers'] ?? 0) as int;

    final mathAcc = mathQuestions == 0 ? 0 : ((mathCorrect / mathQuestions) * 100).round();
    final practiceAcc = practiceQuestions == 0 ? 0 : ((practiceCorrect / practiceQuestions) * 100).round();
    final sutraAcc = (sutras['accuracy'] ?? 0) as int;
    final tacticsAcc = (tactics['accuracy'] ?? 0) as int;
    final totalCorrect = mathCorrect + practiceCorrect;
    final totalAttempted = mathQuestions + practiceQuestions;
    final overallAccuracy = totalAttempted == 0 ? 0 : ((totalCorrect / totalAttempted) * 100).round();

    final sectionsPointsSum = (math['points'] ?? 0) + (practice['total_points'] ?? 0) + (sutras['total_points'] ?? 0) + (tactics['total_points'] ?? 0);
    final totalQuestions = mathQuestions + practiceQuestions; // Sutras/tactics currently have no question count fields.
    final totalXP = root['total_xp'] ?? 0;

    final leaderboardPayload = {
      'userId': userId,
      // Provide canonical display_name for leaderboard list (avoid fallback to doc.id)
      'display_name': (root['user_core'] is Map && (root['user_core'] as Map)['display_name'] != null)
          ? (root['user_core'] as Map)['display_name']
          : (root['display_name'] ?? userId),
      'math_tables': math,
      'practice_totals': practice,
      'sutra_stats': sutras,
      'tactics_stats': tactics,
      'total_xp': totalXP,
      'current_level': root['current_level'] ?? 1,
      'streak': root['streak'] ?? 0,
      'earned_badges': root['earned_badges'] ?? [],
      'user_core': root['user_core'],
      'overall': {
        'total_points': totalXP, // unified: total_points mirrors total_xp
        'total_questions': totalQuestions,
        'overall_accuracy': overallAccuracy,
        'math_accuracy': mathAcc,
        'practice_accuracy': practiceAcc,
        'sutra_accuracy': sutraAcc,
        'tactics_accuracy': tacticsAcc,
        'sections_points_sum': sectionsPointsSum,
      },
      'last_updated': FieldValue.serverTimestamp(),
    };

    await _leaderboardProgressDoc(userId).set(leaderboardPayload, SetOptions(merge: true));
  }

  /// Add a history entry (writes server timestamp).
  Future<void> addHistoryEntry({
    required String userId,
    required String section,
    required int points,
    required String description,
    required String type,
  }) async {
    await _historyCol(userId).add({
      // userId implicitly scoped by path; still store for potential collectionGroup queries
      'userId': userId,
      'section': section,
      'points': points,
      'description': description,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Stream recent history entries (limit optional).
  Stream<List<Map<String, dynamic>>> watchHistory(String userId,
      {int limit = 100}) {
    return _historyCol(userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((qs) => qs.docs.map((d) => d.data()).toList());
  }

  /// Fallback stream without explicit ordering (avoids composite index requirement).
  /// Client can sort after receiving.
  Stream<List<Map<String, dynamic>>> watchHistoryNoOrder(String userId,
      {int limit = 100}) {
    return _historyCol(userId)
        .limit(limit)
        .snapshots()
        .map((qs) => qs.docs.map((d) => d.data()).toList());
  }

  /// Save math tables progress (uses merge to preserve other fields).
  Future<void> saveMathTablesProgress({
    required String userId,
    required List<int> completedSections,
    required int totalQuestions,
    required int correctAnswers,
    required int points,
  }) async {
    final docPayload = {
      'completed_sections': completedSections,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'points': points,
      'accuracy': totalQuestions == 0 ? 0 : ((correctAnswers / totalQuestions) * 100).round(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _mathTablesSummary(userId).set(docPayload, SetOptions(merge: true));
    // ignore: print_used
  print('[progress] math_tables save uid='+userId+' sections='+completedSections.length.toString()+' totalQ='+totalQuestions.toString()+' correct='+correctAnswers.toString()+' points='+points.toString());
    await _recomputeLeaderboard(userId);
  }

  /// Recompute practice_totals from user practice_sessions subcollection.
  Future<void> recomputePracticeTotals(String userId) async {
    // Consolidated: practice sessions now live directly in practice_stats collection (siblings to summary doc)
    final sessionsCol = _firestore.collection('users').doc(userId).collection('practice_stats');
    final qs = await sessionsCol.get();
    int totalQuestions = 0;
    int correctAnswers = 0;
    int totalPoints = 0;
    for (final doc in qs.docs) {
      if (doc.id == 'summary') continue; // skip summary doc when aggregating
      final d = doc.data();
      totalQuestions += (d['questionsAttempted'] ?? 0) as int;
      correctAnswers += (d['correctAnswers'] ?? 0) as int;
      totalPoints += (d['pointsEarned'] ?? 0) as int;
    }
    final totals = {
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'total_points': totalPoints,
      'accuracy': totalQuestions == 0 ? 0 : ((correctAnswers / totalQuestions) * 100).round(),
    };
    await _practiceSummary(userId).set({
      ...totals,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // ignore: print_used
  print('[progress] practice_totals recompute uid='+userId+' q='+totals['total_questions'].toString()+' correct='+totals['correct_answers'].toString()+' points='+totals['total_points'].toString());
    await _recomputeLeaderboard(userId);
  }

  /// Upsert a math table section document under user subcollection.
  Future<void> upsertMathTableSection({
    required String userId,
    required int tableNumber,
    required Map<String, dynamic> fields,
  }) async {
    final ref = _firestore.collection('users').doc(userId).collection('math_table_sections').doc('$tableNumber');
    await ref.set({
      'tableNumber': tableNumber,
      'userId': userId,
      ...fields,
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await recomputeMathTablesAggregate(userId);
  }

  /// Recompute math_tables aggregate from math_table_sections subcollection.
  Future<void> recomputeMathTablesAggregate(String userId) async {
    final col = _firestore.collection('users').doc(userId).collection('math_table_sections');
    final qs = await col.get();
    int totalQuestions = 0;
    int correctAnswers = 0;
    int points = 0;
    final completedSections = <int>[];
    for (final doc in qs.docs) {
      final d = doc.data();
      final num = (d['tableNumber'] ?? int.tryParse(doc.id)) as int?;
      if (num != null && (d['is_completed'] == true)) completedSections.add(num);
      totalQuestions += (d['total_questions'] ?? 0) as int;
      correctAnswers += (d['correct_answers'] ?? 0) as int;
      points += (d['points'] ?? 0) as int;
    }
    final docPayload = {
      'completed_sections': completedSections,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'points': points,
      'accuracy': totalQuestions == 0 ? 0 : ((correctAnswers / totalQuestions) * 100).round(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _mathTablesSummary(userId).set(docPayload, SetOptions(merge: true));
    await _recomputeLeaderboard(userId);
  }

  /// Update practice totals via transaction (additive or absolute).
  Future<void> updatePracticeTotals({
    required String userId,
    int addQuestions = 0,
    int addCorrect = 0,
    int addPoints = 0,
  }) async {
    final docRef = _progressDoc(userId);
    final lbRef = _leaderboardProgressDoc(userId);
    Map<String, dynamic> newTotals = {};
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data() ?? {};
  final pt = data['practice_totals'];
  final practice = (pt is Map) ? Map<String, dynamic>.from(pt) : <String, dynamic>{};
      newTotals = {
        'total_questions': (practice['total_questions'] ?? 0) + addQuestions,
        'correct_answers': (practice['correct_answers'] ?? 0) + addCorrect,
        'total_points': (practice['total_points'] ?? 0) + addPoints,
      };
      // Write into stats subcollection outside transaction (can't inside tx).
      // Complete transaction only for leaderboard/root doc minimal fields.
      tx.set(lbRef, {
        'userId': userId,
        'practice_totals': newTotals,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
    // Separate write to summary doc
    await _practiceSummary(userId).set({
      'total_questions': newTotals['total_questions'],
      'correct_answers': newTotals['correct_answers'],
      'total_points': newTotals['total_points'],
      'accuracy': (newTotals['total_questions'] == 0)
          ? 0
          : (((newTotals['correct_answers'] ?? 0) / (newTotals['total_questions'] ?? 1)) * 100).round(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // ignore: print_used
  print('[progress] practice_totals increment uid='+userId+' q='+newTotals['total_questions'].toString()+' correct='+newTotals['correct_answers'].toString()+' points='+newTotals['total_points'].toString());
    await _recomputeLeaderboard(userId);
  }

  /// Upsert sutra progress into subcollection: users/{userId}/sutras/{sutraId}
  Future<void> upsertSutraProgress({
    required String userId,
    required int sutraId,
    required Map<String, dynamic> progressFields,
  }) async {
    final docRef = _firestore.collection('users').doc(userId).collection('sutras').doc('$sutraId');
    await docRef.set({
      'sutraId': sutraId,
      'userId': userId,
      ...progressFields,
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await updateSutraAggregate(userId: userId);
  }

  /// Stream all sutra progress documents for user from subcollection.
  Stream<Map<int, Map<String, dynamic>>> watchAllSutraProgress(String userId) {
    final col = _firestore.collection('users').doc(userId).collection('sutras');
    return col.snapshots().map((qs) {
      final result = <int, Map<String, dynamic>>{};
      for (final d in qs.docs) {
        final data = d.data();
        final id = data['sutraId'] ?? int.tryParse(d.id);
        if (id is int) result[id] = data;
      }
      return result;
    });
  }

  /// Recompute sutra aggregate statistics from subcollection users/{userId}/sutras
  Future<void> updateSutraAggregate({required String userId}) async {
    final col = _firestore.collection('users').doc(userId).collection('sutras');
    final qs = await col.get();
    int completed = 0;
    int totalPoints = 0;
    double accuracySum = 0;
    int withAttempts = 0;
    for (final doc in qs.docs) {
      final m = doc.data();
      if (m['is_completed'] == true) completed++;
      totalPoints += (m['points'] ?? 0) as int;
      final attempts = (m['total_attempts'] ?? 0) as int;
      final accuracy = (m['accuracy'] ?? 0).toDouble();
      if (attempts > 0) {
        accuracySum += accuracy;
        withAttempts++;
      }
    }
    final avgAcc = withAttempts == 0 ? 0 : (accuracySum / withAttempts).round();
    final sutraStats = {
      'completed': completed,
      'total_points': totalPoints,
      'accuracy': avgAcc,
    };
    await _sutraSummary(userId).set({
      ...sutraStats,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // ignore: print_used
  print('[progress] sutra_stats recompute uid='+userId+' completed='+sutraStats['completed'].toString()+' points='+sutraStats['total_points'].toString()+' acc='+sutraStats['accuracy'].toString());
    await _recomputeLeaderboard(userId);
  }

  /// Upsert lesson (tactics) progress into consolidated subcollection users/{userId}/tactics_stats/{lessonId}
  Future<void> upsertLessonProgress({
    required String userId,
    required int lessonId,
    required Map<String, dynamic> progressFields,
  }) async {
    final docRef = _firestore.collection('users').doc(userId).collection('tactics_stats').doc('$lessonId');
    await docRef.set({
      'lessonId': lessonId,
      'userId': userId,
      ...progressFields,
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await updateTacticsAggregate(userId: userId);
  }

  /// Stream all lesson progress documents.
  Stream<Map<int, Map<String, dynamic>>> watchAllLessonProgress(String userId) {
    final col = _firestore.collection('users').doc(userId).collection('tactics_stats');
    return col.snapshots().map((qs) {
      final result = <int, Map<String, dynamic>>{};
      for (final d in qs.docs) {
        if (d.id == 'summary') continue; // skip summary doc
        final data = d.data();
        final id = data['lessonId'] ?? int.tryParse(d.id);
        if (id is int) result[id] = data;
      }
      return result;
    });
  }

  /// Recompute tactics aggregate statistics from consolidated tactics_stats subcollection.
  Future<void> updateTacticsAggregate({required String userId}) async {
    final col = _firestore.collection('users').doc(userId).collection('tactics_stats');
    final qs = await col.get();
    int completed = 0;
    int totalPoints = 0;
    int attemptsSum = 0;
    int correctSum = 0;
    for (final doc in qs.docs) {
      if (doc.id == 'summary') continue; // skip summary doc
      final m = doc.data();
      if (m['is_completed'] == true) completed++;
      totalPoints += (m['points'] ?? 0) as int;
      attemptsSum += (m['total_attempts'] ?? 0) as int;
      correctSum += (m['correct_answers'] ?? 0) as int;
    }
    final accuracy = attemptsSum == 0 ? 0 : ((correctSum / attemptsSum) * 100).round();
    final tacticsStats = {
      'completed': completed,
      'total_points': totalPoints,
      'accuracy': accuracy,
    };
    await _tacticsSummary(userId).set({
      ...tacticsStats,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // ignore: print_used
    print('[progress] tactics_stats recompute uid='+userId+' completed='+tacticsStats['completed'].toString()+' points='+tacticsStats['total_points'].toString()+' acc='+tacticsStats['accuracy'].toString());
    await _recomputeLeaderboard(userId);
  }

  /// Save sutra aggregate explicitly (similar style to math tables save)
  Future<void> saveSutraStats({
    required String userId,
    required int completed,
    required int totalPoints,
    required int accuracy,
  }) async {
    final sutraStats = {
      'completed': completed,
      'total_points': totalPoints,
      'accuracy': accuracy,
    };
    await _sutraSummary(userId).set({
      ...sutraStats,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // ignore: print_used
  print('[progress] sutra_stats save uid='+userId+' completed='+sutraStats['completed'].toString()+' points='+sutraStats['total_points'].toString()+' acc='+sutraStats['accuracy'].toString());
    await _recomputeLeaderboard(userId);
  }

  /// Save tactics aggregate explicitly.
  Future<void> saveTacticsStats({
    required String userId,
    required int completed,
    required int totalPoints,
    required int accuracy,
  }) async {
    final tacticsStats = {
      'completed': completed,
      'total_points': totalPoints,
      'accuracy': accuracy,
    };
    await _tacticsSummary(userId).set({
      ...tacticsStats,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // ignore: print_used
    print('[progress] tactics_stats save uid='+userId+' completed='+tacticsStats['completed'].toString()+' points='+tacticsStats['total_points'].toString()+' acc='+tacticsStats['accuracy'].toString());
    await _recomputeLeaderboard(userId);
  }

  /// Update user core details map (display name, photo URL) and mirror to leaderboard.
  Future<void> updateUserCore({
    required String userId,
    String? displayName,
    String? photoUrl,
  }) async {
    if (!_validateUserId(userId)) return;
    final payload = {
      'user_core': {
        'userId': userId,
        if (displayName != null) 'display_name': displayName,
        if (photoUrl != null) 'photo_url': photoUrl,
      },
      // Mirror display_name at root level for simpler queries & legacy consumers
      if (displayName != null) 'display_name': displayName,
      'last_updated': FieldValue.serverTimestamp(),
    };
    await _progressDoc(userId).set(payload, SetOptions(merge: true));
    await _leaderboardProgressDoc(userId).set(payload, SetOptions(merge: true));
  }

  /// Migration helper: ensure all leaderboard docs contain a top-level display_name.
  /// Returns list of updated userIds. Safe to run multiple times.
  Future<List<String>> backfillLeaderboardDisplayNames({int batchSize = 300}) async {
    final col = _firestore.collection('user_progress');
    final qs = await col.limit(batchSize).get();
    final updated = <String>[];
    final batch = _firestore.batch();
    for (final doc in qs.docs) {
      final data = doc.data();
      final uid = doc.id;
      final existingTop = data['display_name'];
      String? candidate;
      if (existingTop is String && existingTop.trim().isNotEmpty) {
        continue; // already populated
      }
      // Prefer nested user_core.display_name
      if (data['user_core'] is Map && (data['user_core'] as Map)['display_name'] is String) {
        candidate = (data['user_core'] as Map)['display_name'] as String?;
      }
      candidate ??= data['display_name']; // legacy root maybe but empty
      candidate ??= uid; // fallback to uid
      batch.set(doc.reference, {
        'display_name': candidate,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      updated.add(uid);
    }
    if (updated.isNotEmpty) {
      await batch.commit();
    }
    return updated;
  }

  /// Force recompute of all summaries + leaderboard (use after complex updates).
  Future<void> recomputeAll(String userId) async {
    if (!_validateUserId(userId)) return;
    await Future.wait([
      recomputeMathTablesAggregate(userId),
      recomputePracticeTotals(userId),
      updateSutraAggregate(userId: userId),
      updateTacticsAggregate(userId: userId),
    ]);
    // Leaderboard already recomputed inside each, but ensure final consistency.
    await _recomputeLeaderboard(userId);
  }

  /// Save practice totals explicitly (non-incremental absolute write).
  Future<void> savePracticeTotals({
    required String userId,
    required int totalQuestions,
    required int correctAnswers,
    required int totalPoints,
  }) async {
    final totals = {
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'total_points': totalPoints,
      'accuracy': totalQuestions == 0 ? 0 : ((correctAnswers / totalQuestions) * 100).round(),
    };
    await _practiceSummary(userId).set({
      ...totals,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    // ignore: print_used
  print('[progress] practice_totals save uid='+userId+' q='+totals['total_questions'].toString()+' correct='+totals['correct_answers'].toString()+' points='+totals['total_points'].toString());
    await _recomputeLeaderboard(userId);
  }

  /// Increment XP & maybe level (simple determinism) in transaction.
  Future<void> awardXP({required String userId, required int xp}) async {
    if (!_validateUserId(userId)) return;
    final docRef = _progressDoc(userId);
    final lbRef = _leaderboardProgressDoc(userId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data() ?? {};
      final currentXP = data['total_xp'] ?? 0;
      final newXP = currentXP + xp;
      final newLevel = (newXP / 500).floor() + 1;
      tx.set(docRef, {
        'userId': userId,
        'total_xp': newXP,
        'current_level': newLevel,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      tx.set(lbRef, {
        'userId': userId,
        'total_xp': newXP,
        'current_level': newLevel,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
    await _recomputeLeaderboard(userId); // refresh overall after xp change
  }

  /// Add badge id and award XP in same transaction.
  Future<void> awardBadge({
    required String userId,
    required String badgeId,
    required int xpReward,
  }) async {
    if (!_validateUserId(userId)) return;
    final docRef = _progressDoc(userId);
    final lbRef = _leaderboardProgressDoc(userId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data() ?? {};
      final earned = List<String>.from(data['earned_badges'] ?? const []);
      if (!earned.contains(badgeId)) {
        earned.add(badgeId);
      }
      final currentXP = data['total_xp'] ?? 0;
      final newXP = currentXP + xpReward;
      final newLevel = (newXP / 500).floor() + 1;
      tx.set(docRef, {
        'userId': userId,
        'earned_badges': earned,
        'total_xp': newXP,
        'current_level': newLevel,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      tx.set(lbRef, {
        'userId': userId,
        'earned_badges': earned,
        'total_xp': newXP,
        'current_level': newLevel,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
    await _recomputeLeaderboard(userId); // ensure overall fields stay accurate
  }

  /// Record a practice session (granular analytics) and update totals.
  Future<void> recordPracticeSession({
    required String userId,
    required String mode,
    required String operation,
    required int questionsAttempted,
    required int correctAnswers,
    required int pointsEarned,
    required int durationSeconds,
    String? source,
  }) async {
    if (!_validateUserId(userId)) return;
    final batch = _firestore.batch();
    // Consolidated: write session inside practice_stats collection (alongside summary doc)
    final sessionRef = _firestore.collection('users').doc(userId).collection('practice_stats').doc();
    batch.set(sessionRef, {
      'id': sessionRef.id,
      'userId': userId,
      'mode': mode,
      'operation': operation,
      'questionsAttempted': questionsAttempted,
      'correctAnswers': correctAnswers,
      'pointsEarned': pointsEarned,
      'durationSeconds': durationSeconds,
      'source': source,
      // Store both for backward compatibility and uniform querying
      'timestamp': FieldValue.serverTimestamp(),
      'startedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    // Recompute totals from all sessions (simpler, guarantees consistency)
    await recomputePracticeTotals(userId);
  }

  // ===================== FULL USER STATS FETCH =====================
  /// Complete snapshot of a user's stats pulled ONLY from Firestore (no local persistence).
  /// Includes:
  /// - Aggregate (math_tables, practice_totals, sutra_stats, tactics_stats, xp, level, streak)
  /// - All sutra progress docs
  /// - All lesson (tactics) progress docs
  /// - All math table section docs
  /// - Recent practice sessions (optional limit)
  /// - Recent history entries (optional limit)
  ///
  /// This is a one-time fetch (Future). For real-time updates use the existing stream helpers.
  Future<FullUserStats> fetchFullUserStats({
    required String userId,
    int practiceSessionsLimit = 200,
    int historyLimit = 200,
  }) async {
    if (!_validateUserId(userId)) {
      return FullUserStats(
        aggregate: UserProgressAggregate.empty(),
        sutras: const [],
        lessons: const [],
        mathTableSections: const [],
        practiceSessions: const [],
        history: const [],
      );
    }
    // Fetch each summary doc individually + root doc for xp/level/badges
    final summaryFutures = await Future.wait([
      _mathTablesSummary(userId).get(),
      _practiceSummary(userId).get(),
      _sutraSummary(userId).get(),
      _tacticsSummary(userId).get(),
      _progressDoc(userId).get(),
    ]);
    final map = <String, dynamic>{
      'math_tables': summaryFutures[0].data(),
      'practice_totals': summaryFutures[1].data(),
      'sutra_stats': summaryFutures[2].data(),
      'tactics_stats': summaryFutures[3].data(),
    };
    final rootData = summaryFutures[4].data() ?? {};
    map['total_xp'] = rootData['total_xp'];
    map['current_level'] = rootData['current_level'];
    map['earned_badges'] = rootData['earned_badges'];
    map['streak'] = rootData['streak'];
    final aggregate = UserProgressAggregate.fromFirestore(map);

    // Parallel fetch to minimize latency
  // Granular items now live in combined collections: sutra_stats (items + summary), tactics_stats (items + summary), practice_stats (sessions + summary)
  final sutrasCol = _firestore.collection('users').doc(userId).collection('sutra_stats');
  final lessonsCol = _firestore.collection('users').doc(userId).collection('tactics_stats');
    final mathTablesCol = _firestore.collection('users').doc(userId).collection('math_table_sections');
  final practiceSessionsCol = _firestore.collection('users').doc(userId).collection('practice_stats');
    final historyCol = _historyCol(userId);

    final futures = await Future.wait([
      sutrasCol.get(),
      lessonsCol.get(),
      mathTablesCol.get(),
      practiceSessionsCol.limit(practiceSessionsLimit).get(),
      historyCol.orderBy('timestamp', descending: true).limit(historyLimit).get(),
    ]);

  final sutrasSnap = futures[0];
  final lessonsSnap = futures[1];
    final mathTablesSnap = futures[2];
    final practiceSnap = futures[3];
    final historySnap = futures[4];

    final sutraProgress = <SutraProgress>[];
    for (final d in sutrasSnap.docs) {
      if (d.id == 'summary') continue; // skip summary doc
      final raw = Map<String, dynamic>.from(d.data());
      if (!raw.containsKey('sutra_id') && raw.containsKey('sutraId')) {
        raw['sutra_id'] = raw['sutraId'];
      }
      sutraProgress.add(SutraProgress.fromJson(raw));
    }

    final lessonProgress = <LessonProgress>[];
    for (final d in lessonsSnap.docs) {
      if (d.id == 'summary') continue; // skip summary doc
      lessonProgress.add(LessonProgress.fromFirestore(d.data()));
    }

    final mathSections = <MathTableSectionProgress>[];
    for (final d in mathTablesSnap.docs) {
      mathSections.add(MathTableSectionProgress.fromFirestore(d.data()));
    }

    final practiceSessions = <PracticeSession>[];
    for (final d in practiceSnap.docs) {
      if (d.id == 'summary') continue; // skip summary doc
      practiceSessions.add(PracticeSession.fromFirestore(d.data()));
    }

    final historyEntries = <HistoryEntry>[];
    for (final d in historySnap.docs) {
      historyEntries.add(HistoryEntry.fromFirestore(d.data()));
    }

    return FullUserStats(
      aggregate: aggregate,
      sutras: sutraProgress,
      lessons: lessonProgress,
      mathTableSections: mathSections,
      practiceSessions: practiceSessions,
      history: historyEntries,
    );
  }
}
// ===================== DATA CLASSES FOR COMPLETE STATS =====================

class LessonProgress {
  final int lessonId;
  final bool isCompleted;
  final int points;
  final int totalAttempts;
  final int correctAnswers;
  final int accuracy; // percent
  LessonProgress({
    required this.lessonId,
    required this.isCompleted,
    required this.points,
    required this.totalAttempts,
    required this.correctAnswers,
    required this.accuracy,
  });
  factory LessonProgress.fromFirestore(Map<String, dynamic> data) => LessonProgress(
        lessonId: data['lessonId'] ?? -1,
        isCompleted: data['is_completed'] == true,
        points: data['points'] ?? 0,
        totalAttempts: data['total_attempts'] ?? 0,
        correctAnswers: data['correct_answers'] ?? 0,
        accuracy: data['accuracy'] ?? 0,
      );
}

class MathTableSectionProgress {
  final int tableNumber;
  final bool isCompleted;
  final int totalQuestions;
  final int correctAnswers;
  final int points;
  MathTableSectionProgress({
    required this.tableNumber,
    required this.isCompleted,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.points,
  });
  factory MathTableSectionProgress.fromFirestore(Map<String, dynamic> data) => MathTableSectionProgress(
        tableNumber: data['tableNumber'] ?? -1,
        isCompleted: data['is_completed'] == true,
        totalQuestions: data['total_questions'] ?? 0,
        correctAnswers: data['correct_answers'] ?? 0,
        points: data['points'] ?? 0,
      );
}

class PracticeSession {
  final String id; // Firestore doc id (optional if we include later)
  final int questionsAttempted;
  final int correctAnswers;
  final int pointsEarned;
  final DateTime? timestamp;
  PracticeSession({
    required this.id,
    required this.questionsAttempted,
    required this.correctAnswers,
    required this.pointsEarned,
    required this.timestamp,
  });
  factory PracticeSession.fromFirestore(Map<String, dynamic> data) {
    Timestamp? ts;
    if (data['timestamp'] is Timestamp) {
      ts = data['timestamp'] as Timestamp;
    } else if (data['startedAt'] is Timestamp) {
      ts = data['startedAt'] as Timestamp; // legacy field fallback
    }
    return PracticeSession(
      id: data['id'] ?? '',
      questionsAttempted: data['questionsAttempted'] ?? 0,
      correctAnswers: data['correctAnswers'] ?? 0,
      pointsEarned: data['pointsEarned'] ?? 0,
      timestamp: ts?.toDate(),
    );
  }
}

class HistoryEntry {
  final String section;
  final int points;
  final String description;
  final String type;
  final DateTime? timestamp;
  HistoryEntry({
    required this.section,
    required this.points,
    required this.description,
    required this.type,
    required this.timestamp,
  });
  factory HistoryEntry.fromFirestore(Map<String, dynamic> data) => HistoryEntry(
        section: data['section'] ?? '',
        points: data['points'] ?? 0,
        description: data['description'] ?? '',
        type: data['type'] ?? '',
        timestamp: data['timestamp'] is Timestamp ? (data['timestamp'] as Timestamp).toDate() : null,
      );
}

class FullUserStats {
  final UserProgressAggregate aggregate;
  final List<SutraProgress> sutras; // using model from sutra_progress_model.dart
  final List<LessonProgress> lessons;
  final List<MathTableSectionProgress> mathTableSections;
  final List<PracticeSession> practiceSessions;
  final List<HistoryEntry> history;
  FullUserStats({
    required this.aggregate,
    required this.sutras,
    required this.lessons,
    required this.mathTableSections,
    required this.practiceSessions,
    required this.history,
  });
}

extension FirestoreProgressRepositoryMigrations on FirestoreProgressRepository {
  /// Migration: move legacy separated collections into combined collections.
  Future<void> migrateLegacySeparatedCollections(String userId) async {
    if (!_validateUserId(userId)) return;
    final sutrasLegacy = _firestore.collection('users').doc(userId).collection('sutras');
    final lessonsLegacy = _firestore.collection('users').doc(userId).collection('lessons');
    final practiceLegacy = _firestore.collection('users').doc(userId).collection('practice_sessions');
    final batch = _firestore.batch();
    final sutraDocs = await sutrasLegacy.get();
    for (final d in sutraDocs.docs) {
      batch.set(_progressDoc(userId).collection('sutra_stats').doc(d.id), d.data(), SetOptions(merge: true));
    }
    final lessonDocs = await lessonsLegacy.get();
    for (final d in lessonDocs.docs) {
      batch.set(_progressDoc(userId).collection('tactics_stats').doc(d.id), d.data(), SetOptions(merge: true));
    }
    final practiceDocs = await practiceLegacy.get();
    for (final d in practiceDocs.docs) {
      batch.set(_progressDoc(userId).collection('practice_stats').doc(d.id), d.data(), SetOptions(merge: true));
    }
    batch.set(_sutraSummary(userId), {'migrated_at': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    batch.set(_tacticsSummary(userId), {'migrated_at': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    batch.set(_practiceSummary(userId), {'migrated_at': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await batch.commit();
    await updateSutraAggregate(userId: userId);
    await updateTacticsAggregate(userId: userId);
    await recomputePracticeTotals(userId);
    // ignore: print_used
    print('[progress] migration completed for user '+userId);
  }

  /// Verify leaderboard docs userId field matches doc ID. Optionally fix.
  Future<List<String>> verifyAndFixLeaderboardUserIds({bool fix = false}) async {
    final col = _firestore.collection('user_progress');
    final qs = await col.get();
    final mismatches = <String>[];
    for (final doc in qs.docs) {
      final data = doc.data();
      final fieldId = data['userId'];
      if (fieldId != doc.id) {
        mismatches.add(doc.id);
        if (fix) {
          await doc.reference.set({'userId': doc.id, 'last_updated': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        }
      }
    }
    if (mismatches.isNotEmpty) {
      // ignore: print_used
      print('[progress][warn] leaderboard mismatches: '+mismatches.join(','));
    }
    return mismatches;
  }
}
