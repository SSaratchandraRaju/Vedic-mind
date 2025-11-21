import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/enhanced_vedic_course_controller.dart';
import '../../data/models/sutra_simple_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';

class SutraDetailView extends GetView<EnhancedVedicCourseController> {
  const SutraDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final SutraSimpleModel sutra = args['sutra'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Gradient
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.gradientEnd],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Sutra ${sutra.sutraId}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            sutra.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            sutra.translation,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.signal_cellular_alt,
                                size: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                sutra.difficulty,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${sutra.timeMinutes} min',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Objective Card
                    _buildInfoCard(
                      icon: Icons.emoji_events,
                      title: 'Learning Objective',
                      content: sutra.objective,
                      color: const Color(0xFFFFA726),
                    ),
                    const SizedBox(height: 16),

                    // Why Learn This Section
                    _buildWhyLearnCard(sutra.whyLearn),
                    const SizedBox(height: 16),

                    // Start Interactive Lesson Button
                    _buildActionButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.INTERACTIVE_LESSON,
                          arguments: {
                            'sutra': sutra,
                            'sutraNumber': sutra.sutraId,
                            'sutraName': sutra.name,
                          },
                        );
                      },
                      icon: Icons.play_circle_filled,
                      label: 'Start Interactive Lesson',
                      isPrimary: true,
                    ),
                    const SizedBox(height: 12),

                    // Practice Problems Section
                    if (sutra.practice.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Practice Problems (${sutra.practice.length})',
                        style: AppTextStyles.h5,
                      ),
                      const SizedBox(height: 12),
                      ...sutra.practice.asMap().entries.map((entry) {
                        return _buildPracticePreview(
                          entry.key + 1,
                          entry.value.problem,
                        );
                      }).toList(),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        onPressed: () {
                          Get.toNamed(
                            Routes.INTERACTIVE_LESSON,
                            arguments: {
                              'sutra': sutra,
                              'sutraNumber': sutra.sutraId,
                              'sutraName': sutra.name,
                              'startPractice': true,
                            },
                          );
                        },
                        icon: Icons.edit_note,
                        label: 'Practice All Problems',
                        isPrimary: false,
                      ),
                    ],

                    // Mini Game Preview
                    if (sutra.miniGame.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildMiniGameCard(sutra),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyLearnCard(String whyLearn) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF81C784).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Why Learn This Sutra?',
                style: AppTextStyles.h5.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            whyLearn,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: AppColors.primary, width: 2),
          ),
          elevation: isPrimary ? 2 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticePreview(int number, String problem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              problem,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gray400),
        ],
      ),
    );
  }

  Widget _buildMiniGameCard(SutraSimpleModel sutra) {
    return InkWell(
      onTap: () => _launchMiniGame(sutra.sutraId),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6B6B).withOpacity(0.1),
              const Color(0xFFFF8E53).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.games, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mini Game',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sutra.miniGame,
                    style: AppTextStyles.h5.copyWith(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_filled,
              color: Color(0xFFFF6B6B),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  void _launchMiniGame(int sutraId) {
    // Navigate to appropriate game based on sutraId
    switch (sutraId) {
      case 1:
        Get.toNamed('/sutra1-game');
        break;
      case 2:
        Get.toNamed('/sutra2-game');
        break;
      case 3:
        Get.toNamed('/sutra3-game');
        break;
      case 4:
        Get.toNamed('/sutra4-game');
        break;
      case 5:
        Get.toNamed('/sutra5-game');
        break;
      case 6:
        Get.toNamed('/sutra6-game');
        break;
      case 7:
        Get.toNamed('/sutra7-game');
        break;
      case 8:
        Get.toNamed('/sutra8-game');
        break;
      case 9:
        Get.toNamed('/sutra9-game');
        break;
      case 10:
        Get.toNamed('/sutra10-game');
        break;
      case 11:
        Get.toNamed('/sutra11-game');
        break;
      case 12:
        Get.toNamed('/sutra12-game');
        break;
      case 13:
        Get.toNamed('/sutra13-game');
        break;
      case 14:
        Get.toNamed('/sutra14-game');
        break;
      case 15:
        Get.toNamed('/sutra15-game');
        break;
      case 16:
        Get.toNamed('/sutra16-game');
        break;
      default:
        Get.snackbar(
          '🎮 Coming Soon!',
          'This mini-game will be available soon!',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }
}
