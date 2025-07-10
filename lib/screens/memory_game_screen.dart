import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../services/pet_service.dart';
import '../models/memory_game.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _cardAnimationController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Start the game when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetService>().startMemoryGame();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Memory Game',
          style: GoogleFonts.comicNeue(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<PetService>(
            builder: (context, petService, child) {
              final game = petService.memoryGame;
              
              // Trigger confetti when game is won
              if (game.gameWon) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _confettiController.play();
                });
              }

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Game Status
                        _buildGameStatus(game),
                        const SizedBox(height: 20),

                        // Game Grid
                        Expanded(
                          child: _buildGameGrid(context, petService, game),
                        ),

                        // Action Buttons
                        const SizedBox(height: 20),
                        _buildActionButtons(context, petService, game),
                      ],
                    ),
                  ),

                  // Confetti
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: 3.14 / 2,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGameStatus(MemoryGame game) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            game.gameWon ? '🎉 You Won!' : 'Find the matching pairs!',
            style: GoogleFonts.comicNeue(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusItem(
                'Pairs Found',
                '${game.matchedPairs}/8',
                Icons.check_circle,
              ),
              _buildStatusItem(
                'Status',
                game.gameWon ? 'Complete!' : 'Playing',
                game.gameWon ? Icons.celebration : Icons.games,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGameGrid(BuildContext context, PetService petService, MemoryGame game) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: game.cards.length,
        itemBuilder: (context, index) {
          return _buildMemoryCard(context, petService, game.cards[index]);
        },
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context, PetService petService, MemoryCard card) {
    return GestureDetector(
      onTap: () {
        if (petService.memoryGame.canFlipCard(card.index)) {
          _cardAnimationController.forward().then((_) {
            petService.onMemoryCardTapped(card.index);
            _cardAnimationController.reverse();
          });
        }
      },
      child: AnimatedBuilder(
        animation: _cardAnimationController,
        builder: (context, child) {
          final isFlipping = _cardAnimationController.value > 0.0;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_cardAnimationController.value * 3.14159),
            child: Container(
              decoration: BoxDecoration(
                color: card.isMatched
                    ? Colors.green.withOpacity(0.8)
                    : card.isFlipped || isFlipping
                        ? Colors.white
                        : Colors.blue.shade600,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: card.isMatched
                      ? Colors.green
                      : card.isFlipped || isFlipping
                          ? Colors.grey.shade300
                          : Colors.blue.shade800,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  card.displaySymbol,
                  style: TextStyle(
                    fontSize: 28,
                    color: card.isFlipped || card.isMatched || isFlipping
                        ? Colors.black87
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PetService petService, MemoryGame game) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            petService.startMemoryGame();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('New Game'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.home),
          label: const Text('Back Home'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
} 