import 'package:flutter/material.dart';
import 'dart:ui' show FontFeature; // For tabular figures (monospaced digits)
import 'package:get/get.dart';
import '../../controllers/section_detail_controller.dart';
import '../../controllers/math_tables_controller.dart';
import '../../routes/app_routes.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/bottom_nav_bar.dart';
import '../../ui/widgets/number_selector.dart';

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
          return Text('$startNum-$endNum', style: AppTextStyles.h5);
        }),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // White Container with Number Grid
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
                        // Number selector row - show numbers from current section
                        Obx(() {
                          final sectionIndex = getSectionIndex(
                            controller.selectedNumber.value,
                          );
                          final startNum = sectionIndex * 5 + 1;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (index) {
                              final num = startNum + index;
                              return NumberSelector(
                                number: num.toString(),
                                isSelected:
                                    controller.selectedNumber.value == num,
                                onTap: () => controller.selectNumber(num),
                              );
                            }),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Table Container
                  Obx(() {
                    final operation = '×';

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
                              'Here is ${controller.selectedNumber.value} Table',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          // White Table Section
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Left column (1-10)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                  ),
                                  // Right column (11-20)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                  const SizedBox(height: 20),

                  // Start Test Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final sectionIndex = getSectionIndex(
                          controller.selectedNumber.value,
                        );
                        final startNum = sectionIndex * 5 + 1;
                        final endNum = startNum + 4;
                        // If section already completed, show alert that retake won't affect score/accuracy
                        final mtController = Get.find<MathTablesController>();
                        bool isRetake = false;
                        if (mtController.isSectionCompleted(sectionIndex)) {
                          final proceed = await Get.dialog<bool>(
                                AlertDialog(
                                  title: const Text('Retake Completed Section'),
                                  content: const Text(
                                    'You have already completed this section. Retaking will not change your score or accuracy.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Get.back(result: true),
                                      child: const Text('Proceed'),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;
                          if (!proceed) return;
                          isRetake = true;
                        }

                        Get.toNamed(
                          Routes.MATH_TABLES_TEST,
                          arguments: {
                            'section': sectionIndex,
                            'startNumber': startNum,
                            'endNumber': endNum,
                            'retake': isRetake,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Test',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => BottomNavBar(
              currentIndex: controller.currentNavIndex.value,
              onTap: controller.onNavTap,
            ),
          ),
        ],
      ),
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

    // Ensure consistent, aligned single-line layout across all equations.
    const double gap = 10.0; // spacing between cells
    const double baseCellWidth = 48.0; // up to 3 digits (1..100)
    const double operandCellWidth = 40.0; // up to 2 digits (1..20)
    // Result can be up to 4 digits for multiplication (2000), and more for division with decimals.
    final double resultCellWidth = operation == '÷' ? 88.0 : 68.0;
    const double symbolCellWidth = 18.0; // for single character symbols like × and =

    final baseTextStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.0,
      fontFamily: 'Poppins',
      // Use tabular figures so digits take equal width and align nicely.
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    final symbolTextStyle = TextStyle(
      color: AppColors.textSecondary.withOpacity(0.5),
      fontSize: 20,
      fontWeight: FontWeight.w300,
      height: 1.0,
      fontFamily: 'Poppins',
    );

    final resultTextStyle = baseTextStyle.copyWith(fontWeight: FontWeight.w600);

  final String resultText = operation == '÷'
    ? (result is int ? result.toString() : result.toStringAsFixed(2))
    : '${result.toInt()}';

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: baseCellWidth,
            child: Text(
              '$baseNumber',
              textAlign: TextAlign.right,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: baseTextStyle,
            ),
          ),
          const SizedBox(width: gap),
          SizedBox(
            width: symbolCellWidth,
            child: Text(
              operatorSymbol,
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: symbolTextStyle,
            ),
          ),
          const SizedBox(width: gap),
          SizedBox(
            width: operandCellWidth,
            child: Text(
              '$operand',
              textAlign: TextAlign.right,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: baseTextStyle,
            ),
          ),
          const SizedBox(width: gap),
          SizedBox(
            width: symbolCellWidth,
            child: Text(
              '=',
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: symbolTextStyle,
            ),
          ),
          const SizedBox(width: gap),
          SizedBox(
            width: resultCellWidth,
            child: Text(
              resultText,
              textAlign: TextAlign.right,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: resultTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
