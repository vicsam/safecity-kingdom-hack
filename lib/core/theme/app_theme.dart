import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_radius.dart';

/// SafeCity Mission Control Design System Theme
class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'Inter';

  // ============================================================================
  // STITCH TYPOGRAPHY SCALE - Inter Font
  // ============================================================================

  // Display Large: 48px, 700, line-height 56px, -0.02em
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48, // 1.167
    letterSpacing: -0.02 * 48, // -0.96px
    color: AppColors.textPrimary,
  );

  // Headline Large: 32px, 600, line-height 40px, -0.01em
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32, // 1.25
    letterSpacing: -0.01 * 32, // -0.32px
    color: AppColors.textPrimary,
  );

  // Headline Large Mobile: 24px, 600, line-height 32px
  static const TextStyle headlineLargeMobile = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24, // 1.333
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Title Medium: 20px, 600, line-height 28px
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20, // 1.4
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Fallback display variants for Material 3
  static const TextStyle displayMedium = displayLarge;
  static const TextStyle displaySmall = headlineLarge;
  static const TextStyle headlineMedium = titleMedium;
  static const TextStyle headlineSmall = headlineLargeMobile;

  // Body Large: 16px, 400, line-height 24px
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16, // 1.5
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Body Small: 14px, 400, line-height 20px
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14, // 1.429
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Fallback body medium
  static const TextStyle bodyMedium = bodySmall;

  // Label Caps: 12px, 700, line-height 16px, 0.05em
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12, // 1.333
    letterSpacing: 0.05 * 12, // 0.6px
    color: AppColors.textPrimary,
  );

  // Mono Data: 13px, 500, line-height 16px, 0.01em
  static const TextStyle monoData = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 16 / 13, // 1.231
    letterSpacing: 0.01 * 13, // 0.13px
    color: AppColors.textPrimary,
  );

  // Fallback label variants
  static const TextStyle labelMedium = labelLarge;
  static const TextStyle labelSmall = labelLarge;

  // Title variants for Material 3 compatibility
  static const TextStyle titleLarge = titleMedium;
  static const TextStyle titleSmall = bodySmall;

  // Build dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      canvasColor: AppColors.background,

      // Color scheme (Material 3)
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textInverse,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: AppColors.textInverse,
        secondary: AppColors.info,
        onSecondary: AppColors.textInverse,
        secondaryContainer: AppColors.surfaceRaised,
        onSecondaryContainer: AppColors.info,
        tertiary: AppColors.success,
        onTertiary: AppColors.textInverse,
        error: AppColors.danger,
        onError: AppColors.textInverse,
        errorContainer: AppColors.dangerSurface,
        onErrorContainer: AppColors.danger,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
        outlineVariant: AppColors.border,
        shadow: Color(0x40000000),
        scrim: Color(0x4D000000),
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: titleLarge.copyWith(color: AppColors.textPrimary),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // FAB theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chipBorderRadius),
      ),

      // Button themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.textInverse,
          padding: AppSpacing.buttonPaddingLarge,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          padding: AppSpacing.buttonPaddingLarge,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: AppSpacing.buttonPaddingSmall,
          textStyle: labelLarge,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceOverlay,
        contentPadding: AppSpacing.inputPadding,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(
            color: AppColors.border,
            width: AppSpacing.borderWidth,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(
            color: AppColors.border,
            width: AppSpacing.borderWidth,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.danger, width: 2),
        ),
        labelStyle: bodySmall.copyWith(color: AppColors.textSecondary),
        hintStyle: bodySmall.copyWith(color: AppColors.textTertiary),
        helperStyle: bodySmall.copyWith(color: AppColors.textSecondary),
        errorStyle: bodySmall.copyWith(color: AppColors.danger),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: AppColors.surfaceRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(
            color: AppColors.border,
            width: AppSpacing.borderWidth,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Dialog theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surfaceRaised,
        surfaceTintColor: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.modalRadius),
        elevation: 0,
      ),

      // Navigation rail theme (for desktop/tablet layouts)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        selectedIconTheme: const IconThemeData(color: AppColors.primary),
        unselectedIconTheme: const IconThemeData(
          color: AppColors.textSecondary,
        ),
        selectedLabelTextStyle: labelSmall.copyWith(color: AppColors.primary),
        unselectedLabelTextStyle: labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Bottom navigation theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: labelSmall,
        unselectedLabelStyle: labelSmall,
        elevation: 0,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: AppSpacing.dividerHeight,
        space: AppSpacing.stackMd,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceOverlay,
        selectedColor: AppColors.primary,
        labelStyle: monoData.copyWith(color: AppColors.textPrimary),
        padding: AppSpacing.chipPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chipBorderRadius),
        side: const BorderSide(
          color: AppColors.border,
          width: AppSpacing.borderWidth,
        ),
      ),

      // Snack bar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceRaised,
        contentTextStyle: bodySmall.copyWith(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),
    );
  }
}
