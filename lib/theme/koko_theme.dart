import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KokoColors {
  // Core Palette
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
}

class KokoTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: KokoColors.background,
    colorScheme: const ColorScheme.dark(
      primary: KokoColors.primary,
      secondary: KokoColors.secondary,
      surface: KokoColors.surface,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
    fontFamily: GoogleFonts.dmSans().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      weight: 300,
      opticalSize: 20.0,
      grade: -25,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0A0A0A),
      selectedItemColor: KokoColors.primary,
      unselectedItemColor: Color(0xFF888888),
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
