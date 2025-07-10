import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetroTheme {
  // Authentic retro terminal colors
  static const Color _terminalGreen = Color(0xFF00FF41);
  static const Color _terminalAmber = Color(0xFFFFB000);
  static const Color _terminalCyan = Color(0xFF00FFFF);
  static const Color _terminalMagenta = Color(0xFFFF00FF);
  static const Color _terminalRed = Color(0xFFFF0040);
  static const Color _terminalBlue = Color(0xFF0080FF);
  static const Color _terminalYellow = Color(0xFFFFFF00);
  static const Color _terminalWhite = Color(0xFFFFFFFF);
  
  // Background colors
  static const Color _deepBlack = Color(0xFF000000);
  static const Color _darkGreen = Color(0xFF003300);
  static const Color _veryDarkGray = Color(0xFF111111);
  static const Color _darkGray = Color(0xFF222222);

  // Create authentic terminal color scheme
  static ColorScheme get _colorScheme => const ColorScheme(
    brightness: Brightness.dark,
    // Primary - bright terminal green
    primary: _terminalGreen,
    onPrimary: _deepBlack,
    primaryContainer: _darkGreen,
    onPrimaryContainer: _terminalGreen,
    
    // Secondary - terminal amber/yellow
    secondary: _terminalAmber,
    onSecondary: _deepBlack,
    secondaryContainer: _darkGray,
    onSecondaryContainer: _terminalAmber,
    
    // Tertiary - terminal cyan
    tertiary: _terminalCyan,
    onTertiary: _deepBlack,
    tertiaryContainer: _darkGray,
    onTertiaryContainer: _terminalCyan,
    
    // Error - terminal red
    error: _terminalRed,
    onError: _deepBlack,
    errorContainer: _darkGray,
    onErrorContainer: _terminalRed,
    
    // Surface colors - pure black terminal style
    surface: _deepBlack,
    onSurface: _terminalGreen,
    surfaceContainerHighest: _veryDarkGray,
    onSurfaceVariant: _darkGray,
    
    // Borders and outlines
    outline: _terminalGreen,
    outlineVariant: _darkGreen,
    shadow: _deepBlack,
    scrim: _deepBlack,
    inverseSurface: _terminalGreen,
    onInverseSurface: _deepBlack,
    inversePrimary: _deepBlack,
  );

  // Authentic terminal/monospace text theme
  static TextTheme get _textTheme => TextTheme(
    // Headers - bright terminal green
    displayLarge: GoogleFonts.courierPrime(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 2.0,
      height: 1.0,
    ),
    displayMedium: GoogleFonts.courierPrime(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 1.5,
      height: 1.0,
    ),
    displaySmall: GoogleFonts.courierPrime(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 1.0,
      height: 1.0,
    ),
    
    // Headlines
    headlineLarge: GoogleFonts.courierPrime(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 1.0,
      height: 1.0,
    ),
    headlineMedium: GoogleFonts.courierPrime(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 0.5,
      height: 1.0,
    ),
    headlineSmall: GoogleFonts.courierPrime(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 0.5,
      height: 1.0,
    ),
    
    // Titles
    titleLarge: GoogleFonts.courierPrime(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 1.0,
      height: 1.0,
    ),
    titleMedium: GoogleFonts.courierPrime(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 0.5,
      height: 1.0,
    ),
    titleSmall: GoogleFonts.courierPrime(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 0.5,
      height: 1.0,
    ),
    
    // Body text
    bodyLarge: GoogleFonts.courierPrime(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: _terminalGreen,
      height: 1.2,
    ),
    bodyMedium: GoogleFonts.courierPrime(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: _terminalGreen,
      height: 1.2,
    ),
    bodySmall: GoogleFonts.courierPrime(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: _terminalGreen,
      height: 1.2,
    ),
    
    // Labels
    labelLarge: GoogleFonts.courierPrime(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 1.0,
      height: 1.0,
    ),
    labelMedium: GoogleFonts.courierPrime(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 0.5,
      height: 1.0,
    ),
    labelSmall: GoogleFonts.courierPrime(
      fontSize: 8,
      fontWeight: FontWeight.bold,
      color: _terminalGreen,
      letterSpacing: 0.5,
      height: 1.0,
    ),
  );

  // Main retro theme
  static ThemeData get theme => ThemeData(
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    useMaterial3: false, // Keep retro aesthetic
    
    // App Bar - terminal style
    appBarTheme: AppBarTheme(
      backgroundColor: _deepBlack,
      foregroundColor: _terminalGreen,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.courierPrime(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _terminalGreen,
        letterSpacing: 2.0,
      ),
      iconTheme: const IconThemeData(
        color: _terminalGreen,
        size: 20,
      ),
      toolbarHeight: 40,
    ),
    
    // Terminal-style buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _deepBlack,
        foregroundColor: _terminalGreen,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        side: const BorderSide(color: _terminalGreen, width: 2),
        textStyle: GoogleFonts.courierPrime(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 1.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: const Size(60, 32),
      ),
    ),
    
    // Text buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _terminalGreen,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        textStyle: GoogleFonts.courierPrime(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 1.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    ),
    
    // Outlined buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _terminalGreen,
        backgroundColor: _deepBlack,
        side: const BorderSide(color: _terminalGreen, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        textStyle: GoogleFonts.courierPrime(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 1.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    ),
    
    // Cards - terminal window style
    cardTheme: const CardThemeData(
      color: _deepBlack,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: _terminalGreen, width: 2),
      ),
      margin: EdgeInsets.all(4),
    ),
    
    // Input fields - terminal style
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _deepBlack,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: _terminalGreen, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: _terminalGreen, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: _terminalAmber, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: _terminalRed, width: 2),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: _terminalRed, width: 3),
      ),
      labelStyle: GoogleFonts.courierPrime(
        color: _terminalGreen,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: GoogleFonts.courierPrime(
        color: _darkGray,
        fontSize: 10,
      ),
      prefixIconColor: _terminalGreen,
      suffixIconColor: _terminalGreen,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    ),
    
    // Dialog - terminal window
    dialogTheme: DialogThemeData(
      backgroundColor: _deepBlack,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: _terminalGreen, width: 3),
      ),
      titleTextStyle: GoogleFonts.courierPrime(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: _terminalGreen,
        letterSpacing: 1.0,
      ),
      contentTextStyle: GoogleFonts.courierPrime(
        fontSize: 10,
        color: _terminalGreen,
      ),
    ),
    
    // Progress indicators
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _terminalGreen,
      linearTrackColor: _darkGray,
      circularTrackColor: _darkGray,
    ),
    
    // Icons
    iconTheme: const IconThemeData(
      color: _terminalGreen,
      size: 16,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: _deepBlack,
  );

  // Utility methods for specific colored buttons
  static ButtonStyle redButtonStyle() => ElevatedButton.styleFrom(
    backgroundColor: _deepBlack,
    foregroundColor: _terminalRed,
    side: const BorderSide(color: _terminalRed, width: 2),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    textStyle: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 10),
  );

  static ButtonStyle blueButtonStyle() => ElevatedButton.styleFrom(
    backgroundColor: _deepBlack,
    foregroundColor: _terminalBlue,
    side: const BorderSide(color: _terminalBlue, width: 2),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    textStyle: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 10),
  );

  static ButtonStyle magentaButtonStyle() => ElevatedButton.styleFrom(
    backgroundColor: _deepBlack,
    foregroundColor: _terminalMagenta,
    side: const BorderSide(color: _terminalMagenta, width: 2),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    textStyle: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 10),
  );

  static ButtonStyle greenButtonStyle() => ElevatedButton.styleFrom(
    backgroundColor: _deepBlack,
    foregroundColor: _terminalGreen,
    side: const BorderSide(color: _terminalGreen, width: 2),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    textStyle: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 10),
  );

  // Color getters for UI elements
  static Color get healthColor => _terminalRed;
  static Color get hungerColor => _darkGray;
  static Color get happyColor => _terminalGreen;
  static Color get energyColor => _terminalBlue;
  static Color get primaryGreen => _terminalGreen;
  static Color get terminalAmber => _terminalAmber;
  static Color get deepBlack => _deepBlack;
} 