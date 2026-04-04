import 'package:flutter/material.dart';

class NothingTheme {
  // COLORS - Dark Mode (OLED Black)
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceRaised = Color(0xFF1A1A1A);
  static const Color border = Color(0xFF222222);
  static const Color borderVisible = Color(0xFF333333);
  static const Color textDisabled = Color(0xFF666666);
  static const Color textSecondary = Color(0xFF999999);
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textDisplay = Color(0xFFFFFFFF);

  // ACCENT & STATUS
  static const Color accent = Color(0xFFD71921);
  static const Color accentSubtle = Color(0x26D71921);
  static const Color success = Color(0xFF4A9E5C);
  static const Color warning = Color(0xFFD4A843);
  static const Color error = Color(0xFFD71921);
  static const Color interactive = Color(0xFF5B9BF6);

  // SPACING (8px base)
  static const double space2xs = 2.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 48.0;
  static const double space3xl = 64.0;
  static const double space4xl = 96.0;

  // TYPE SCALE
  static const double displayXl = 72.0;
  static const double displayLg = 48.0;
  static const double displayMd = 36.0;
  static const double heading = 24.0;
  static const double subheading = 18.0;
  static const double body = 16.0;
  static const double bodySm = 14.0;
  static const double caption = 12.0;
  static const double label = 11.0;

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        surface: black,
        primary: textDisplay,
        secondary: textSecondary,
        error: error,
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: displayXl,
          height: 1.0,
          letterSpacing: -2.16,
          color: textDisplay,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          fontSize: displayLg,
          height: 1.05,
          letterSpacing: -0.96,
          color: textDisplay,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          fontSize: displayMd,
          height: 1.1,
          letterSpacing: -0.72,
          color: textDisplay,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          fontSize: heading,
          height: 1.2,
          letterSpacing: -0.24,
          color: textDisplay,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          fontSize: subheading,
          height: 1.3,
          color: textPrimary,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          fontSize: body,
          height: 1.5,
          color: textPrimary,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontSize: bodySm,
          height: 1.5,
          letterSpacing: 0.14,
          color: textPrimary,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontSize: caption,
          height: 1.4,
          letterSpacing: 0.48,
          color: textSecondary,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: TextStyle(
          fontSize: label,
          height: 1.2,
          letterSpacing: 0.88,
          color: textSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: label,
          letterSpacing: 0.88,
          color: textSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: textDisplay,
          foregroundColor: black,
          minimumSize: const Size(88, 44),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            letterSpacing: 0.78,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(88, 44),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: borderVisible, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            letterSpacing: 0.78,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: const BorderSide(color: borderVisible, width: 1),
          borderRadius: BorderRadius.circular(0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: borderVisible, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: textPrimary, width: 1),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: accent, width: 1),
        ),
        labelStyle: const TextStyle(
          fontSize: label,
          letterSpacing: 0.88,
          color: textSecondary,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
