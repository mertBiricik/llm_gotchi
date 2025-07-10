import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/pet_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PixelPairApp());
}

class PixelPairApp extends StatelessWidget {
  const PixelPairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetService(),
      child: MaterialApp(
        title: 'PixelPair',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00FF00), // Bright green
            secondary: Color(0xFFFF00FF), // Magenta
            tertiary: Color(0xFF00FFFF), // Cyan
            background: Color(0xFF000000), // Black
            surface: Color(0xFF1F1F1F), // Dark gray
            onPrimary: Color(0xFF000000),
            onSecondary: Color(0xFF000000),
            onBackground: Color(0xFF00FF00),
            onSurface: Color(0xFF00FF00),
          ),
          useMaterial3: false,
          fontFamily: 'monospace',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'monospace', fontSize: 32, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontFamily: 'monospace', fontSize: 28, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontFamily: 'monospace', fontSize: 24, fontWeight: FontWeight.bold),
            headlineLarge: TextStyle(fontFamily: 'monospace', fontSize: 22, fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontFamily: 'monospace', fontSize: 20, fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold),
            titleSmall: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontFamily: 'monospace', fontSize: 14),
            bodyMedium: TextStyle(fontFamily: 'monospace', fontSize: 12),
            bodySmall: TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F1F1F),
            foregroundColor: Color(0xFF00FF00),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'monospace',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF00),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF00),
              foregroundColor: const Color(0xFF000000),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Square corners for pixel style
              ),
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF00FF00),
            foregroundColor: Color(0xFF000000),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Square FAB
            ),
          ),
          cardTheme: const CardThemeData(
            color: Color(0xFF1F1F1F),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Square cards
              side: BorderSide(color: Color(0xFF00FF00), width: 2),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero, // Square inputs
              borderSide: BorderSide(color: Color(0xFF00FF00), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Color(0xFF00FF00), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Color(0xFFFF00FF), width: 2),
            ),
            filled: true,
            fillColor: Color(0xFF000000),
            labelStyle: TextStyle(color: Color(0xFF00FF00), fontFamily: 'monospace'),
            hintStyle: TextStyle(color: Color(0xFF555555), fontFamily: 'monospace'),
          ),
          scaffoldBackgroundColor: const Color(0xFF000000),
        ),
        home: const HomeScreen(),
      ),
    );
  }
} 