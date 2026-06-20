import 'package:flutter/material.dart';

/// SafeCity Spacing & Layout System
///
/// Base unit: 4px
class AppSpacing {
  AppSpacing._();

  // ============================================================================
  // BASE UNIT & SCALE
  // ============================================================================

  static const double unit = 4.0; // 4px base unit

  // ============================================================================
  // STACKING (Vertical & Horizontal)
  // ============================================================================

  static const double stackXs = 4.0; // 1 unit
  static const double stackSm = 8.0; // 2 units
  static const double stackMd = 16.0; // 4 units
  static const double stackLg = 24.0; // 6 units

  // Aliases for semantic usage
  static const double spacingXxs = stackXs;
  static const double spacingXs = stackXs;
  static const double spacingSm = stackSm;
  static const double spacingMd = stackMd;
  static const double spacingLg = stackLg;
  static const double spacingXl = 32.0; // 8 units
  static const double spacingXxl = 48.0; // 12 units

  // ============================================================================
  // LAYOUT CONSTANTS
  // ============================================================================

  static const double gutter = 16.0; // Grid gutter width
  static const double margin = 24.0; // Standard margin
  static const double containerMax = 1440.0; // Max container width

  // ============================================================================
  // RESPONSIVE BREAKPOINTS
  // ============================================================================

  static const double breakpointMobile = 0.0; // <768px
  static const double breakpointTablet = 768.0; // 768px - 1024px
  static const double breakpointDesktop = 1024.0; // >1024px

  // ============================================================================
  // COMPONENT PADDING
  // ============================================================================

  // Button padding
  static const EdgeInsets buttonPaddingLarge =
      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
  static const EdgeInsets buttonPaddingMedium =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets buttonPaddingSmall =
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);

  // Card padding
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(24.0);
  static const EdgeInsets cardPaddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(12.0);

  // Input field padding
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

  // Chip padding
  static const EdgeInsets chipPadding =
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);

  // ============================================================================
  // DIVIDER & BORDER SPACING
  // ============================================================================

  static const double dividerHeight = 1.0; // 1px divider
  static const double borderWidth = 1.0; // 1px border

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Status indicator sizes
  static const double statusIndicatorSmall = 4.0; // 4px pulsing circle
  static const double statusIndicatorMedium = 8.0; // 8px pulsing circle
  static const double statusIndicatorLarge = 12.0; // 12px pulsing circle
}
