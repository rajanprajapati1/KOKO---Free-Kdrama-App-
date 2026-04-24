import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KokoColors {
  // Core Dark Palette
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF181818);
  static const surfaceVariant = Color(0xFF252525);
  static const border = Color(0xFF2E2E2E);

  // Koko Pastel Brand
  static const primary = Color(0xFFFF87B9);       // Neon Pink
  static const primaryLight = Color(0xFFFFB3D1);  // Soft Pink
  static const secondary = Color(0xFFB49EFF);     // Lavender
  static const accent = Color(0xFF87DCFF);        // Sky Blue pastel
  static const accent2 = Color(0xFFFFD87B);       // Pastel Gold

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB3B3B3);
  static const textMuted = Color(0xFF757575);

  // Functional
  static const newBadge = Color(0xFFFF87B9);
  static const topTenBadge = Color(0xFFFF87B9);
  static const progressBar = Color(0xFFFF87B9);

  // Light mode surfaces
  static const lightBackground = Color(0xFFF5F5F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF0F0F2);
  static const lightBorder = Color(0xFFE5E5EA);
  static const lightTextPrimary = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF6B7280);
  static const lightTextMuted = Color(0xFF9CA3AF);
}

class KokoTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: KokoColors.background,
    colorScheme: const ColorScheme.dark(
      primary: KokoColors.primary,
      secondary: KokoColors.secondary,
      surface: KokoColors.surface,
      surfaceTint: Colors.transparent,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
    fontFamily: GoogleFonts.dmSans().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    // IMPORTANT: Remove weight/grade/opticalSize — these cause MaterialSymbols to
    // not render on older Android (Vivo 1807 / Android 8.1) because the variable
    // font axes aren't supported. Use default icon theme instead.
    iconTheme: const IconThemeData(size: 24),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0A0A0A),
      selectedItemColor: KokoColors.primary,
      unselectedItemColor: Color(0xFF888888),
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      type: BottomNavigationBarType.fixed,
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: KokoColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: KokoColors.primary,
      secondary: KokoColors.secondary,
      surface: KokoColors.lightSurface,
      // Suppress Material3 tint overlays that wash out light mode
      surfaceTint: Colors.transparent,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.dmSansTextTheme(ThemeData.light().textTheme),
    fontFamily: GoogleFonts.dmSans().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: KokoColors.lightTextPrimary,
    ),
    iconTheme: const IconThemeData(size: 24, color: KokoColors.lightTextPrimary),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: KokoColors.lightSurface,
      selectedItemColor: KokoColors.primary,
      unselectedItemColor: Color(0xFF888888),
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: const CardThemeData(
      color: KokoColors.lightSurface,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: KokoColors.lightSurface,
      surfaceTintColor: Colors.transparent,
    ),
  );

  // Backward-compat alias
  static ThemeData get theme => darkTheme;
}
