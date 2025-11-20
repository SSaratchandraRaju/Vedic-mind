import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/method_card.dart';

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
                              Obx(() => Text(
                                    'Hi, ${controller.userName.value}!',
                                    style: AppTextStyles.h4,
                                  )),
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'All Category',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search for basic math...',
                                hintStyle: TextStyle(
                                  color: AppColors.gray400,
                                  fontSize: 14,
                                fontFamily: 'Poppins'),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Overall Score
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Over All score',
                                  style: AppTextStyles.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Discovering Mathematics',
                                  style: AppTextStyles.h5,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Continue your journey!',
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
                                  value: 0.72,
                                  strokeWidth: 8,
                                  backgroundColor: AppColors.gray100,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.yellow,
                                  ),
                                ),
                              ),
                              Text(
                                '72%',
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Popular Methods
                    Text(
                      'Popular methods',
                      style: AppTextStyles.h5,
                    ),
                    const SizedBox(height: 16),

                    MethodCard(
                      icon: Icons.calculate_outlined,
                      iconColor: AppColors.primary,
                      title: 'Maths Tables',
                      subtitle: '100 math tables words',
                      badge: '24%',
                      onTap: () => Get.toNamed(Routes.MATH_TABLES),
                    ),
                    const SizedBox(height: 12),

                    MethodCard(
                      icon: Icons.psychology_outlined,
                      iconColor: AppColors.secondary,
                      title: 'Vedic Sutras',
                      subtitle: '16 Ancient Sutras for Smarter, Faster Calculation.',
                      badge: '20%',
                      onTap: () => Get.toNamed(Routes.VEDIC_16_SUTRAS),
                    ),
                    const SizedBox(height: 12),

                    MethodCard(
                      icon: Icons.lightbulb_outline,
                      iconColor: AppColors.purple,
                      title: 'Practice',
                      subtitle: 'You can practice here & levelup',
                      badge: '234',
                      onTap: () => controller.showPracticeDialog(),
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.VEDIC_METHODS),
                      onLongPress: () => Get.toNamed(Routes.VEDIC_COURSE),
                      child: MethodCard(
                        icon: Icons.auto_awesome,
                        iconColor: AppColors.pink,
                        title: 'Vedic Tactics',
                        subtitle: 'Master vedic mathematics techniques',
                        badge: 'New',
                        onTap: () => Get.toNamed(Routes.VEDIC_METHODS),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Obx(() => BottomNavBar(
                  currentIndex: controller.currentNavIndex.value,
                  onTap: controller.onNavTap,
                )),
          ],
        ),
      ),
    );
  }
}
