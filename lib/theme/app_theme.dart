import 'package:flutter/material.dart';

class AppColors {
  static const green = Color(0xFF2ED573);
  static const greenDark = Color(0xFF22C55E);
  static const bgDark = Color(0xFF121212);
  static const cardDark = Color(0xFF1E1E1E);
  static const cardDarkAlt = Color(0xFF1B1B1B);
  static const textLight = Color(0xFFF5F5F5);
  static const textMuted = Color(0xFF9CA3AF);
  static const divider = Color(0xFF2A2A2A);
  static const danger = Color(0xFFEF4444);
  static const blue = Color(0xFF3B82F6);
  static const orange = Color(0xFFF59E0B);
  static const Color textSecondary = Color(0xFF9AA5A1);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        primaryColor: AppColors.green,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.green,
          secondary: AppColors.green,
          surface: AppColors.cardDark,
        ),
        cardColor: AppColors.cardDark,
        dividerColor: AppColors.divider,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          foregroundColor: AppColors.textLight,
          centerTitle: false,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textLight),
          bodyLarge: TextStyle(color: AppColors.textLight),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardDarkAlt,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.bgDark,
          selectedItemColor: AppColors.green,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
        ),
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F7F8),
        primaryColor: AppColors.greenDark,
        colorScheme: const ColorScheme.light(
          primary: AppColors.greenDark,
          secondary: AppColors.greenDark,
          surface: Colors.white,
        ),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7F8),
          elevation: 0,
          foregroundColor: Colors.black,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.greenDark,
          unselectedItemColor: Colors.grey.shade500,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
        ),
      );
}
