# Firestore Schema & Migration Guide

## Collections & Documents

users/{userId}
- math_tables: { completed_sections: [int], total_questions: int, correct_answers: int, points: int }
- sutra_stats: { completed: int, total_points: int, accuracy: int }
- tactics_stats: { completed: int, total_points: int, accuracy: int }
- practice_totals: { total_questions: int, correct_answers: int, total_points: int }
- total_xp: int
- current_level: int
- streak: int
- overall_accuracy: number (optional aggregate)
- total_points_overall: number (optional aggregate)
- total_questions_attempted: number
- total_correct_answers: number
- earned_badges: [string]
- last_updated: timestamp

Subcollections (all scoped under user document):
- users/{userId}/sutras/{sutraId}
  - sutraId: int
  - is_completed: bool
  - total_attempts: int
  - correct_answers: int
  - wrong_answers: int
  - hints_used: int
  - has_completed_interactive: bool
  - accuracy: int
  - points: int
  - migrated_at: timestamp (only for migrated docs)
  - last_updated: timestamp

- users/{userId}/lessons/{lessonId}
  - lessonId: int
  - is_completed: bool
  - total_attempts: int
  - correct_answers: int
  - points: int
  - last_updated: timestamp

- users/{userId}/practice_sessions/{sessionId}
  - mode: string
  - operation: string
  - questionsAttempted: int
  - correctAnswers: int
  - pointsEarned: int
  - durationSeconds: int
  - source: string|null
  - startedAt: timestamp

- users/{userId}/math_table_sections/{tableNumber}
  - tableNumber: int
  - is_completed: bool (optional)
  - total_questions: int
  - correct_answers: int
  - points: int
  - last_updated: timestamp

Leaderboard mirror:
- user_progress/{userId}
  - mirrors select aggregate fields from users/{userId}

History subcollection:
- users/{userId}/history/{entryId}
  - userId: string
  - section: string (Math Tables | Vedic Sutras | Tactics | Practice)
  - points: int
  - description: string
  - type: string (test | lesson | practice | sutra)
  - timestamp: timestamp

## Migration from Embedded Maps

Legacy fields:
- sutras_granular
- lessons_granular

### Steps
1. Detect legacy fields on user document.
2. For each key/value pair in sutras_granular, create/merge a document in users/{userId}/sutras/{sutraId}.
3. For each key/value pair in lessons_granular, create/merge a document in users/{userId}/lessons/{lessonId}.
4. Delete legacy fields from user document.
5. Recompute sutra_stats and tactics_stats using new subcollections.

Implemented helper: ProgressService.migrateLegacyEmbeddedMaps(userId)
Call once after authentication for each user; it is idempotent (subcollection docs will merge).

### Sample Invocation
```dart
final ps = ProgressService();
await ps.migrateLegacyEmbeddedMaps(userId);
```

## Aggregation Recompute Functions
- Sutras: _updateSutraAggregate(userId) -> reads subcollection sutras
- Lessons/Tactics: _updateLessonAggregate(userId) -> reads subcollection lessons
- Practice: recomputePracticeTotals(userId) -> reads practice_sessions
- Math Tables: recomputeMathTablesAggregate(userId) -> reads math_table_sections

## Adding a New Section
1. Create subcollection under users/{userId}/<section>.
2. Add per-item documents with consistent field naming (id, userId, metrics, last_updated).
3. Implement upsert + recompute aggregate functions in repository/service.
4. Extend UserProgressAggregate with new fields.
5. Update controllers/views to read aggregate only.

## Query Considerations
- For cross-user leaderboard queries, rely on user_progress mirror documents.
- For detailed user progress analytics, query subcollections directly.
- Ensure indexes for any compound queries (e.g., ordering history by timestamp + filters).

## Data Integrity Notes
- All writes include last_updated for chronological tracking.
- Migrations add migrated_at to migrated granular docs for auditing.
- Recompute functions fully recalculate aggregates (no additive drift).

## Cleanup
- After successful migration for all users, remove any code referencing legacy map fields.
- Periodically verify document sizes remain within Firestore limits (subcollections mitigate large doc growth).

## Troubleshooting
- If aggregates show zeros after migration, verify subcollection documents exist and run recompute functions manually.
- Type errors (e.g., int vs Map) indicate malformed fields; inspect user doc for legacy writes.

## Example Overall Flow
1. User signs in.
2. Call migrateLegacyEmbeddedMaps(userId).
3. Load aggregates stream (watchAggregate).
4. Display section stats on home from aggregate only.
5. Record session/lesson/sutra progress via appropriate upsert or recordPracticeSession.
6. Recompute aggregates automatically after each upsert.

---
Generated: 2025-11-22

---

## New Stats Subcollection Migration (2025-11-23)

We transitioned aggregate fields from the root user document into a dedicated stats subcollection for clarity and doc size management.

Authoritative docs now live under:
users/{userId}/stats/
  - math_tables
  - practice_totals
  - sutra_stats
  - tactics_stats

Root user doc still mirrors these aggregates temporarily for backward compatibility (legacy reads & leaderboard updates). Leaderboard continues to mirror aggregates in user_progress/{userId}.

### Backfill Steps
1. For each existing user document, read legacy aggregate maps: math_tables, practice_totals, sutra_stats, tactics_stats.
2. Write each map into users/{userId}/stats/{same_key} with an added updated_at: serverTimestamp().
3. If any map missing, trigger recompute functions:
   - math_tables: recomputeMathTablesAggregate(userId)
   - practice_totals: recomputePracticeTotals(userId)
   - sutra_stats: updateSutraAggregate(userId)
   - tactics_stats: updateTacticsAggregate(userId)
4. After verifying new stats docs exist, plan removal of legacy root mirrors (optional once all consumers use stats subcollection or watchAggregate()).

### One-off Script Sketch (pseudo-code)
```dart
final firestore = FirebaseFirestore.instance;
final users = await firestore.collection('users').get();
for (final u in users.docs) {
  final data = u.data();
  final statsRef = u.reference.collection('stats');
  Future<void> writeIfMap(String key) async {
    final v = data[key];
    if (v is Map) {
      await statsRef.doc(key).set({
        ...v,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
  await writeIfMap('math_tables');
  await writeIfMap('practice_totals');
  await writeIfMap('sutra_stats');
  await writeIfMap('tactics_stats');
}
```

### Decommission Plan
Once all app versions rely solely on stats subcollection and fetchFullUserStats has been in production:
1. Remove writes of aggregates to root user doc (leave xp/level/badges there for transactional updates).
2. Update leaderboard mirror logic if needed to read from stats docs (optional; currently mirrored at write time).
3. Delete legacy aggregate maps from root user doc via batch update.

### Verification Checklist
- watchAggregate(userId) returns non-empty fields for a migrated user.
- fetchFullUserStats(userId) populates math_tables, practice_totals, sutra_stats, tactics_stats from stats docs.
- Leaderboard user_progress documents still update when aggregates change.
- Lesson completion updates tactics_stats doc under stats.

---
