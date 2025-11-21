import 'package:get/get.dart';
import '../controllers/arithmetic_practice_controller.dart';

class ArithmeticPracticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArithmeticPracticeController>(() => ArithmeticPracticeController());
  }
}
