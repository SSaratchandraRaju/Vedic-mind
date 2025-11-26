import 'package:flutter/material.dart';
// Shimmer import (ensure package in pubspec; fallback handled if absent)
// ignore: unnecessary_import
import 'package:shimmer/shimmer.dart' as shimmer;
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
                          child: Obx(() {
                            final url = controller.userPhotoUrl.value;
                            // If photoUrl is a single letter (initial), render text avatar
                            if (url.isNotEmpty) {
                              if (url.length == 1) {
                                return CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primary.withOpacity(0.15),
                                  child: Text(
                                    url.toUpperCase(),
                                    style: AppTextStyles.h4.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              }
                              return CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                child: ClipOval(
                                  child: Image.network(
                                    url,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return CircleAvatar(
                                        radius: 24,
                                        backgroundColor: AppColors.primary.withOpacity(0.15),
                                        child: Text(
                                          (controller.userName.value.isNotEmpty
                                                  ? controller.userName.value[0]
                                                  : 'U')
                                              .toUpperCase(),
                                          style: AppTextStyles.h4.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                            return CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Text(
                                (controller.userName.value.isNotEmpty
                                        ? controller.userName.value[0]
                                        : 'U')
                                    .toUpperCase(),
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }),
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
                          // Category Dropdown (replaces bottom sheet selector)
                          Obx(
                            () => PopupMenuButton<SearchCategory>(
                              onSelected: (value) {
                                controller.selectedCategory.value = value;
                                // Trigger a new search if query exists
                                final query = controller.searchController.text.trim();
                                if (query.isNotEmpty) {
                                  controller.performSearch(query);
                                }
                              },
                              itemBuilder: (context) {
                                // Assuming SearchCategory.values exists
                                return SearchCategory.values.map((cat) {
                                  final text = cat == SearchCategory.all
                                      ? 'All'
                                      : controller.getCategoryName(cat);
                                  return PopupMenuItem<SearchCategory>(
                                    value: cat,
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              position: PopupMenuPosition.under,
                              elevation: 4,
                              color: Colors.white,
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
                                      controller.selectedCategory.value == SearchCategory.all
                                          ? 'All'
                                          : controller
                                              .getCategoryName(controller.selectedCategory.value)
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
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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

                    // Overall Score - Firestore-driven dynamic stats
                    Obx(() {
                      final gp = controller.globalProgressController;
                      final loaded = gp.isProgressLoaded.value;
                      final accuracy = gp.overallAccuracy.value.clamp(0, 100);
                      final points = gp.totalPoints.value;
                      final questionsAttempted = gp.totalQuestionsAttempted.value;
                      final correctAnswers = gp.totalCorrectAnswers.value;

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: loaded
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Overall Performance', style: AppTextStyles.bodySmall),
                                            const SizedBox(height: 4),
                                            Text('Discovering Mathematics', style: AppTextStyles.h5),
                                            const SizedBox(height: 4),
                                            Text(
                                              questionsAttempted > 0 ? 'Keep up the great work!' : 'Start your journey!',
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
                                              value: (accuracy / 100),
                                              strokeWidth: 8,
                                              backgroundColor: AppColors.gray100,
                                              valueColor: AlwaysStoppedAnimation<Color>(
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
                                      Container(height: 40, width: 1, color: AppColors.border),
                                      Expanded(
                                        child: _buildStatItem(
                                          icon: Icons.quiz_outlined,
                                          label: 'Questions',
                                          value: questionsAttempted == 0 ? '0/0' : '$correctAnswers/$questionsAttempted',
                                          color: AppColors.primary,
                                          correctColor: const Color(0xFF4CAF50),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : _buildShimmerPerformancePlaceholder(),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Popular Methods
                    Text('Popular methods', style: AppTextStyles.h5),
                    const SizedBox(height: 16),

                    Obx(() {
                      final acc = controller.mathTablesAccuracy.value;
                      final pts = controller.mathTablesPoints.value;
                      return MethodCard(
                        svgAsset: 'assets/icons/mathtables_new.svg',
                        iconColor: AppColors.primary,
                        title: 'Maths Tables',
                        subtitle: 'Practice multiplication tables',
                        badge: acc > 0 ? '$acc%' : 'Start',
                        points: pts,
                        onTap: () => Get.toNamed(Routes.MATH_TABLES),
                      );
                    }),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.VEDIC_METHODS),
                      onLongPress: () => Get.toNamed(Routes.VEDIC_COURSE),
                      child: Obx(() {
                        final acc = controller.tacticsAccuracy.value;
                        final pts = controller.tacticsPoints.value;
                        return MethodCard(
                          svgAsset: 'assets/icons/vedictactics_new.svg',
                          iconColor: AppColors.pink,
                          title: 'Vedic Tactics',
                          subtitle: 'Master vedic math techniques',
                          badge: acc > 0 ? '$acc%' : 'Start',
                          points: pts,
                          onTap: () => Get.toNamed(Routes.ALL_LESSONS),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),

                    Obx(() {
                      final acc = controller.sutrasAccuracy.value;
                      final pts = controller.sutrasPoints.value;
                      return MethodCard(
                        svgAsset: 'assets/icons/sutras.svg',
                        iconColor: AppColors.secondary,
                        title: 'Vedic Sutras',
                        subtitle: '16 Sutras for Faster, Smarter Calculation.',
                        badge: acc > 0 ? '$acc%' : 'Start',
                        points: pts,
                        onTap: () => Get.toNamed(Routes.VEDIC_16_SUTRAS),
                      );
                    }),
                    const SizedBox(height: 12),

                    Obx(() {
                      final acc = controller.practiceAccuracy.value;
                      final pts = controller.practicePoints.value;
                      return MethodCard(
                        svgAsset: 'assets/icons/practice.svg',
                        iconColor: AppColors.purple,
                        title: 'Practice',
                        subtitle: 'You can practice here & levelup',
                        badge: acc > 0 ? '$acc%' : 'Start',
                        points: pts,
                        onTap: () => controller.showPracticeDialog(),
                      );
                    }),

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
    Color? correctColor,
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
          if (correctColor != null && value.contains('/'))
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value.split('/')[0],
                    style: AppTextStyles.h4.copyWith(
                      color: correctColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/${value.split('/')[1]}',
                    style: AppTextStyles.h4.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
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

  // Shimmer placeholder for overall performance card while loading stats
  Widget _buildShimmerPerformancePlaceholder() {
    // If shimmer package not linked properly, return static placeholder
    Widget content = Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 140, color: AppColors.gray100, margin: const EdgeInsets.only(bottom: 8)),
                  Container(height: 18, width: 180, color: AppColors.gray100, margin: const EdgeInsets.only(bottom: 6)),
                  Container(height: 12, width: 160, color: AppColors.gray100),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(height: 20, width: 40, color: AppColors.gray100),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(height: 14, width: 60, color: AppColors.gray100, margin: const EdgeInsets.only(bottom: 8)),
                  Container(height: 22, width: 70, color: AppColors.gray100),
                ],
              ),
            ),
            Container(height: 40, width: 1, color: AppColors.border),
            Expanded(
              child: Column(
                children: [
                  Container(height: 14, width: 60, color: AppColors.gray100, margin: const EdgeInsets.only(bottom: 8)),
                  Container(height: 22, width: 90, color: AppColors.gray100),
                ],
              ),
            ),
          ],
        ),
      ],
    );
    try {
      return shimmer.Shimmer.fromColors(
        baseColor: AppColors.gray100,
        highlightColor: AppColors.gray200,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, width: 140, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                    Container(height: 18, width: 180, color: Colors.white, margin: const EdgeInsets.only(bottom: 6)),
                    Container(height: 12, width: 160, color: Colors.white),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(height: 20, width: 40, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(height: 14, width: 60, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                    Container(height: 22, width: 70, color: Colors.white),
                  ],
                ),
              ),
              Container(height: 40, width: 1, color: AppColors.border),
              Expanded(
                child: Column(
                  children: [
                    Container(height: 14, width: 60, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                    Container(height: 22, width: 90, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    } catch (_) {
      return content; // Fallback without shimmer effect
    }
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
