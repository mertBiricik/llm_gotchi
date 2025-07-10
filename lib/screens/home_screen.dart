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
import '../widgets/daily_challenges_section.dart';
import '../models/daily_challenge.dart';
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
  bool _showNewAchievement = false;

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

  void _showPetCustomizationDialog(BuildContext context, PetService petService) {
    final TextEditingController nameController = TextEditingController(
      text: petService.pet.name,
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.zero,
              color: Color(0xFF1F1F1F),
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFF00FF00), width: 3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.edit,
                      color: Color(0xFF00FF00),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'CUSTOMIZE PET',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FF00),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Pet Name
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF00FF00),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'PET NAME',
                    hintText: 'ENTER A NAME...',
                    prefixIcon: Icon(Icons.pets, color: Color(0xFF00FF00)),
                    labelStyle: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFF00FF00),
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFF555555),
                    ),
                  ),
                  maxLength: 20,
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                                              child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: const Color(0xFF555555),
                        ),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final newName = nameController.text.trim();
                          if (newName.isNotEmpty) {
                            // Update pet name
                            final updatedPet = petService.pet.copyWith(name: newName);
                            // This would need to be implemented in PetService
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('PET RENAMED TO "$newName"!', 
                                  style: const TextStyle(fontFamily: 'monospace')),
                                backgroundColor: const Color(0xFF00FF00),
                                behavior: SnackBarBehavior.floating,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            );
                          }
                          Navigator.of(dialogContext).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FF00),
                          foregroundColor: const Color(0xFF000000),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDailyTip(BuildContext context) {
    final tips = [
      'PETS NEED REGULAR INTERACTION!',
      'MEMORY GAME BOOSTS INTELLIGENCE!',
      'SEND MESSAGES TO YOUR PARTNER!',
      'LOW ENERGY? LET PET SLEEP!',
      'CLEAN YOUR PET REGULARLY!',
      'A WELL-FED PET IS HAPPY!',
    ];
    
    final randomTip = (tips..shuffle()).first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.zero,
              color: Color(0xFF1F1F1F),
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFFFF00FF), width: 3),
              ),
            ),
                          child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '[?]',
                    style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'monospace',
                      color: Color(0xFFFF00FF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DAILY TIP',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF00FF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    randomTip,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF00FF00),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF00FF),
                      foregroundColor: const Color(0xFF000000),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'GOT IT!',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF000000), // Solid black background for pixel theme
        ),
        child: SafeArea(
          child: Consumer<PetService>(
            builder: (context, petService, child) {
              // Check for new achievements and trigger confetti
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final newAchievements = petService.achievements
                    .where((a) => a.unlocked)
                    .toList();
                
                if (newAchievements.isNotEmpty && !_showNewAchievement) {
                  _showNewAchievement = true;
                  _triggerConfetti();
                  
                  // Reset flag after delay
                  Future.delayed(const Duration(seconds: 5), () {
                    if (mounted) {
                      setState(() {
                        _showNewAchievement = false;
                      });
                    }
                  });
                }
              });

              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      // Refresh pet stats
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Enhanced Header
                          _buildEnhancedHeader(context, petService),
                          const SizedBox(height: 24),

                          // Enhanced Pet Display with interactions
                          AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellow.withOpacity(
                                        _glowAnimation.value * 0.5,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: PetDisplay(
                                  pet: petService.pet,
                                  onPetTap: () {
                                    // Show loving interaction
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${petService.pet.name.toUpperCase()} LOVES YOU!',
                                          style: const TextStyle(fontFamily: 'monospace')),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: const Color(0xFFFF00FF),
                                        behavior: SnackBarBehavior.floating,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    );
                                  },
                                  onPetCustomize: () => _showPetCustomizationDialog(context, petService),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Enhanced Stats Grid
                          StatsGrid(pet: petService.pet),
                          const SizedBox(height: 24),

                          // Action Buttons
                          ActionButtons(
                            pet: petService.pet,
                            petService: petService,
                            onMemoryGame: () => _navigateToMemoryGame(context),
                          ),
                          const SizedBox(height: 24),

                          // Message Section
                          MessageSection(petService: petService),
                          const SizedBox(height: 24),

                          // Daily Challenges Section
                          DailyChallengesSection(
                            challenges: _getSampleChallenges(),
                            onChallengeComplete: (challenge) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('CHALLENGE COMPLETED! +${challenge.xpReward} XP',
                                    style: const TextStyle(fontFamily: 'monospace')),
                                  backgroundColor: const Color(0xFF00FF00),
                                  behavior: SnackBarBehavior.floating,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              );
                            },
                            onViewAllChallenges: () {
                              _showAllChallengesDialog(context);
                            },
                          ),
                          const SizedBox(height: 24),

                          // Achievements Section
                          AchievementsSection(achievements: petService.achievements),
                          const SizedBox(height: 24),

                          // Sharing Section
                          SharingSection(petService: petService),
                          const SizedBox(height: 24),

                          // Daily Tip Button
                          _buildDailyTipButton(context),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Confetti Effect
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: 3.14 / 2, // Down
                      emissionFrequency: 0.1,
                      numberOfParticles: 30,
                      maxBlastForce: 120,
                      minBlastForce: 80,
                      gravity: 0.3,
                      colors: const [
                        Colors.yellow,
                        Colors.orange,
                        Colors.pink,
                        Colors.purple,
                        Colors.green,
                        Colors.blue,
                      ],
                    ),
                  ),

                  // Enhanced Sound Toggle Button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.zero,
                        border: Border.fromBorderSide(
                          BorderSide(color: Color(0xFF00FF00), width: 2),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await petService.soundService.toggleSound();
                          setState(() {});
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                petService.soundService.soundEnabled
                                    ? 'SOUND ENABLED'
                                    : 'SOUND DISABLED',
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: const Color(0xFF00FFFF),
                              behavior: SnackBarBehavior.floating,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          petService.soundService.soundEnabled
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: const Color(0xFF00FF00),
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // New Achievement Notification
                  if (_showNewAchievement)
                    Positioned(
                      top: 80,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.zero,
                          border: Border.fromBorderSide(
                            BorderSide(color: Color(0xFFFF00FF), width: 3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text('[*]', style: TextStyle(
                              fontSize: 24, 
                              fontFamily: 'monospace',
                              color: Color(0xFFFF00FF),
                            )),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'NEW ACHIEVEMENT UNLOCKED!',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00FF00),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildEnhancedHeader(BuildContext context, PetService petService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.zero,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF00FF00), width: 3),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'PIXELPAIR',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF00),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '8-BIT LOVE, SHARED PIXELS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              color: Color(0xFF00FFFF),
            ),
          ),
          if (petService.pet.isDead) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFFF0000),
                borderRadius: BorderRadius.zero,
                border: Border.fromBorderSide(
                  BorderSide(color: Color(0xFFFFFFFF), width: 2),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, color: Color(0xFFFFFFFF), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'PET NEEDS RESURRECTION',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDailyTipButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showDailyTip(context),
        icon: const Icon(Icons.lightbulb, size: 20),
        label: const Text(
          'DAILY CARE TIP',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF00FF),
          foregroundColor: const Color(0xFF000000),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _navigateToMemoryGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MemoryGameScreen(),
      ),
    );
  }

  List<DailyChallenge> _getSampleChallenges() {
    final now = DateTime.now();
    return [
      DailyChallenge(
        id: 'care_today_1',
        title: 'Perfect Care Day',
        description: 'Feed, clean, and play with your pet',
        emoji: '✨',
        type: ChallengeType.care,
        difficulty: ChallengeDifficulty.medium,
        xpReward: 75,
        happinessReward: 15,
        createdAt: now,
        expiresAt: now.add(const Duration(hours: 18)),
        requirements: ['feed', 'clean', 'play'],
        progress: {'feed': true, 'clean': false, 'play': false},
      ),
      DailyChallenge(
        id: 'bonding_today_1',
        title: 'Love Exchange',
        description: 'Send 3 loving messages to your partner',
        emoji: '💌',
        type: ChallengeType.bonding,
        difficulty: ChallengeDifficulty.easy,
        xpReward: 60,
        happinessReward: 12,
        createdAt: now,
        expiresAt: now.add(const Duration(hours: 20)),
        requirements: ['send_messages_3'],
        progress: {},
      ),
      DailyChallenge(
        id: 'memory_today_1',
        title: 'Memory Masters',
        description: 'Complete the memory game together',
        emoji: '🧠',
        type: ChallengeType.memory,
        difficulty: ChallengeDifficulty.medium,
        xpReward: 100,
        happinessReward: 20,
        createdAt: now,
        expiresAt: now.add(const Duration(hours: 22)),
        requirements: ['complete_memory_game'],
        progress: {},
      ),
    ];
  }

  void _showAllChallengesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.zero,
              color: Color(0xFF1F1F1F),
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFF00FF00), width: 3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Color(0xFF00FF00),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'ALL DAILY CHALLENGES',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00FF00),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Color(0xFF00FF00)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Challenges List
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DailyChallengesSection(
                          challenges: _getSampleChallenges(),
                          onChallengeComplete: (challenge) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Challenge completed! +${challenge.xpReward} XP 🎉'),
                                backgroundColor: Colors.green.shade400,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Future challenges preview
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF000000),
                            borderRadius: BorderRadius.zero,
                            border: Border.fromBorderSide(
                              BorderSide(color: Color(0xFF00FFFF), width: 2),
                            ),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'TOMORROW\'S PREVIEW',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00FFFF),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'NEW EXCITING CHALLENGES WILL BE AVAILABLE TOMORROW!\nINCLUDING COUPLE BONDING ACTIVITIES AND PET EVOLUTION TASKS.',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: Color(0xFF00FF00),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF00),
                      foregroundColor: const Color(0xFF000000),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'LET\'S GO!',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 