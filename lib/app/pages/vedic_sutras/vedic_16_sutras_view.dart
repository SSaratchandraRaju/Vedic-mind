import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../routes/app_routes.dart';
import '../../controllers/enhanced_vedic_course_controller.dart';
import '../../controllers/global_progress_controller.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';

class Vedic16SutrasView extends GetView<EnhancedVedicCourseController> {
  const Vedic16SutrasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Gradient
            SliverAppBar(
              expandedHeight: 200,
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
                      child: Obx(() {
                        // Trigger a granular refresh (throttled) when this view builds
                        controller.refreshGranularProgress();
                        final total = controller.allSutras.length;
                        final global = Get.find<GlobalProgressController>();
                        final completed = global.sutrasCompleted.value;
                        final accuracy = global.sutrasAccuracy.value;
                        final points = global.sutrasPoints.value;
                        final completionPct = total > 0 ? ((completed / total) * 100).round() : 0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              '16 Vedic Sutras',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _StatsHeader(
                              totalItems: total,
                              completionPct: completionPct,
                              accuracy: accuracy,
                              points: points,
                              itemLabel: 'Sutras',
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            // Removed old progress section

            // Content
            SliverToBoxAdapter(
              child: Obx(() {
                // Show loading
                if (controller.isLoading.value) {
                  return Container(
                    padding: const EdgeInsets.all(60),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text(
                            'Loading sutras...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show error if no data
                if (controller.allSutras.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No sutras loaded',
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please check your connection',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show sutra cards
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...controller.allSutras.map((sutra) {
                        final prevProgress = controller.sutraProgress[sutra.sutraId - 1];
                        final bool isUnlocked = sutra.sutraId == 1 || (prevProgress?.isCompleted ?? false);
                        return _SutraCard(
                          sutra: sutra,
                          isUnlocked: isUnlocked,
                          onTap: isUnlocked
                              ? () {
                                  Get.toNamed(
                                    Routes.SUTRA_DETAIL,
                                    arguments: {
                                      'sutra': sutra,
                                      'sutraNumber': sutra.sutraId,
                                      'sutraName': sutra.name,
                                      'meaning': sutra.translation,
                                    },
                                  );
                                }
                              : null,
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SutraCard extends StatelessWidget {
  final dynamic sutra;
  final VoidCallback? onTap;
  final bool isUnlocked;
  const _SutraCard({required this.sutra, required this.onTap, required this.isUnlocked});

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF4CAF50);
      case 'intermediate':
        return const Color(0xFFFFA726);
      case 'advanced':
        return const Color(0xFFEF5350);
      default:
        return AppColors.primary;
    }
  }

  String? _getGameRoute(int sutraId) {
    switch (sutraId) {
      case 1:
        return Routes.SUTRA1_GAME;
      case 2:
        return Routes.SUTRA2_GAME;
      case 3:
        return Routes.SUTRA3_GAME;
      case 4:
        return Routes.SUTRA4_GAME;
      case 5:
        return Routes.SUTRA5_GAME;
      case 6:
        return Routes.SUTRA6_GAME;
      case 7:
        return Routes.SUTRA7_GAME;
      case 8:
        return Routes.SUTRA8_GAME;
      case 9:
        return Routes.SUTRA9_GAME;
      case 10:
        return Routes.SUTRA10_GAME;
      case 11:
        return Routes.SUTRA11_GAME;
      case 12:
        return Routes.SUTRA12_GAME;
      case 13:
        return Routes.SUTRA13_GAME;
      case 14:
        return Routes.SUTRA14_GAME;
      case 15:
        return Routes.SUTRA15_GAME;
      case 16:
        return Routes.SUTRA16_GAME;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedVedicCourseController>();
    return Obx(() {
      final progress = controller.sutraProgress[sutra.sutraId];
      final bool isCompleted = progress?.isCompleted ?? false;
      final int accuracy = progress?.accuracy.toInt() ?? 0;
      final bool hasProgress = progress != null && progress.totalAttempts > 0;
      final accuracyColor = accuracy >= 80
          ? const Color(0xFF4CAF50)
          : accuracy >= 50
              ? const Color(0xFFFFA726)
              : const Color(0xFFEF5350);

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF4CAF50)
                : isUnlocked
                    ? AppColors.border
                    : Colors.grey[300]!,
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isUnlocked ? onTap : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: Center(
                              child: isUnlocked
                                  ? Text(
                                      '${sutra.sutraId}',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted
                                            ? const Color(0xFF4CAF50)
                                            : AppColors.primary,
                                        fontFamily: 'Poppins',
                                      ),
                                    )
                                  : Icon(
                                      Icons.lock,
                                      size: 32,
                                      color: Colors.grey[400],
                                    ),
                            ),
                          ),
                          if (isCompleted)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.check, color: Colors.white, size: 12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sutra.name,
                              style: AppTextStyles.h5.copyWith(
                                fontSize: 16,
                                color: isUnlocked ? AppColors.textPrimary : Colors.grey[600],
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sutra.translation,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isUnlocked ? AppColors.textSecondary : Colors.grey[500],
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(sutra.difficulty).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _getDifficultyColor(sutra.difficulty).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    sutra.difficulty,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _getDifficultyColor(sutra.difficulty),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: isUnlocked
                                      ? () {
                                          final gameRoute = _getGameRoute(sutra.sutraId);
                                          if (gameRoute != null) {
                                            Get.toNamed(gameRoute);
                                          } else {
                                            Get.snackbar(
                                              'Coming Soon',
                                              'Game for this sutra is not available yet',
                                              backgroundColor: AppColors.warning,
                                              colorText: Colors.white,
                                            );
                                          }
                                        }
                                      : null,
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isUnlocked ? AppColors.purple.withOpacity(0.1) : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: (isUnlocked ? AppColors.purple : Colors.grey[400]!).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.sports_esports, size: 12, color: isUnlocked ? AppColors.purple : Colors.grey[500]),
                                        const SizedBox(width: 4),
                                        Text(
                                          isUnlocked ? 'Game >' : 'Locked',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isUnlocked ? AppColors.purple : Colors.grey[600],
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (hasProgress && isUnlocked) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: accuracyColor.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star, size: 12, color: accuracyColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$accuracy%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: accuracyColor,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 14, color: isUnlocked ? AppColors.textTertiary : Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                '${sutra.timeMinutes} min',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 11,
                                  fontFamily: 'Poppins',
                                  color: isUnlocked ? AppColors.textSecondary : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (isUnlocked)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _HeaderChip({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.55), color.withOpacity(0.28)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.35), width: 0.7),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final int totalItems;
  final int completionPct;
  final int accuracy;
  final int points;
  final String itemLabel;
  const _StatsHeader({
    required this.totalItems,
    required this.completionPct,
    required this.accuracy,
    required this.points,
    required this.itemLabel,
  });
  @override
  Widget build(BuildContext context) {
    final Color accuracyColor = accuracy >= 80
        ? const Color(0xFF4CAF50)
        : accuracy >= 50
            ? const Color(0xFFFFA726)
            : const Color(0xFFEF5350);
    final Color pointsColor = const Color(0xFF7E57C2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _HeaderChip(icon: Icons.school, label: '$totalItems $itemLabel', color: Colors.white),
              const SizedBox(width: 10),
              _HeaderChip(icon: Icons.star, label: '$accuracy% Accuracy', color: accuracyColor),
              const SizedBox(width: 10),
              _HeaderChip(icon: Icons.bolt, label: '$points pts', color: pointsColor),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: 12,
            value: completionPct / 100.0,
            backgroundColor: Colors.white.withOpacity(0.18),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Progress: $completionPct%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
