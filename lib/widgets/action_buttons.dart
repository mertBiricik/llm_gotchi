import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class ActionButtons extends StatelessWidget {
  final Pet pet;
  final PetService petService;
  final VoidCallback onMemoryGame;

  const ActionButtons({
    super.key,
    required this.pet,
    required this.petService,
    required this.onMemoryGame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.zero,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF00FF00), width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PET ACTIONS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF00),
            ),
          ),
          const SizedBox(height: 15),
          
          // Main action buttons
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: [
              _buildActionButton(
                context,
                'Feed',
                Icons.restaurant,
                Colors.orange,
                petService.canPerformAction('feed'),
                petService.getActionCooldown('feed'),
                petService.feedPet,
              ),
              _buildActionButton(
                context,
                'Play',
                Icons.sports_esports,
                Colors.green,
                petService.canPerformAction('play'),
                petService.getActionCooldown('play'),
                petService.playWithPet,
              ),
              _buildActionButton(
                context,
                'Clean',
                Icons.cleaning_services,
                Colors.blue,
                petService.canPerformAction('clean'),
                petService.getActionCooldown('clean'),
                petService.cleanPet,
              ),
              _buildActionButton(
                context,
                pet.isSleeping ? 'Wake' : 'Sleep',
                pet.isSleeping ? Icons.wb_sunny : Icons.bedtime,
                Colors.purple,
                pet.isSleeping || petService.canPerformAction('sleep'),
                pet.isSleeping ? '' : petService.getActionCooldown('sleep'),
                pet.isSleeping ? petService.wakePet : petService.putPetToSleep,
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Memory game button
          SizedBox(
            width: double.infinity,
            child: _buildSpecialActionButton(
              context,
              'Memory Game',
              Icons.psychology,
              Colors.indigo,
              !pet.isDead,
              onMemoryGame,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    bool enabled,
    String cooldown,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? const Color(0xFF00FF00) : const Color(0xFF555555),
        foregroundColor: const Color(0xFF000000),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled ? const Color(0xFF000000) : const Color(0xFF555555),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: enabled ? const Color(0xFF000000) : const Color(0xFF555555),
            ),
          ),
          if (cooldown.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              cooldown.toUpperCase(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: enabled ? const Color(0xFF000000) : const Color(0xFF555555),
              ),
            ),
          ],
        ],
      ),
    ).animate(target: enabled ? 1 : 0)
      .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0))
      .fadeIn();
  }

  Widget _buildSpecialActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    bool enabled,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 24, color: enabled ? const Color(0xFF000000) : const Color(0xFF555555)),
      label: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: enabled ? const Color(0xFF000000) : const Color(0xFF555555),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? const Color(0xFF00FF00) : const Color(0xFF555555),
        foregroundColor: const Color(0xFF000000),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ).animate(target: enabled ? 1 : 0)
      .scale(begin: const Offset(0.98, 0.98), end: const Offset(1.0, 1.0))
      .shimmer(
        duration: 2000.ms,
        color: Colors.white.withOpacity(0.3),
      );
  }
} 