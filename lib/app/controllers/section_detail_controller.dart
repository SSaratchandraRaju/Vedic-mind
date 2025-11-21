import 'package:get/get.dart';
import '../routes/app_routes.dart';

class SectionDetailController extends GetxController {
  final currentNavIndex = 1.obs;
  final selectedNumber = 2.obs;
  final operationIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final number = args?['number'] ?? 2;
    final operation = args?['operation'] ?? 0;

    selectedNumber.value = number;
    operationIndex.value = operation;
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

  void selectNumber(int number) {
    selectedNumber.value = number;
  }

  void changeOperation(int index) {
    operationIndex.value = index;
  }
}
