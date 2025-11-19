import 'package:get/get.dart';
import '../controllers/vedic_course_controller.dart';

class VedicCourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VedicCourseController>(() => VedicCourseController());
  }
}
