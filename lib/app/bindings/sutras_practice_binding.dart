import 'package:get/get.dart';
import '../controllers/sutras_practice_controller.dart';
import '../controllers/enhanced_vedic_course_controller.dart';
import '../services/tts_service.dart';

class SutrasPracticeBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure TtsService is available (required by EnhancedVedicCourseController)
    if (!Get.isRegistered<TtsService>()) {
      Get.lazyPut<TtsService>(() => TtsService());
    }

    // Ensure EnhancedVedicCourseController is available
    if (!Get.isRegistered<EnhancedVedicCourseController>()) {
      Get.lazyPut<EnhancedVedicCourseController>(
        () => EnhancedVedicCourseController(),
      );
    }

    Get.lazyPut<SutrasPracticeController>(() => SutrasPracticeController());
  }
}
