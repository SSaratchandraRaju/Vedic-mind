import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/arithmetic_practice_controller.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';

class ArithmeticSetupView extends GetView<ArithmeticPracticeController> {
  const ArithmeticSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title:  Text('Arithmetic Practice', style: AppTextStyles.h5),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operations Selection
            const Text(
              'Select Operations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You can select multiple operations',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),

            // Operations Grid
            Obx(() => Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                _buildOperatorChip('+', 'Addition', 0),
                _buildOperatorChip('−', 'Subtraction', 1),
                _buildOperatorChip('×', 'Multiplication', 2),
                _buildOperatorChip('÷', 'Division', 3),
              ],
            )),

            const SizedBox(height: 32),

            // Number of Tasks
            const Text(
              'Number of Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [5, 10, 20, 30, 50]
                  .asMap()
                  .entries
                  .map((entry) => _buildNumberChip(
                        entry.value.toString(),
                        entry.key,
                      ))
                  .toList(),
            )),

            const SizedBox(height: 32),

            // Time Limit
            const Text(
              'Time Limit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildTimeChip('0:45', 0, 0.75),
                _buildTimeChip('1:30', 1, 1.5),
                _buildTimeChip('3:00', 2, 3.0),
                _buildTimeChip('5:00', 3, 5.0),
              ],
            )),

            const SizedBox(height: 40),

            // Start Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.canStart
                        ? () => controller.startPractice()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey[300],
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
                )),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorChip(String symbol, String label, int index) {
    final isSelected = controller.selectedOperations.contains(index);

    return InkWell(
      onTap: () => controller.toggleOperation(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              symbol,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberChip(String label, int index) {
    final isSelected = controller.selectedTasksIndex.value == index;

    return InkWell(
      onTap: () => controller.selectedTasksIndex.value = index,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, int index, double minutes) {
    final isSelected = controller.selectedTimeIndex.value == index;

    return InkWell(
      onTap: () => controller.selectedTimeIndex.value = index,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
