import 'dart:math';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class ArithmeticPracticeController extends GetxController {
  // Selected operations (can be multiple)
  final selectedOperations = <int>[].obs;
  
  // Selected tasks and time indices
  // Defaults: 5 questions (index 0) and 0:45 time (index 0)
  final selectedTasksIndex = 0.obs;
  final selectedTimeIndex = 0.obs;

  final tasks = [5, 10, 20, 30, 50];
  final timeOptions = [0.75, 1.5, 3.0, 5.0]; // In minutes

  // Enable start only when all three selections are made
  bool get canStart =>
      selectedOperations.isNotEmpty &&
      selectedTasksIndex.value >= 0 &&
      selectedTimeIndex.value >= 0;

  void toggleOperation(int index) {
    if (selectedOperations.contains(index)) {
      selectedOperations.remove(index);
    } else {
      selectedOperations.add(index);
    }
  }

  void startPractice() {
    // Validate that all required selections have been made
    if (selectedOperations.isEmpty) {
      Get.snackbar(
        'Select Operations',
        'Please select at least one operation to practice',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedTasksIndex.value < 0) {
      Get.snackbar(
        'Select Questions',
        'Please choose the number of questions',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedTimeIndex.value < 0) {
      Get.snackbar(
        'Select Time Limit',
        'Please choose a time limit',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Pick a random operation from selected ones
    final randomIndex = Random().nextInt(selectedOperations.length);
    final operation = selectedOperations[randomIndex];

    Get.toNamed(
      Routes.PRACTICE,
      arguments: {
        'operation': operation,
        'tasks': tasks[selectedTasksIndex.value],
        'timePerQuestion': 10, // 10 seconds per question
        'totlTime': timeOptions[selectedTimeIndex.value].round(),
        'selectedOperations': selectedOperations.toList(), // Pass all selected
      },
    );
  }
}
