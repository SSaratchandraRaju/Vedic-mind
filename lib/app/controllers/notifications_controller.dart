import 'package:get/get.dart';
import '../routes/app_routes.dart';

class NotificationsController extends GetxController {
  final currentNavIndex = 2.obs; // History tab index

  void onNavTap(int index) {
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
