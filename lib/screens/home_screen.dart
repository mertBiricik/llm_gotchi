import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../services/pet_service.dart';
import '../widgets/pet_display.dart';
import '../widgets/stats_grid.dart';
import '../widgets/action_buttons.dart';
import '../widgets/achievements_section.dart';
import '../widgets/message_section.dart';
import '../theme/retro_theme.dart';
import 'memory_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroTheme.deepBlack,
      body: SafeArea(
        child: Consumer<PetService>(
          builder: (context, petService, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Title Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroTheme.deepBlack,
                      border: Border.all(color: RetroTheme.primaryGreen, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'PIXELPAIR',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            letterSpacing: 4.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '8-BIT LOVE CONNECTION',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: RetroTheme.terminalAmber,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Pet Display Section
                  PetDisplay(
                    pet: petService.pet,
                    onPetTap: () {
                      petService.playWithPet();
                      _confettiController.play();
                    },
                  ),

                  const SizedBox(height: 8),

                  // Stats Grid
                  StatsGrid(pet: petService.pet),

                  const SizedBox(height: 8),

                  // Action Buttons
                  ActionButtons(
                    pet: petService.pet,
                    petService: petService,
                    onMemoryGame: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MemoryGameScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // Message Section
                  const MessageSection(),

                  const SizedBox(height: 8),

                  // Achievements Section
                  AchievementsSection(
                    achievements: petService.achievements,
                  ),

                  const SizedBox(height: 8),

                  // Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroTheme.deepBlack,
                      border: Border.all(color: RetroTheme.primaryGreen, width: 2),
                    ),
                    child: Text(
                      'PRESS START TO CONTINUE • PIXELPAIR v1.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 