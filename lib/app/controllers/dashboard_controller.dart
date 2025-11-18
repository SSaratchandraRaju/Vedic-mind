import 'package:get/get.dart';
import '../data/models/lesson_model.dart';
import '../data/repositories/lesson_repository.dart';

class DashboardController extends GetxController {
  final lessons = <LessonModel>[].obs;
  final isLoading = false.obs;
  final LessonRepository _repo = LessonRepository();

  // Observable for selected operation in dashboard
  final selectedOperation = 0.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() async {
    isLoading.value = true;
    lessons.value = await _repo.getAllLessons();
    isLoading.value = false;
  }
}
