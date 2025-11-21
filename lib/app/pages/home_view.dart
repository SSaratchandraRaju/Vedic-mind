import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../routes/app_routes.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/bottom_nav_bar.dart';
import '../ui/widgets/method_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.SETTINGS),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  'Hi, ${controller.userName.value}!',
                                  style: AppTextStyles.h4,
                                ),
                              ),
                              Text(
                                'Lets start learning over all maths...',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            Get.toNamed(Routes.NOTIFICATIONS);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search Bar
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Obx(
                            () => InkWell(
                              onTap: controller.showCategorySelector,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.selectedCategory.value ==
                                              SearchCategory.all
                                          ? 'All'
                                          : controller
                                                .getCategoryName(
                                                  controller
                                                      .selectedCategory
                                                      .value,
                                                )
                                                .split(' ')[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              onChanged: controller.performSearch,
                              decoration: InputDecoration(
                                hintText: 'Search for sutras, tactics...',
                                hintStyle: TextStyle(
                                  color: AppColors.gray400,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (controller.searchController.text.isNotEmpty) {
                                controller.performSearch(
                                  controller.searchController.text,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Search Results
                    Obx(() {
                      if (controller.isSearching.value &&
                          controller.searchResults.isNotEmpty) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${controller.searchResults.length} Results',
                                          style: AppTextStyles.h5.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.searchController.clear();
                                            controller.searchQuery.value = '';
                                            controller.searchResults.clear();
                                            controller.isSearching.value =
                                                false;
                                          },
                                          child: const Text('Clear'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        controller.searchResults.length > 5
                                        ? 5
                                        : controller.searchResults.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final result =
                                          controller.searchResults[index];
                                      return ListTile(
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _getResultColor(
                                              result.category,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            _getResultIcon(result.category),
                                            color: _getResultColor(
                                              result.category,
                                            ),
                                            size: 20,
                                          ),
                                        ),
                                        title: Text(
                                          result.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        subtitle: Text(
                                          result.subtitle,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getResultColor(
                                              result.category,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            result.category,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: _getResultColor(
                                                result.category,
                                              ),
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        onTap: () => controller
                                            .navigateToSearchResult(result),
                                      );
                                    },
                                  ),
                                  if (controller.searchResults.length > 5)
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(
                                          '+${controller.searchResults.length - 5} more results',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (controller.isSearching.value &&
                          controller.searchResults.isEmpty) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: AppColors.gray400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No results found',
                                    style: AppTextStyles.h5.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Try different keywords or category',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: 24),

                    // Overall Score - Dynamic from GlobalProgressController
                    Obx(() {
                      final accuracy = controller
                          .globalProgressController
                          .overallAccuracy
                          .value;
                      final points =
                          controller.globalProgressController.totalPoints.value;
                      final questionsAttempted = controller
                          .globalProgressController
                          .totalQuestionsAttempted
                          .value;

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Overall Performance',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Discovering Mathematics',
                                        style: AppTextStyles.h5,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        questionsAttempted > 0
                                            ? 'Keep up the great work!'
                                            : 'Start your journey!',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: CircularProgressIndicator(
                                        value: accuracy / 100,
                                        strokeWidth: 8,
                                        backgroundColor: AppColors.gray100,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              accuracy >= 80
                                                  ? const Color(0xFF4CAF50)
                                                  : accuracy >= 60
                                                  ? AppColors.yellow
                                                  : const Color(0xFFFF9800),
                                            ),
                                      ),
                                    ),
                                    Text(
                                      '${accuracy.toStringAsFixed(0)}%',
                                      style: AppTextStyles.h4.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Stats Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    icon: Icons.emoji_events,
                                    label: 'Total Points',
                                    value: points.toString(),
                                    color: const Color(0xFFFF9800),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: AppColors.border,
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    icon: Icons.quiz_outlined,
                                    label: 'Questions',
                                    value: questionsAttempted.toString(),
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Popular Methods
                    Text('Popular methods', style: AppTextStyles.h5),
                    const SizedBox(height: 16),

                    Obx(
                      () => MethodCard(
                        icon: Icons.calculate_outlined,
                        iconColor: AppColors.primary,
                        title: 'Maths Tables',
                        subtitle: 'Practice multiplication tables',
                        badge: controller.mathTablesAccuracy.value > 0
                            ? '${controller.mathTablesAccuracy.value}%'
                            : 'Start',
                        points: controller.mathTablesPoints.value,
                        onTap: () => Get.toNamed(Routes.MATH_TABLES),
                      ),
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.VEDIC_METHODS),
                      onLongPress: () => Get.toNamed(Routes.VEDIC_COURSE),
                      child: Obx(
                        () => MethodCard(
                          icon: Icons.auto_awesome,
                          iconColor: AppColors.pink,
                          title: 'Vedic Tactics',
                            subtitle: 'Master vedic math techniques',
                          badge: controller.tacticsAccuracy.value > 0
                              ? '${controller.tacticsAccuracy.value}%'
                              : 'Start',
                          points: controller.tacticsPoints.value,
                          onTap: () => Get.toNamed(Routes.ALL_LESSONS),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Obx(
                      () => MethodCard(
                        icon: Icons.psychology_outlined,
                        iconColor: AppColors.secondary,
                        title: 'Vedic Sutras',
                        subtitle: '16 Sutras for Faster, Smarter Calculation.',
                        badge: controller.sutrasAccuracy.value > 0
                            ? '${controller.sutrasAccuracy.value}%'
                            : 'Start',
                        points: controller.sutrasPoints.value,
                        onTap: () => Get.toNamed(Routes.VEDIC_16_SUTRAS),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Obx(
                      () => MethodCard(
                        icon: Icons.lightbulb_outline,
                        iconColor: AppColors.purple,
                        title: 'Practice',
                        subtitle: 'You can practice here & levelup',
                        badge: controller.practiceAccuracy.value > 0
                            ? '${controller.practiceAccuracy.value}%'
                            : 'Start',
                        points: controller.practicePoints.value,
                        onTap: () => controller.showPracticeDialog(),
                      ),
                    ),
                    

                    
                    const SizedBox(height: 20),
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
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getResultColor(String category) {
    switch (category) {
      case 'Vedic Sutras':
        return AppColors.secondary;
      case 'Vedic Tactics':
        return AppColors.purple;
      case 'Practice':
        return const Color(0xFF4ECDC4);
      case 'Math Tables':
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  IconData _getResultIcon(String category) {
    switch (category) {
      case 'Vedic Sutras':
        return Icons.psychology_outlined;
      case 'Vedic Tactics':
        return Icons.auto_awesome;
      case 'Practice':
        return Icons.lightbulb_outline;
      case 'Math Tables':
        return Icons.calculate_outlined;
      default:
        return Icons.search;
    }
  }
}
