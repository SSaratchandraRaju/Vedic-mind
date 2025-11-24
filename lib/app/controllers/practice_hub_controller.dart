import 'package:get/get.dart';
import '../routes/app_routes.dart';

class PracticeHubController extends GetxController {
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

  // Removed local storage aggregation; values provided elsewhere or via Firestore in other views.
  totalPoints.value = 0;
  completedSessions.value = 0;
  accuracy.value = 0;
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
