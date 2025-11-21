import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const SectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.isLocked = false,
    this.isCompleted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (isCompleted) {
      backgroundColor = Colors.green;
      textColor = Colors.white;
    } else if (isLocked) {
      backgroundColor = AppColors.gray100;
      textColor = AppColors.textSecondary.withOpacity(0.5);
    } else if (isSelected) {
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
    } else {
      backgroundColor = AppColors.gray100;
      textColor = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLocked)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(Icons.lock, size: 16, color: textColor),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
