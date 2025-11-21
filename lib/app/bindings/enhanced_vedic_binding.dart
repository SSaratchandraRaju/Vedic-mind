import 'package:get/get.dart';
import '../controllers/enhanced_vedic_course_controller.dart';
import '../services/tts_service.dart';

class EnhancedVedicBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure TTS service is available
    if (!Get.isRegistered<TtsService>()) {
      Get.lazyPut<TtsService>(() => TtsService());
    }

    // Register the enhanced controller
    Get.lazyPut<EnhancedVedicCourseController>(
      () => EnhancedVedicCourseController(),
    );
  }
}
