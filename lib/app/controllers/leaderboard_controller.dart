import 'package:get/get.dart';
import '../routes/app_routes.dart';

class LeaderboardController extends GetxController {
  final selectedTab = 0.obs; // 0 = This Week, 1 = This Month
  final currentNavIndex = 0.obs; // Leaderboard is at index 0

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void onNavTap(int index) {
    if (currentNavIndex.value == index)
      return; // Prevent navigation to same page

    currentNavIndex.value = index;

    switch (index) {
      case 0:
        // Already on leaderboard
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
