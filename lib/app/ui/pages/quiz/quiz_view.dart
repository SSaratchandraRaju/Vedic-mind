import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: const Center(child: Text('Quiz UI placeholder')),
    );
  }
}
