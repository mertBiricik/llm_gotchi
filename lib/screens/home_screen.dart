import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/pet_service.dart';
import '../widgets/pet_display.dart';
import '../widgets/stats_grid.dart';
import '../widgets/action_buttons.dart';
import '../widgets/achievements_section.dart';
import '../widgets/message_section.dart';
import '../widgets/sharing_section.dart';
import 'memory_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    _confettiController.play();
    _glowController.forward().then((_) {
      _glowController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<PetService>(
            builder: (context, petService, child) {
              // Check for new achievements and trigger confetti
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (petService.achievements.any((a) => a.unlocked)) {
                  _triggerConfetti();
                }
              });

              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Header
                        _buildHeader(context, petService),
                        const SizedBox(height: 20),

                        // Pet Display
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow.withOpacity(_glowAnimation.value * 0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: PetDisplay(pet: petService.pet),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Stats Grid
                        StatsGrid(pet: petService.pet),
                        const SizedBox(height: 20),

                        // Action Buttons
                        ActionButtons(
                          pet: petService.pet,
                          petService: petService,
                          onMemoryGame: () => _navigateToMemoryGame(context),
                        ),
                        const SizedBox(height: 20),

                        // Message Section
                        MessageSection(petService: petService),
                        const SizedBox(height: 20),

                        // Achievements Section
                        AchievementsSection(achievements: petService.achievements),
                        const SizedBox(height: 20),

                        // Sharing Section
                        SharingSection(petService: petService),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Confetti
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: 3.14 / 2, // Down
                      emissionFrequency: 0.1,
                      numberOfParticles: 20,
                      maxBlastForce: 100,
                      minBlastForce: 80,
                      gravity: 0.3,
                    ),
                  ),

                  // Sound toggle button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () async {
                        await petService.soundService.toggleSound();
                        setState(() {});
                      },
                      icon: Icon(
                        petService.soundService.soundEnabled
                            ? Icons.volume_up
                            : Icons.volume_off,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PetService petService) {
    return Column(
      children: [
        Text(
          'TenderTouch',
          style: GoogleFonts.comicNeue(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Gentle Care, Shared Love',
          style: GoogleFonts.comicNeue(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        if (petService.pet.isDead) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.healing, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Pet needs revival',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: petService.resetPet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Revive', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _navigateToMemoryGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MemoryGameScreen()),
    );
  }
} 