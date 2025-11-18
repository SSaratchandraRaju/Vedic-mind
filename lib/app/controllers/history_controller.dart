import 'package:get/get.dart';
import '../routes/app_routes.dart';

class HistoryController extends GetxController {
  final currentNavIndex = 2.obs; // History is at index 2

  void onNavTap(int index) {
    if (currentNavIndex.value == index) return; // Prevent navigation to same page
    
    currentNavIndex.value = index;
    
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.LEADERBOARD);
        break;
      case 1:
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        // Already on history
        break;
    }
  }
}
