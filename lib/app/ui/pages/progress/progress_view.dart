import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/progress_controller.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: const Center(child: Text('Progress tracker placeholder')),
    );
  }
}
