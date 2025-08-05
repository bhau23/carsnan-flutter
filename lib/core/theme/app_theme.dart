import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryGold = Color(0xFFD4AF37);
  static const Color _secondaryGold = Color(0xFFFFD700);
  static const Color _deepBlack = Color(0xFF000000);
  static const Color _charcoalBlack = Color(0xFF1C1C1C);
  static const Color _premiumWhite = Color(0xFFFFFFFF);
  static const Color _softWhite = Color(0xFFF8F8F8);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryGold,
        onPrimary: _deepBlack,
        secondary: _secondaryGold,
        onSecondary: _deepBlack,
        surface: _charcoalBlack,
        onSurface: _premiumWhite,
        error: Color(0xFFCF6679),
        onError: _deepBlack,
      ),
      scaffoldBackgroundColor: _deepBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: _deepBlack,
        foregroundColor: _premiumWhite,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _charcoalBlack,
        selectedItemColor: _primaryGold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryGold,
        foregroundColor: _deepBlack,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGold,
          foregroundColor: _deepBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: _charcoalBlack,
        elevation: 8,
        shadowColor: const Color(0x1AD4AF37),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: Color(0x33D4AF37),
            width: 1,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _premiumWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _premiumWhite,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: _premiumWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _premiumWhite,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: _premiumWhite,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _premiumWhite,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryGold,
        onPrimary: _deepBlack,
        secondary: _secondaryGold,
        onSecondary: _deepBlack,
        surface: _premiumWhite,
        onSurface: _deepBlack,
        error: Color(0xFFB00020),
        onError: _premiumWhite,
      ),
      scaffoldBackgroundColor: _softWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: _premiumWhite,
        foregroundColor: _deepBlack,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _premiumWhite,
        selectedItemColor: _primaryGold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryGold,
        foregroundColor: _deepBlack,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGold,
          foregroundColor: _deepBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: _premiumWhite,
        elevation: 8,
        shadowColor: const Color(0x1AD4AF37),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: Color(0x33D4AF37),
            width: 1,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _deepBlack,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _deepBlack,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: _deepBlack,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _deepBlack,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: _deepBlack,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _deepBlack,
          fontSize: 14,
        ),
      ),
    );
  }
}
