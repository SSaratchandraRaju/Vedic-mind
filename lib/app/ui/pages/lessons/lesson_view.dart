import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/lesson_controller.dart';

class LessonView extends GetView<LessonController> {
  const LessonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: const Center(child: Text('Lessons will appear here')),
    );
  }
}
