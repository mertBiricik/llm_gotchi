import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../theme/retro_theme.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsSection({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: RetroTheme.deepBlack,
        border: Border.all(color: RetroTheme.primaryGreen, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACHIEVEMENTS',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          
          // Achievement grid - 3x2 layout
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1.0,
            ),
            itemCount: 6, // Show 6 achievement slots
            itemBuilder: (context, index) {
              if (index < achievements.length) {
                return _buildAchievementIcon(context, achievements[index]);
              } else {
                return _buildEmptyAchievementSlot(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementIcon(BuildContext context, Achievement achievement) {
    return Container(
      decoration: BoxDecoration(
        color: RetroTheme.deepBlack,
        border: Border.all(
          color: achievement.unlocked ? RetroTheme.primaryGreen : Colors.grey,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          achievement.icon,
          style: TextStyle(
            color: achievement.unlocked ? RetroTheme.primaryGreen : Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAchievementSlot(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RetroTheme.deepBlack,
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.lock,
          color: Colors.grey,
          size: 12,
        ),
      ),
    );
  }
} 