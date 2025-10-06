import 'package:flutter/material.dart';

class AccessibleTheme {
  // High contrast colors for better accessibility
  static const Color primaryBlue = Color(0xFF0066CC);
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF000000);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color accentGreen = Color(0xFF00AA44);
  static const Color accentRed = Color(0xFFCC0000);
  static const Color accentOrange = Color(0xFFFF8800);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: MaterialColor(0xFF0066CC, {
        50: Color(0xFFE6F3FF),
        100: Color(0xFFCCE6FF),
        200: Color(0xFF99CCFF),
        300: Color(0xFF66B3FF),
        400: Color(0xFF3399FF),
        500: Color(0xFF0066CC),
        600: Color(0xFF0052A3),
        700: Color(0xFF003D7A),
        800: Color(0xFF002952),
        900: Color(0xFF001429),
      }),
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryYellow,
        surface: backgroundLight,
        background: backgroundLight,
        error: accentRed,
        onPrimary: textLight,
        onSecondary: textDark,
        onSurface: textDark,
        onBackground: textDark,
        onError: textLight,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDark,
          height: 1.2,
          fontFamily: 'NotoSans',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
          height: 1.2,
          fontFamily: 'NotoSans',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
          height: 1.3,
          fontFamily: 'NotoSans',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textDark,
          height: 1.3,
          fontFamily: 'NotoSans',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
          height: 1.3,
          fontFamily: 'NotoSans',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textDark,
          height: 1.5,
          fontFamily: 'NotoSans',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDark,
          height: 1.5,
          fontFamily: 'NotoSans',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textDark,
          height: 1.5,
          fontFamily: 'NotoSans',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(48, 48), // WCAG minimum touch target
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'NotoSans',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: textLight,
        elevation: 8,
        sizeConstraints: BoxConstraints(minWidth: 56, minHeight: 56),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: textLight,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textLight,
          fontFamily: 'NotoSans',
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryBlue, width: 3),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: backgroundLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(0xFF0066CC, {
        50: Color(0xFFE6F3FF),
        100: Color(0xFFCCE6FF),
        200: Color(0xFF99CCFF),
        300: Color(0xFF66B3FF),
        400: Color(0xFF3399FF),
        500: Color(0xFF0066CC),
        600: Color(0xFF0052A3),
        700: Color(0xFF003D7A),
        800: Color(0xFF002952),
        900: Color(0xFF001429),
      }),
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryYellow,
        secondary: primaryBlue,
        surface: Color(0xFF1A1A1A),
        background: backgroundDark,
        error: Color(0xFFFF4444),
        onPrimary: textDark,
        onSecondary: textLight,
        onSurface: textLight,
        onBackground: textLight,
        onError: textDark,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textLight,
          height: 1.2,
          fontFamily: 'NotoSans',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textLight,
          height: 1.2,
          fontFamily: 'NotoSans',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textLight,
          height: 1.3,
          fontFamily: 'NotoSans',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textLight,
          height: 1.3,
          fontFamily: 'NotoSans',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textLight,
          height: 1.3,
          fontFamily: 'NotoSans',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textLight,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textLight,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textLight,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textLight,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textLight,
          height: 1.5,
          fontFamily: 'NotoSans',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textLight,
          height: 1.5,
          fontFamily: 'NotoSans',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textLight,
          height: 1.5,
          fontFamily: 'NotoSans',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textLight,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textLight,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textLight,
          height: 1.4,
          fontFamily: 'NotoSans',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(48, 48),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'NotoSans',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryYellow,
        foregroundColor: textDark,
        elevation: 8,
        sizeConstraints: BoxConstraints(minWidth: 56, minHeight: 56),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: textLight,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textLight,
          fontFamily: 'NotoSans',
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryYellow, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryYellow, width: 3),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Color(0xFF1A1A1A),
      ),
    );
  }
}
