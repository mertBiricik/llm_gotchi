import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../theme/retro_theme.dart';

class StatsGrid extends StatelessWidget {
  final Pet pet;

  const StatsGrid({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: RetroTheme.deepBlack,
        border: Border.all(color: RetroTheme.primaryGreen, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatBar(context, 'HEALTH', pet.health, RetroTheme.healthColor)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatBar(context, 'HUNGER', pet.hunger, RetroTheme.hungerColor)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildStatBar(context, 'HAPPY', pet.happiness, RetroTheme.happyColor)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatBar(context, 'ENERGY', pet.energy, RetroTheme.energyColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(BuildContext context, String label, int value, Color color) {
    final normalizedValue = (value / 100.0).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 8,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: RetroTheme.deepBlack,
              border: Border.all(color: color, width: 1),
            ),
            child: Stack(
              children: [
                // Background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
                // Progress fill
                FractionallySizedBox(
                  widthFactor: normalizedValue,
                  child: Container(
                    height: double.infinity,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 