import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';
import '../theme/retro_theme.dart';

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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: RetroTheme.deepBlack,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: RetroTheme.primaryGreen, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PET ACTIONS',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          
          // Action buttons in 2x2 grid
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'FEED',
                  Icons.restaurant,
                  RetroTheme.redButtonStyle(),
                  petService.canPerformAction('feed'),
                  petService.getActionCooldown('feed'),
                  petService.feedPet,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  context,
                  'PLAY',
                  Icons.sports_esports,
                  RetroTheme.greenButtonStyle(),
                  petService.canPerformAction('play'),
                  petService.getActionCooldown('play'),
                  petService.playWithPet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'CLEAN',
                  Icons.cleaning_services,
                  RetroTheme.blueButtonStyle(),
                  petService.canPerformAction('clean'),
                  petService.getActionCooldown('clean'),
                  petService.cleanPet,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  context,
                  pet.isSleeping ? 'WAKE' : 'SLEEP',
                  pet.isSleeping ? Icons.wb_sunny : Icons.bedtime,
                  RetroTheme.magentaButtonStyle(),
                  pet.isSleeping || petService.canPerformAction('sleep'),
                  pet.isSleeping ? '' : petService.getActionCooldown('sleep'),
                  pet.isSleeping ? petService.wakePet : petService.putPetToSleep,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Memory game button - full width
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: !pet.isDead ? onMemoryGame : null,
              style: !pet.isDead 
                ? RetroTheme.greenButtonStyle() 
                : RetroTheme.greenButtonStyle().copyWith(
                    foregroundColor: WidgetStateProperty.all(Colors.grey),
                    side: WidgetStateProperty.all(const BorderSide(color: Colors.grey, width: 2)),
                  ),
              child: Text(
                'MEMORY GAME',
                style: Theme.of(context).textTheme.labelLarge,
              ),
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
    ButtonStyle style,
    bool enabled,
    String cooldown,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: enabled 
          ? style 
          : style.copyWith(
              foregroundColor: WidgetStateProperty.all(Colors.grey),
              side: WidgetStateProperty.all(const BorderSide(color: Colors.grey, width: 2)),
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 8,
                height: 1.0,
              ),
            ),
            if (cooldown.isNotEmpty) ...[
              Text(
                cooldown,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 6,
                  height: 1.0,
                ),
              ),
            ],
          ],
        ),
      ).animate(target: enabled ? 1 : 0)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0))
        .fadeIn(),
    );
  }
} 