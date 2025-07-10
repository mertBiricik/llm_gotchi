import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/pet_service.dart';
import 'screens/home_screen.dart';
import 'theme/retro_theme.dart';

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
        theme: RetroTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
} 