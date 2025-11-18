import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/section_detail_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/number_selector.dart';

class SectionDetailView extends GetView<SectionDetailController> {
  const SectionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate section and range based on selected number
    int getSectionIndex(int number) {
      return ((number - 1) / 5).floor();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final sectionIndex = getSectionIndex(controller.selectedNumber.value);
          final startNum = sectionIndex * 5 + 1;
          final endNum = startNum + 4;
          return Text(
            '$startNum-$endNum',
            style: AppTextStyles.h5,
          );
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        final operations = ['+', '−', '×', '÷'];
        final operationLabels = ['Addition', 'Subtraction', 'Multiplication', 'Division'];
        final operation = operations[controller.operationIndex.value];
        final operationLabel = operationLabels[controller.operationIndex.value];

        return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // White Container with Operation Selector and Number Grid
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Operation Selector Row with Grey Background
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5), // Light grey background
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'You can change operation',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              // Show operation buttons on the right
                              // White container for × and ÷ operations
                              if (controller.operationIndex.value > 1)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.changeOperation(2); // Switch to ×
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: controller.operationIndex.value == 2 
                                                ? AppColors.primary 
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: controller.operationIndex.value == 2 
                                                ? Colors.white 
                                                : AppColors.textSecondary,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          controller.changeOperation(3); // Switch to ÷
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: controller.operationIndex.value == 3 
                                                ? AppColors.primary 
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.percent,
                                            color: controller.operationIndex.value == 3 
                                                ? Colors.white 
                                                : AppColors.textSecondary,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                // For + and − operations, show single button
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        operation == '+' ? Icons.add : Icons.remove,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Show all operation buttons for × and ÷ (removed - not needed based on screenshot)
                        // Number selector row - show numbers from current section
                        Obx(() {
                          final sectionIndex = getSectionIndex(controller.selectedNumber.value);
                          final startNum = sectionIndex * 5 + 1;
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              5,
                              (index) {
                                final num = startNum + index;
                                return NumberSelector(
                                  number: num.toString(),
                                  isSelected: controller.selectedNumber.value == num,
                                  onTap: () => controller.selectNumber(num),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Table Container
                  Obx(() {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Blue Title Section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Here is your  $operationLabel Operation with ${controller.selectedNumber.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          // White Table Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Left column (1-10)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(10, (rowIndex) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: rowIndex < 9 ? 18 : 0,
                                          ),
                                          child: _buildEquation(
                                            controller.selectedNumber.value,
                                            rowIndex + 1,
                                            operation,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  // Full-height divider
                                  Container(
                                    width: 1,
                                    color: AppColors.border,
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  // Right column (11-20)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(10, (rowIndex) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: rowIndex < 9 ? 18 : 0,
                                          ),
                                          child: _buildEquation(
                                            controller.selectedNumber.value,
                                            rowIndex + 11,
                                            operation,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Obx(() => BottomNavBar(
                currentIndex: controller.currentNavIndex.value,
                onTap: controller.onNavTap,
              )),
        ],
      );
      })
    );
  }

  Widget _buildEquation(int baseNumber, int operand, String operation) {
    num result;
    String operatorSymbol;

    switch (operation) {
      case '+':
        result = baseNumber + operand;
        operatorSymbol = '+';
        break;
      case '−':
        result = baseNumber - operand;
        operatorSymbol = '−';
        break;
      case '×':
        result = baseNumber * operand;
        operatorSymbol = '×';
        break;
      case '÷':
        result = baseNumber / operand;
        operatorSymbol = '÷';
        break;
      default:
        result = baseNumber * operand;
        operatorSymbol = '×';
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.0,
          // letterSpacing: 0.2,
        ),
        children: [
          TextSpan(
            text: '$baseNumber',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(
            text: '  ',
          ),
          TextSpan(
            text: '$operatorSymbol',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontWeight: FontWeight.w300,
            ),
          ),
          const TextSpan(
            text: '  ',
          ),
          TextSpan(
            text: '$operand',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(
            text: '  ',
          ),
          TextSpan(
            text: '=',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontWeight: FontWeight.w300,
            ),
          ),
          const TextSpan(
            text: '  ',
          ),
          TextSpan(
            text: operation == '÷' ? result.toStringAsFixed(2) : '${result.toInt()}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
