import 'package:flutter/material.dart';

/// Visual tokens shared by the Bipolaris reflection journal.
abstract final class BipolarisTheme {
  static const _ink = Color(0xFF263238);
  static const _plum = Color(0xFF655078);
  static const _lavender = Color(0xFFF0EAF6);
  static const _canvas = Color(0xFFFAF8FC);
  static const _teal = Color(0xFF236B63);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _plum,
      brightness: Brightness.light,
      primary: _plum,
      secondary: _teal,
      surface: _canvas,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _canvas,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: const AppBarTheme(
        backgroundColor: _canvas,
        foregroundColor: _ink,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE8E2ED)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFB9AFBF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFB9AFBF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _plum, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: const BorderSide(color: Color(0xFFB9AFBF)),
        selectedColor: _lavender,
        showCheckmark: true,
        labelStyle: const TextStyle(color: _ink),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _plum,
        foregroundColor: Colors.white,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: _ink,
        displayColor: _ink,
      ),
    );
  }
}
