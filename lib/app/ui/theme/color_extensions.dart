// Color extensions to replace deprecated `withOpacity` usages.
// Flutter deprecates `Color.withOpacity` in favor of `Color.withValues` to
// prevent precision loss. This helper provides an expressive alternative.
import 'package:flutter/material.dart';

extension ColorOpacityCompat on Color {
  /// Safe replacement for deprecated `withOpacity` using `withValues`.
  /// Keeps precision and avoids naming collision with existing [Color.alpha] getter.
  Color withOpacityCompat(double opacity) {
    final o = opacity.clamp(0.0, 1.0);
    // withValues takes channel values in the 0.0 - 1.0 range.
    return withValues(alpha: o);
  }

  // Convenience getters.
  Color get o10 => withOpacityCompat(0.10);
  Color get o20 => withOpacityCompat(0.20);
  Color get o30 => withOpacityCompat(0.30);
  Color get o40 => withOpacityCompat(0.40);
  Color get o50 => withOpacityCompat(0.50);
  Color get o60 => withOpacityCompat(0.60);
  Color get o70 => withOpacityCompat(0.70);
  Color get o80 => withOpacityCompat(0.80);
  Color get o90 => withOpacityCompat(0.90);
}
