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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pet Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
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
        backgroundColor: enabled ? color : Colors.grey.shade300,
        foregroundColor: Colors.white,
        elevation: enabled ? 3 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled ? Colors.white : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: enabled ? Colors.white : Colors.grey.shade500,
            ),
          ),
          if (cooldown.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              cooldown,
              style: TextStyle(
                fontSize: 10,
                color: enabled ? Colors.white70 : Colors.grey.shade400,
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
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? color : Colors.grey.shade300,
        foregroundColor: Colors.white,
        elevation: enabled ? 5 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
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