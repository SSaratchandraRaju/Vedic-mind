import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MethodCard extends StatelessWidget {
  final IconData? icon; // Optional when using svg or image
  final Color iconColor;
  final String? svgAsset; // Provide assets/icons/*.svg path
  final String? imageAsset; // Provide assets/images/*.png path
  final String title;
  final String subtitle;
  final String? badge;
  final int? points; // Optional points to display
  final VoidCallback onTap;

  const MethodCard({
    super.key,
    this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.badge,
    this.points,
    required this.onTap,
    this.svgAsset,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Leading visual: prefer imageAsset, then svgAsset, then icon
            if (imageAsset != null)
              SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(
                  imageAsset!,
                  fit: BoxFit.contain,
                ),
              )
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // Only show soft background when using icon/svg, not for PNG per request
                  color: svgAsset == null && icon != null
                      ? iconColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: svgAsset != null
                      ? SvgPicture.asset(
                          svgAsset!,
                          width: 26,
                          height: 26,
                        )
                      : Icon(icon, color: iconColor, size: 24),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                  if (points != null && points! > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Color(0xFFFF9800),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$points pts',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9800),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getBadgeColor(badge!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getBadgeIcon(badge!),
                      color: _getBadgeColor(badge!),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      badge!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getBadgeColor(badge!),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.gray300,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(String badgeText) {
    // Check if badge is a percentage
    if (badgeText.contains('%')) {
      final percentageStr = badgeText.replaceAll('%', '');
      final percentage = int.tryParse(percentageStr);
      if (percentage != null) {
        if (percentage >= 80) return const Color(0xFF4CAF50); // Green
        if (percentage >= 60) return const Color(0xFFFF9800); // Orange
        if (percentage >= 40) return const Color(0xFFFFA726); // Light orange
        return const Color(0xFFEF5350); // Red
      }
    }
    // Default color for non-percentage badges (like "Start", "New")
    return AppColors.primary;
  }

  IconData _getBadgeIcon(String badgeText) {
    // Check if badge is a percentage
    if (badgeText.contains('%')) {
      final percentageStr = badgeText.replaceAll('%', '');
      final percentage = int.tryParse(percentageStr);
      if (percentage != null) {
        if (percentage >= 80) return Icons.check_circle;
        if (percentage >= 60) return Icons.trending_up;
        if (percentage >= 40) return Icons.show_chart;
        return Icons.trending_down;
      }
    }
    // For "Start" or other text badges
    if (badgeText.toLowerCase() == 'start') return Icons.play_arrow;
    if (badgeText.toLowerCase() == 'new') return Icons.fiber_new;
    return Icons.emoji_events;
  }
}
