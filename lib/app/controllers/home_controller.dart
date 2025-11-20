import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class HomeController extends GetxController {
  AuthService? _authService;
  final currentNavIndex = 1.obs; // Home is at index 1
  final userName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuthService();
    _loadUserName();
  }

  void _initAuthService() {
    try {
      _authService = Get.find<AuthService>();
    } catch (e) {
      // AuthService not available, will use default username
      print('AuthService not available: $e');
    }
  }

  Future<void> _loadUserName() async {
    if (_authService == null) return;
    
    try {
      final user = await _authService!.getCurrentUser();
      if (user != null) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          userName.value = user.displayName!;
        } else if (user.email.isNotEmpty) {
          // Extract name from email (remove @gmail.com or other domains)
          final emailName = user.email.split('@')[0];
          // Capitalize first letter
          userName.value = emailName[0].toUpperCase() + emailName.substring(1);
        }
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  void onNavTap(int index) {
    if (currentNavIndex.value == index) return; // Prevent navigation to same page
    
    currentNavIndex.value = index;
    
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.LEADERBOARD);
        break;
      case 1:
        // Already on home
        break;
      case 2:
        Get.offAllNamed(Routes.HISTORY);
        break;
    }
  }

  void showPracticeDialog() {
    Get.bottomSheet(
      _PracticeSetupSheet(),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}

class _PracticeSetupSheet extends StatelessWidget {
  final selectedOperation = 2.obs; // Default to multiplication
  final selectedTime = 1.obs; // Index of selected time
  final selectedTasks = 0.obs; // Index of selected tasks

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
    final operations = [
      {'symbol': '+', 'label': 'Addition'},
      {'symbol': '−', 'label': 'Subtraction'},
      {'symbol': '×', 'label': 'Multiplication'},
      {'symbol': '÷', 'label': 'Division'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

          // Title
          const Text(
            'Setup Practice Session',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),

          // Operation Selection
          const Text(
            'Select Operation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => _OperationChip(
                    symbol: operations[index]['symbol'] as String,
                    label: operations[index]['label'] as String,
                    isSelected: selectedOperation.value == index,
                    onTap: () => selectedOperation.value = index,
                  ),
                ),
              )),
          const SizedBox(height: 24),

          // Time Selection
          const Text(
            'Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

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
          const Text(
            'Number of Questions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

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
                    'operation': selectedOperation.value,
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
                'Cancel',
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

class _OperationChip extends StatelessWidget {
  final String symbol;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OperationChip({
    required this.symbol,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              symbol,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
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
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.black54,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
