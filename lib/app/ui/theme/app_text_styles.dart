import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings - Using responsive .sp units with adjusted sizes
  static TextStyle h1 = TextStyle(
    fontSize: 20.sp, // Reduced from 32.sp
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Poppins',
  );

  static TextStyle h2 = TextStyle(
    fontSize: 18.sp, // Reduced from 28.sp
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Poppins',
  );

  static TextStyle h3 = TextStyle(
    fontSize: 15.sp, // Reduced from 24.sp
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    fontFamily: 'Poppins',
  );

  static TextStyle h4 = TextStyle(
    fontSize: 13.sp, // Reduced from 20.sp
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    fontFamily: 'Poppins',
  );

  static TextStyle h5 = TextStyle(
    fontSize: 11.5.sp, // Reduced from 18.sp
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    fontFamily: 'Poppins',
  );

  // Body Text - Using responsive .sp units with adjusted sizes
  static TextStyle bodyLarge = TextStyle(
    fontSize: 10.sp, // Reduced from 16.sp
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 9.sp, // Reduced from 14.sp
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 7.5.sp, // Reduced from 12.sp
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  // Button Text - Using responsive .sp units with adjusted sizes
  static TextStyle button = TextStyle(
    fontSize: 10.sp, // Reduced from 16.sp
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    fontFamily: 'Poppins',
  );

  static TextStyle buttonSmall = TextStyle(
    fontSize: 9.sp, // Reduced from 14.sp
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    fontFamily: 'Poppins',
  );

  // Caption & Label - Using responsive .sp units with adjusted sizes
  static TextStyle caption = TextStyle(
    fontSize: 7.5.sp, // Reduced from 12.sp
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  static TextStyle label = TextStyle(
    fontSize: 9.sp, // Reduced from 14.sp
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  // Special - Using responsive .sp units with adjusted sizes
  static TextStyle overline = TextStyle(
    fontSize: 6.5.sp, // Reduced from 10.sp
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
    letterSpacing: 1.5,
    fontFamily: 'Poppins',
  );

  // Legacy (for backward compatibility) - Using responsive .sp units with adjusted sizes
  static TextStyle title = TextStyle(
    fontSize: 13.sp, // Reduced from 20.sp
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static TextStyle subtitle = TextStyle(
    fontSize: 10.sp, // Reduced from 16.sp
    color: const Color(0xFF6B7280),
    fontFamily: 'Poppins',
  );
}
