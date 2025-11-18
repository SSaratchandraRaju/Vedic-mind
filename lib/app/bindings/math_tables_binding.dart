import 'package:get/get.dart';
import '../controllers/math_tables_controller.dart';

class MathTablesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MathTablesController>(() => MathTablesController());
  }
}
