import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  
  static const h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  
  static const h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );
  
  // Body Text
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  // Button Text
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  static const buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  // Caption & Label
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  // Special
  static const overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
    letterSpacing: 1.5,
  );
  
  // Legacy (for backward compatibility)
  static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const subtitle = TextStyle(fontSize: 16, color: Color(0xFF6B7280));
}
