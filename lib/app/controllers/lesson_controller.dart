import 'package:get/get.dart';
import '../data/models/lesson_model.dart';
import '../data/repositories/lesson_repository.dart';

class LessonController extends GetxController {
  final lessons = <LessonModel>[].obs;
  final isLoading = false.obs;
  final LessonRepository _repo = LessonRepository();

  @override
  void onInit() {
    super.onInit();
    fetchLessons();
  }

  void fetchLessons() async {
    isLoading.value = true;
    lessons.value = await _repo.getAllLessons();
    isLoading.value = false;
  }
}
