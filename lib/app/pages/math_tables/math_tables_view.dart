import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/math_tables_controller.dart';
import '../../routes/app_routes.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/bottom_nav_bar.dart';
import '../../ui/widgets/section_chip.dart';
import '../../ui/widgets/number_selector.dart';
import '../../ui/widgets/progress_section.dart';

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
        title:  Text('Math Tables', style: AppTextStyles.h5),
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
                  // Multiplication Tables Title
                  Text('Multiplication Tables', style: AppTextStyles.h5),
                  const SizedBox(height: 32),

                  // Progress Section - Common Widget
                  Obx(() {
                    final completedSections = controller.completedSections.length;
                    final totalSections = MathTablesController.totalSections;
                    final accuracy = controller.accuracy.round();
                    final points = controller.totalPoints.value;

                    return ProgressSection(
                      completedCount: completedSections,
                      totalCount: totalSections,
                      accuracy: accuracy,
                      totalPoints: points,
                    );
                  }),


                  // Select Section
                  Text('Select Section', style: AppTextStyles.h5),
                  const SizedBox(height: 8),
                  Text(
                    'Complete each section to unlock the next one',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Section Chips
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          MathTablesController.totalSections,
                          (index) {
                            final startNum = index * 5 + 1;
                            final endNum = startNum + 4;
                            final isLocked = !controller.isSectionUnlocked(
                              index,
                            );
                            final isCompleted = controller.isSectionCompleted(
                              index,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SectionChip(
                                label: '$startNum-$endNum',
                                isSelected:
                                    controller.selectedSection.value == index,
                                isLocked: isLocked,
                                isCompleted: isCompleted,
                                onTap: () => controller.selectSection(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Progress Section
                  
                  // Select number text
                  Text(
                    'Select a number to view its table or start the test',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Number Grid (1-5 for current section)
                  Obx(() {
                    final startNum = controller.selectedSection.value * 5 + 1;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final num = startNum + index;
                        return NumberSelector(
                          number: num.toString(),
                          isSelected: controller.selectedNumber.value == num,
                          onTap: () {
                            controller.selectNumber(num);
                            // Navigate to table view when number is tapped
                            Get.toNamed(
                              Routes.SECTION_DETAIL,
                              arguments: {
                                'number': num,
                                'operation': 2, // Multiplication
                              },
                            );
                          },
                        );
                      }),
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
                // Start Test Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final section = controller.selectedSection.value;
                      final startNum = section * 5 + 1;
                      final endNum = section * 5 + 5;
                      bool isRetake = false;
                      if (controller.isSectionCompleted(section)) {
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
                          'section': section,
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
}
