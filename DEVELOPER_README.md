# Vedic Maths App – Developer Guide

This guide explains the architecture, navigation flow, data models, and extension points for lessons, sutras, tactics, practice, points, and history.

---
## 1. Tech Stack & Core Patterns
- Framework: Flutter
- State Management & Routing: GetX (Controllers, Bindings, `GetPage` routes)
- Persistence: GetStorage (lightweight local key/value), SharedPreferences (settings/profile), Firebase Firestore (planned user progress sync)
- Audio/TTS: `TtsService`
- Reactive State: `Rx<Type>` and `.obs` wrappers for UI binding

Key principles:
1. Each feature has a Controller (business + reactive state) and optional Binding (dependency wiring).
2. All navigation is centralized in `lib/app/routes/app_pages.dart` with explicit route constants and assigned bindings.
3. Progress, points, and history recording flow through the `GlobalProgressController` for aggregation.
4. Content for Vedic Sutras and Tactics lives in data model files or JSON under `assets/data` and `lib/app/data`.

---
## 2. High-Level Directory Overview
```
lib/
  main.dart                    // App bootstrap & GetMaterialApp
  firebase_options.dart        // Firebase init options
  app/
    routes/                    // Route declarations (AppPages)
    bindings/                  // DI Bindings for feature controllers
    controllers/               // GetX controllers (logic/state)
    data/                      // Static data & models (sutras, course, etc.)
    pages/                     // UI screens (views)
    services/                  // Cross-cutting services (TTS, auth, etc.)
    ui/                        // Theme, widgets, styles
assets/
  data/16_SUTRAS_COMPLETE.json // JSON source for sutra content
  fonts/, images/, icons/, illustrations/
```
Other project roots contain native platform code (android/, ios/, macos/, etc.) and configuration.

---
## 3. Core Controllers Overview
| Controller | Purpose | Key Reactive Fields |
|------------|---------|---------------------|
| `VedicCourseController` | Manages chapters & tactics lessons | `chapters`, `currentChapter`, `currentLesson`, `userProgress` |
| `EnhancedVedicCourseController` | Sutras interactive flow, TTS, XP, badges | `allSutras`, `sutraProgress`, `totalXP`, `completedLessons` |
| `InteractiveLessonViewController` | Per-sutra interactive example + practice steps | `currentStep`, `practiceSteps`, `ttsEnabled` |
| `SutrasPracticeController` | Timed random sutra practice set | `currentQuestion`, `questionTimeRemaining`, `totalPoints` |
| `TacticsPracticeController` | Timed random tactics practice set | Similar to sutras practice |
| `GlobalProgressController` | Aggregates points & accuracy across all sections | `totalPoints`, `overallAccuracy`, `progressHistory` |
| `HistoryController` | Search/filter history entries | `searchQuery`, `filtered`, `isSearching` |
| `SettingsController` | Profile & auth settings (lazy AuthService) | Various profile fields |

---
## 4. Data Models & Where to Modify Content
### 4.1 Tactics (Lessons/Chapters)
Files:
- `lib/app/data/models/vedic_course_models.dart` (Chapter, Lesson, PracticeQuestion, UserProgress)
- Repository: `lib/app/data/repositories/vedic_course_repository.dart` (stubbed fetchers)

Add/Modify a Chapter:
1. Define new `Chapter(chapterId, title, lessons: [...])` in repository or a data source file feeding the repo.
2. Include `lessons` list with `Lesson(lessonId, lessonTitle, description, practice: [PracticeQuestion(...)])`.
3. Ensure unique IDs; unlock logic depends on sequential list order.
4. If awarding points or history entries: call `GlobalProgressController.addHistoryEntry` inside `completeLesson()` logic (`VedicCourseController`).

Add/Modify a Lesson Practice Question:
- Extend `practice: [PracticeQuestion(problem: '32 x 21', answer: '672', hint: '...')]` inside the lesson.
- Scores: `lesson.score` can be updated by your evaluation code; completion sets `isCompleted = true` and unlocks next lesson.

### 4.2 Sutras Content
Files:
- `assets/data/16_SUTRAS_COMPLETE.json` – Full JSON source (loaded by `EnhancedVedicCourseController.loadSutrasFromJson()`)
- `lib/app/data/vedic_16_sutras_content.dart` – Inline structured map (partial subset)
- `lib/app/data/vedic_16_sutras_complete.dart` – Rich extended specification (demonstrative model)

To Add/Complete Remaining Sutras:
1. Append to JSON `sutras` array following existing schema: keys for `sutra_id`, `sutra_name`, explanations, `practice_problems`, `interactive_steps`, `micro_quiz`.
2. Keep field naming consistent (loader expects `sutras` list, each with `practice` problems inside the simplified model mapping).
3. For progress tracking ensure `sutra_id` is unique; `EnhancedVedicCourseController` seeds progress map with sutra IDs.
4. Trigger completion via `markSutraCompleted(sutraId)` (adds history & awards XP).
5. Auto-completion path uses `checkAndCompleteSutra(sutraId)` after interactive & accuracy conditions.

### 4.3 Practice Problems (Random Timed Sets)
- Sutras: Derived from each `SutraSimpleModel.practice` items.
- Tactics: Derived from each `Lesson.practice` items.
- Both controllers shuffle and limit to 20 questions.
- Timer logic per question awards: `10 + timeRemaining` points.

### 4.4 Interactive Lesson Steps
`InteractiveLessonViewController` loads a structured example from `VedicSutraExamples.getExample(sutraId)`. To change steps, update that example provider file `vedic_sutra_examples.dart` (not shown above but referenced). Each step ideally contains `audioText`, `description`, `display`.

---
## 5. Navigation Flow (Routes → Binding → Controller → View)
Central file: `lib/app/routes/app_pages.dart`.

Example: Interactive Sutra Lesson & Practice Flow
1. User taps a sutra on `Vedic16SutrasView` → navigates to `Routes.SUTRA_DETAIL`.
2. From details can start interactive lesson → `Routes.INTERACTIVE_LESSON` with arguments `{ 'sutra': SutraSimpleModel, 'startPractice': false }`.
3. Inside `InteractiveLessonView`, finishing all example steps toggles practice mode and loads step-by-step practice.
4. Practice completion triggers XP award + potential auto-completion → history entry via `EnhancedVedicCourseController.markInteractiveCompleted` and `GlobalProgressController` indirectly.

Tactics Lesson Flow
1. `VedicCourseView` lists chapters → `ChapterDetailView` → select lesson → `LessonDetailView`.
2. Lesson completion via `completeLesson()` updates user progress, unlocks next lesson, awards points (history entry section = 'Vedic Tactics').
3. Optional practice steps route: `Routes.LESSON_PRACTICE` similarly logs outcomes.

Practice Hub Flow
1. Navigate to `Routes.PRACTICE_HUB` → choose Sutras or Tactics practice.
2. `Routes.PRACTICE_SUTRAS` or `Routes.PRACTICE_TACTICS` loads controller via respective binding (ensures prerequisite controllers registered).
3. After finishing timed set → `GlobalProgressController.addHistoryEntry(section: 'Sutra Practice'|'Tactics Practice', type: 'practice')`.

Mini Game Flow (Sutra-specific)
1. Chip/button on sutra detail page routes to `Routes.SUTRA{N}_GAME`.
2. Game view awards points; integrate with `GlobalProgressController.addHistoryEntry(section: 'Vedic Sutras', type: 'game')` when adding scoring.

Bindings Guarantee
- Each GetPage references a `Binding` which `lazyPut`s required controllers/services; avoid direct `Get.find()` in constructors—prefer `onInit` or lazy getters.

---
## 6. Points & History Mechanics
### 6.1 Writing History Entries
Use:
```dart
Get.find<GlobalProgressController>().addHistoryEntry(
  section: 'Vedic Sutras',
  points: 100,
  description: 'Completed: Ekadhikena Purvena',
  type: 'sutra',
);
```
Persisted remotely in Firestore under per-user subcollection `users/{userId}/history` (documents with section, points, description, type, timestamp). Local GetStorage legacy removed.

### 6.2 Aggregation Logic (`GlobalProgressController.calculateOverallProgress()`)
Sources combined:
1. Math Tables (stored metrics in GetStorage)
2. Sutras – aggregate from `EnhancedVedicCourseController.overallProgress` map
3. Tactics – iterate all lessons (100 points per completed lesson)
4. Practice – stored cumulative stats (`practice_total_*` keys)

Accuracy Calculation: `(totalCorrectAnswers / totalQuestionsAttempted) * 100`.

Refresh Pattern:
- After any practice or completion event call `globalProgress.refreshProgress()`.
- For large updates (batch), ensure storage keys are written first then refresh.

### 6.3 Adding New Point Sources
1. Decide a unique `section` label.
2. After awarding points: write any persistent counters you need.
3. Add a block to `calculateOverallProgress()` to fold new source into totals.
4. Add history entries for visibility & search.

---
## 7. History Search Architecture
- Controller: `HistoryController` holds `searchController`, `searchQuery`, `filtered`, `isSearching`.
- Search Implementation: Filters fields: `section`, `description`, `type`, numeric match for `points`.
- UI: `history_view.dart` conditionally shows grouped sections or filtered list.
- Extend: Add tags → update `ProgressHistoryEntry` & modify filter predicate.

---
## 8. Adding / Modifying Lessons & Chapters – Step-by-Step
1. Open `vedic_course_repository.dart` (or your source of truth for chapters). Add new `Chapter` definition.
2. Give sequential `chapterId`, and new lessons with unique `lessonId`.
3. Provide `practice: [PracticeQuestion(...)]` list per lesson.
4. If you want unlocking chain: ensure `isUnlocked` true for first lesson only; `completeLesson()` handles unlocking next.
5. Manual Points Override: Adjust `completeLesson()` awarding logic if different per lesson (e.g., vary based on difficulty).
6. Run app; navigate to course view; verify new chapter appears.
7. Complete lesson; check History screen for entry.

---
## 9. Adding / Completing Sutras Content – Step-by-Step
1. Edit `assets/data/16_SUTRAS_COMPLETE.json` – add new sutra object with required fields (`sutra_id`, `name`, `practice`, etc.).
2. Conform to existing minimal model expected by `SutraSimpleModel.fromJson` (fields: `sutraId`, `name`, `practice` problems list). If adding advanced fields they are ignored unless model extended.
3. Ensure app reload or hot restart so `loadSutrasFromJson()` re-parses.
4. Test in `Vedic16SutrasView` list; new sutra visible.
5. Navigate to interactive lesson (if implementing extra steps above) & practice; verify progress & auto-completion.

---
## 10. Practice Controllers Flow (Timers & Points)
Common Pattern (Sutras/Tactics):
- Load question list → shuffle → limit (20).
- Start per-question countdown (30s). On timeout: move on.
- Scoring: Base 10 + remaining seconds bonus.
- After final question: accuracy + total points saved to dedicated keys and aggregated to global totals + history entry.

To Add New Practice Mode:
1. Create `NewPracticeController` patterned after existing ones.
2. Provide binding to guarantee dependencies.
3. Add `GetPage` route and view.
4. On completion call `GlobalProgressController.addHistoryEntry()` with a unique section label.

---
## 11. XP, Badges, Streaks (Gamification)
Managed primarily by `EnhancedVedicCourseController`:
- `awardXP(xp)` updates `totalXP`, calculates level (`(totalXP / 500).floor() + 1`).
- Badges defined in `_initializeBadges()`; awarding via `_awardBadge()` triggers dialog + XP.
- Auto-complete sutras logic in `checkAndCompleteSutra()` conditions.
Extend Badges:
1. Add new `Badge` to `availableBadges` list.
2. Add eligibility case to `_checkBadgeEligibility()`.
3. Provide icon assets & consistent `badge_id`.

---
## 12. Dependency Injection & Lifecycle Best Practices
- Always register shared services (`TtsService`, `GlobalProgressController`) in the earliest sensible binding or via an App-wide initial binding (e.g., `initialRoute`).
- Avoid calling `Get.find()` in a controller constructor; use `onInit()` or lazy checks (e.g., `if (Get.isRegistered<Type>())`).
- Pattern for safe access (as used in `SettingsController` fix):
```dart
late AuthService _authService;
void _safeInitAuthService() {
  if (Get.isRegistered<AuthService>()) {
    _authService = Get.find<AuthService>();
  }
}
```
- If a controller depends on another that may not be ready (circular scenario), either:
  1. Use a binding to register dependency first.
  2. Defer usage until after `WidgetsBinding.instance.addPostFrameCallback`.

---
## 13. Common Pitfalls & Solutions
| Issue | Cause | Mitigation |
|-------|-------|------------|
| `Get.find<AuthService>()` throws | Service not registered yet | Use lazy init in `onInit()` with `Get.isRegistered` check |
| History not updating | Forgot to call `addHistoryEntry` or `refreshProgress()` | Always log event + refresh after point changes |
| New sutra not visible | JSON not reloaded | Hot restart or ensure `loadSutrasFromJson()` called once assets updated |
| Accuracy shows 0% | Missing stored question stats | Ensure per-practice controllers write cumulative keys before refresh |
| Duplicate lesson IDs | Non-unique `lessonId` in added lesson | Maintain unique IDs (consider a naming/numbering convention) |

---
## 14. Extending the System – Recommended Pattern
Feature Checklist (example: Add Algebra Practice):
1. Data: Create algebra problems list file.
2. Controller: `AlgebraPracticeController` (timer, scoring).
3. Binding: Registers new controller + any needed services.
4. Route: Add to `AppPages.pages` with unique constant.
5. View: Implement UI reusing practice keyboard.
6. History: On completion → `addHistoryEntry(section: 'Algebra Practice', type: 'practice')`.
7. Global Progress: Add aggregation block for algebra stats.
8. Tests: Add minimal widget or unit test to verify scoring logic (if test infra expanded).

---
## 15. Search Architecture (Home & History)
- Home multi-category search uses a category enum & collects results across lessons, sutras, etc. (controller not shown here but similar pattern).
- Extend by adding additional result builders and unify display model.
- History search directly filters stored entries enabling quick retrospective queries.

---
## 16. Performance & Scaling Notes
- Current repository methods are synchronous in-memory stubs; move to async Firestore or REST with caching for scale.
- Large sutra JSON: consider lazy loading per sutra to reduce upfront parsing time.
- History list growth: implement pruning (e.g., keep last N entries or archive older to remote storage).

---
## 17. Future Improvement Ideas
- Unified domain layer with repositories & service abstractions.
- Offline-first progress sync (queue unsent events, merge conflict resolution).
- Analytics event dispatcher referencing `analytics_events` spec in `vedic_16_sutras_complete.dart`.
- Advanced badge criteria (combo streaks, speed tiers).
- Unit & integration test coverage (timer logic, auto-completion, badge awarding).

---
## 18. Quick Reference Snippets
Add History Entry:
```dart
Get.find<GlobalProgressController>().addHistoryEntry(
  section: 'My Section',
  points: 250,
  description: 'Completed XYZ Challenge',
  type: 'challenge',
);
```
Mark Sutra Interactive Completed:
```dart
Get.find<EnhancedVedicCourseController>().markInteractiveCompleted(sutraId);
```
Unlock Next Lesson (already handled):
```dart
final index = chapter.lessons.indexOf(lesson);
if (index < chapter.lessons.length - 1) {
  chapter.lessons[index + 1].isUnlocked = true;
}
```
Award XP:
```dart
Get.find<EnhancedVedicCourseController>().awardXP(50);
```

---
## 19. Validation Checklist After Content Changes
Before committing new lessons or sutras:
- [ ] Unique IDs (chapters, lessons, sutras)
- [ ] Practice problems include answer + hint
- [ ] History entry triggers on completion
- [ ] Global progress reflects new points (test on Home screen)
- [ ] No runtime GetX lookup errors (watch console for `Get.find` issues)
- [ ] JSON syntax valid (use a linter or paste into validator)

---
## 20. Contact & Contribution
Use branching workflow for significant content extensions (`feature/add-sutra-5`). Provide test sutra content in JSON and verify through interactive view. PR should note any new section labels added to history.

---
Happy extending the Vedic Maths learning experience! 🚀
