import 'package:get/get.dart';
import '../controllers/practice_hub_controller.dart';

class PracticeHubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PracticeHubController>(() => PracticeHubController());
  }
}
