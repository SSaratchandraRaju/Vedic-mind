import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/math_tables_controller.dart';
import '../../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/operation_button.dart';
import '../../widgets/section_chip.dart';
import '../../widgets/number_selector.dart';

class MathTablesView extends GetView<MathTablesController> {
  const MathTablesView({super.key});

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
        title: const Text(
          'Math Tables',
          style: AppTextStyles.h5,
        ),
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
                  // Select Operations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Operations',
                        style: AppTextStyles.h5,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Know More',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Operation Buttons
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: OperationButton(
                              symbol: '+',
                              label: '',
                              isSelected: controller.selectedOperation.value == 0,
                              onTap: () => controller.selectOperation(0),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OperationButton(
                              symbol: '−',
                              label: '',
                              isSelected: controller.selectedOperation.value == 1,
                              onTap: () => controller.selectOperation(1),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OperationButton(
                              symbol: '×',
                              label: '',
                              isSelected: controller.selectedOperation.value == 2,
                              onTap: () => controller.selectOperation(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OperationButton(
                              symbol: '÷',
                              label: '',
                              isSelected: controller.selectedOperation.value == 3,
                              onTap: () => controller.selectOperation(3),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 32),

                  // Select Section
                  Text(
                    'Select Section',
                    style: AppTextStyles.h5,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'In every section they are 5 tables are present',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Section Chips
                  Obx(() => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            5,
                            (index) {
                              final startNum = index * 5 + 1;
                              final endNum = startNum + 4;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SectionChip(
                                  label: '$startNum-$endNum',
                                  isSelected: controller.selectedSection.value == index,
                                  onTap: () => controller.selectSection(index),
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                  const SizedBox(height: 24),

                  // Select number text
                  Text(
                    'Select any one of the number',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Number Grid (1-5 for current section)
                  Obx(() {
                    final startNum = controller.selectedSection.value * 5 + 1;
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Fixed button container above nav bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Learn Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(
                      Routes.SECTION_DETAIL,
                      arguments: {
                        'number': controller.selectedNumber.value,
                        'operation': controller.selectedOperation.value,
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Learn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Obx(() => BottomNavBar(
                currentIndex: controller.currentNavIndex.value,
                onTap: controller.onNavTap,
              )),
        ],
      ),
    );
  }
}
