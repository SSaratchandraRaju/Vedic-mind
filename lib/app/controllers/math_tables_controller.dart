import 'package:get/get.dart';
import '../routes/app_routes.dart';

class MathTablesController extends GetxController {
  final selectedOperation = 2.obs; // Default to × (multiplication)
  final selectedSection = 0.obs;
  final selectedNumber = 2.obs;
  final currentNavIndex = 1.obs;

  void selectOperation(int index) {
    selectedOperation.value = index;
  }

  void selectSection(int index) {
    selectedSection.value = index;
    // Auto select first number of section
    selectedNumber.value = index * 5 + 1;
  }

  void selectNumber(int number) {
    selectedNumber.value = number;
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;
    
    switch (index) {
      case 0:
        Get.toNamed(Routes.LEADERBOARD);
        break;
      case 1:
        Get.toNamed(Routes.HOME);
        break;
      case 2:
        Get.toNamed(Routes.HISTORY);
        break;
    }
  }
}
