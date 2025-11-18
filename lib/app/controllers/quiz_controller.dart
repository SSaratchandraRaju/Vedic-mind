import 'package:get/get.dart';
import '../data/models/quiz_model.dart';

class QuizController extends GetxController {
  final questions = <QuizModel>[].obs;
  final currentIndex = 0.obs;
  final isRunning = false.obs;

  void startQuiz() {
    isRunning.value = true;
    currentIndex.value = 0;
  }

  void stopQuiz() {
    isRunning.value = false;
  }
}
