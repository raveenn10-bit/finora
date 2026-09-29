// ─────────────────────────────────────────────────────────
//  core/theme/app_theme.dart
//  Dark theme using Plus Jakarta Sans (Google Fonts).
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData finoraTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kNavy,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kMint,
      brightness: Brightness.dark,
      surface: kNavy2,
      primary: kMint,
      secondary: kCyan,
      error: kError,
    ),
    useMaterial3: true,
  );

  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: kText,
      displayColor: kText,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMint,
        foregroundColor: kNavy,
        textStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          letterSpacing: .5,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
    ),
  );
}
