import 'package:get/get.dart';
import '../controllers/tactics_practice_controller.dart';
import '../controllers/vedic_course_controller.dart';
import '../controllers/global_progress_controller.dart';

class TacticsPracticeBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure GlobalProgressController is available (may be needed by VedicCourseController)
    if (!Get.isRegistered<GlobalProgressController>()) {
      Get.lazyPut<GlobalProgressController>(() => GlobalProgressController());
    }

    // Ensure VedicCourseController is available
    if (!Get.isRegistered<VedicCourseController>()) {
      Get.lazyPut<VedicCourseController>(() => VedicCourseController());
    }

    Get.lazyPut<TacticsPracticeController>(() => TacticsPracticeController());
  }
}
