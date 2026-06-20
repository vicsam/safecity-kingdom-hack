import 'package:flutter/material.dart';

/// SafeCity Border Radius System
class AppRadius {
  AppRadius._();

  // ============================================================================
  // BORDER RADIUS VALUES (in logical pixels)
  // ============================================================================

  // Small radius - 4px (0.25rem)
  static const double sm = 4.0;

  // Default radius - 8px (0.5rem)
  // Used for buttons, small components
  static const double none = 8.0;

  // Medium radius - 12px (0.75rem)
  // Used for cards and general containers
  static const double md = 12.0;

  // Large radius - 16px (1rem)
  // Used for larger containers and elevated surfaces
  static const double lg = 16.0;

  // Extra large radius - 24px (1.5rem)
  // Used for dialogs and modals
  static const double xl = 24.0;

  // Pill/Full radius - effectively infinite
  static const double full = 9999.0;

  // ============================================================================
  // BORDER RADIUS OBJECTS (for easy widget usage)
  // ============================================================================

  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusNone = BorderRadius.all(Radius.circular(none));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // ============================================================================
  // COMPONENT-SPECIFIC BORDER RADIUS
  // ============================================================================

  // Cards: 12px radius (soften high-density information load)
  static const BorderRadius cardRadius = radiusMd;

  // Buttons: 8px radius (more "tooled" and professional)
  static const BorderRadius buttonRadius = radiusNone;

  // Chips/Status Indicators: 20px (pill radius for immediate distinction)
  static const double chipRadius = 20.0;
  static const BorderRadius chipBorderRadius =
      BorderRadius.all(Radius.circular(chipRadius));

  // Input Fields: 8px radius
  static const BorderRadius inputRadius = radiusNone;

  // Modals/Dialogs: 24px radius
  static const BorderRadius modalRadius = radiusXl;

  // Small buttons/icons: 4px radius
  static const BorderRadius smallButtonRadius = radiusSm;
}
