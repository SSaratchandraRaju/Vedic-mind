import 'package:get/get.dart';
import '../controllers/math_tables_test_controller.dart';

class MathTablesTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MathTablesTestController>(() => MathTablesTestController());
  }
}
