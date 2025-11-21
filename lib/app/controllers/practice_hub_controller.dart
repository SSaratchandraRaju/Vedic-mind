import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';

class PracticeHubController extends GetxController {
  final storage = GetStorage();
  final currentNavIndex = 1.obs; // Practice hub, but using home nav index

  // Progress tracking
  final completedSessions = 0.obs;
  final totalSessions = 100.obs; // Arbitrary total
  final accuracy = 0.obs;
  final totalPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProgress();
  }

  void _loadProgress() {
    // Load practice stats from storage - combining all practice types

    // Sutras practice
    final sutrasPoints = storage.read<int>('practice_sutras_points') ?? 0;
    final sutrasQuestions = storage.read<int>('practice_sutras_questions') ?? 0;
    final sutrasCorrect = storage.read<int>('practice_sutras_correct') ?? 0;

    // Tactics practice
    final tacticsPoints = storage.read<int>('practice_tactics_points') ?? 0;
    final tacticsQuestions =
        storage.read<int>('practice_tactics_questions') ?? 0;
    final tacticsCorrect = storage.read<int>('practice_tactics_correct') ?? 0;

    // Math tables
    final mathTablesPoints = storage.read<int>('math_tables_points') ?? 0;
    final mathTablesQuestions =
        storage.read<int>('math_tables_total_questions') ?? 0;
    final mathTablesCorrect =
        storage.read<int>('math_tables_correct_answers') ?? 0;

    // Arithmetic practice (if exists)
    final arithmeticPoints =
        storage.read<int>('arithmetic_practice_points') ?? 0;
    final arithmeticQuestions =
        storage.read<int>('arithmetic_practice_questions') ?? 0;
    final arithmeticCorrect =
        storage.read<int>('arithmetic_practice_correct') ?? 0;

    // Total all practice types
    final totalPracticePoints =
        sutrasPoints + tacticsPoints + mathTablesPoints + arithmeticPoints;
    final totalPracticeQuestions =
        sutrasQuestions +
        tacticsQuestions +
        mathTablesQuestions +
        arithmeticQuestions;
    final totalPracticeCorrect =
        sutrasCorrect + tacticsCorrect + mathTablesCorrect + arithmeticCorrect;

    totalPoints.value = totalPracticePoints;
    completedSessions.value = totalPracticeQuestions > 0
        ? (totalPracticeQuestions / 20).ceil()
        : 0;

    if (totalPracticeQuestions > 0) {
      accuracy.value = ((totalPracticeCorrect / totalPracticeQuestions) * 100)
          .round();
    } else {
      accuracy.value = 0;
    }

    print(
      'Practice Hub Progress: Points=$totalPracticePoints, Questions=$totalPracticeQuestions, Accuracy=${accuracy.value}%',
    );
  }

  void navigateToTables() {
    Get.toNamed(Routes.PRACTICE_ARITHMETIC_SETUP);
  }

  void navigateToSutraQuestions() {
    Get.toNamed(Routes.PRACTICE_SUTRAS);
  }

  void navigateToTacticsQuestions() {
    Get.toNamed(Routes.PRACTICE_TACTICS);
  }

  void navigateToGames() {
    Get.toNamed(Routes.PRACTICE_GAMES);
  }

  void onNavTap(int index) {
    if (currentNavIndex.value == index) return;

    currentNavIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed(Routes.LEADERBOARD);
        break;
      case 1:
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        Get.offAllNamed(Routes.HISTORY);
        break;
    }
  }
}
