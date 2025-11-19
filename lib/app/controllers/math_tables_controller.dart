import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class MathTablesController extends GetxController {
  final selectedOperation = 2.obs; // Default to × (multiplication)
  final selectedSection = 0.obs;
  final selectedNumber = 2.obs;
  final currentNavIndex = 1.obs;

  void selectOperation(int index) {
    selectedOperation.value = index;
  }

  void selectSection(int index) {
    selectedSection.value = index;
    // Auto select first number of section
    selectedNumber.value = index * 5 + 1;
  }

  void selectNumber(int number) {
    selectedNumber.value = number;
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;
    
    switch (index) {
      case 0:
        Get.toNamed(Routes.LEADERBOARD);
        break;
      case 1:
        Get.toNamed(Routes.HOME);
        break;
      case 2:
        Get.toNamed(Routes.HISTORY);
        break;
    }
  }

  void showPracticeDialog() {
    Get.bottomSheet(
      _PracticeSetupSheet(),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}

class _PracticeSetupSheet extends StatelessWidget {
  final selectedTime = 1.obs; // Index of selected time
  final selectedTasks = 0.obs; // Index of selected tasks
  final controller = Get.find<MathTablesController>();

  _PracticeSetupSheet();

  @override
  Widget build(BuildContext context) {
    // Time options in minutes
    final timeOptions = [
      {'label': '0:45', 'minutes': 0.75}, // 45 seconds
      {'label': '1:30', 'minutes': 1.5},  // 1.5 minutes
      {'label': '3:00', 'minutes': 3.0},  // 3 minutes
      {'label': '5:00', 'minutes': 5.0},  // 5 minutes
    ];
    final tasks = [5, 10, 20, 30, 50];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Time Selection
          Row(
            children: [
              const Text(
                'Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 16),

          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => _TimeChip(
                    label: timeOptions[index]['label'] as String,
                    isSelected: selectedTime.value == index,
                    onTap: () => selectedTime.value = index,
                  ),
                ),
              )),
          const SizedBox(height: 24),

          // Tasks Selection
          Row(
            children: [
              const Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.lock_outline, size: 16, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 16),

          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (index) => _TaskChip(
                    number: tasks[index],
                    isSelected: selectedTasks.value == index,
                    onTap: () => selectedTasks.value = index,
                  ),
                ),
              )),
          const SizedBox(height: 32),

          // Start Practice Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed(
                  Routes.PRACTICE,
                  arguments: {
                    'operation': controller.selectedOperation.value,
                    'tasks': tasks[selectedTasks.value],
                    'totalMinutes': timeOptions[selectedTime.value]['minutes'],
                    'timePerQuestion': 10, // 10 seconds per question
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B7FFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Practice',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Go Back Button
          Center(
            child: TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Go Back',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class _TaskChip extends StatelessWidget {
  final int number;
  final bool isSelected;
  final VoidCallback onTap;

  const _TaskChip({
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              number.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black54,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
