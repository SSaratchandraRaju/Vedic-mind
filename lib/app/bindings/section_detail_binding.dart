import 'package:get/get.dart';
import '../controllers/section_detail_controller.dart';

class SectionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SectionDetailController>(() => SectionDetailController());
  }
}
