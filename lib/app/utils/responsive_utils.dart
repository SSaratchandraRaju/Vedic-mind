import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Responsive sizing utilities for VedicMind app
///
/// Usage:
/// - Text: fontSize: 16.sp (responsive font size)
/// - Height/Width: height: 20.h (20% of screen height)
/// - Padding/Margin: padding: EdgeInsets.all(2.w) (2% of screen width)
///
/// Units:
/// - .sp: Scalable pixels for font sizes
/// - .h: Percentage of screen height
/// - .w: Percentage of screen width

class ResponsiveUtils {
  // Screen breakpoints
  static bool isMobile() => SizerUtil.deviceType == DeviceType.mobile;
  static bool isTablet() => SizerUtil.deviceType == DeviceType.tablet;
  static bool isPortrait() => SizerUtil.orientation == Orientation.portrait;
  static bool isLandscape() => SizerUtil.orientation == Orientation.landscape;

  // Common responsive spacing
  static double get tinySpace => 0.5.h; // ~4px on mobile
  static double get smallSpace => 1.h; // ~8px on mobile
  static double get mediumSpace => 2.h; // ~16px on mobile
  static double get largeSpace => 3.h; // ~24px on mobile
  static double get extraLargeSpace => 4.h; // ~32px on mobile

  // Common responsive padding
  static double get tinyPadding => 0.5.w; // ~2px on mobile
  static double get smallPadding => 2.w; // ~8px on mobile
  static double get mediumPadding => 4.w; // ~16px on mobile
  static double get largePadding => 6.w; // ~24px on mobile
  static double get extraLargePadding => 8.w; // ~32px on mobile

  // Common responsive font sizes (adjusted to match AppTextStyles)
  static double get captionSize => 6.5.sp; // Small text (matches overline)
  static double get bodySmallSize => 7.5.sp; // Small body text
  static double get bodyMediumSize => 9.sp; // Regular body text
  static double get bodyLargeSize => 10.sp; // Large body text
  static double get subtitleSize => 11.5.sp; // Subtitle text (matches h5)
  static double get titleSize => 13.sp; // Title text (matches h4/title)
  static double get headingSize => 15.sp; // Heading text (matches h3)
  static double get displaySize => 20.sp; // Large display text (matches h1)

  // Common responsive sizes for UI elements
  static double get buttonHeight => 6.h; // ~48px on mobile
  static double get inputHeight => 6.h; // ~48px on mobile
  static double get iconSize => 6.w; // ~24px on mobile
  static double get largeIconSize => 12.w; // ~48px on mobile
  static double get avatarSize => 12.w; // ~48px on mobile
  static double get cardElevation => 0.5.h; // ~4px on mobile
  static double get borderRadius => 3.w; // ~12px on mobile

  // Responsive sizing helpers
  static double responsiveValue({required double mobile, double? tablet}) {
    if (isTablet() && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  // Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all.w);
    }
    return EdgeInsets.only(
      left: left?.w ?? horizontal?.w ?? 0,
      top: top?.h ?? vertical?.h ?? 0,
      right: right?.w ?? horizontal?.w ?? 0,
      bottom: bottom?.h ?? vertical?.h ?? 0,
    );
  }

  // Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return getResponsivePadding(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  // Get responsive border radius
  static BorderRadius getResponsiveBorderRadius(double radius) {
    return BorderRadius.circular(radius.w);
  }

  // Get responsive size for containers
  static Size getResponsiveSize({
    required double width,
    required double height,
  }) {
    return Size(width.w, height.h);
  }

  // Screen dimensions
  static double get screenWidth => 100.w;
  static double get screenHeight => 100.h;
  static double get halfScreenWidth => 50.w;
  static double get halfScreenHeight => 50.h;
  static double get quarterScreenWidth => 25.w;
  static double get quarterScreenHeight => 25.h;
}

/// Extension on num for quick responsive sizing
extension ResponsiveExtension on num {
  /// Returns responsive font size
  double get rsp => toDouble().sp;

  /// Returns responsive height
  double get rh => toDouble().h;

  /// Returns responsive width
  double get rw => toDouble().w;
}
