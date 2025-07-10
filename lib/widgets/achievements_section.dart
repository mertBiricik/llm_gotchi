import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/achievement.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsSection({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final unlockedCount = achievements.where((a) => a.unlocked).length;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.zero,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF00FFFF), width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFF00FFFF),
                size: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'ACHIEVEMENTS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00FFFF),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFF00FFFF),
                  borderRadius: BorderRadius.zero,
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xFF000000), width: 1),
                  ),
                ),
                child: Text(
                  '$unlockedCount/${achievements.length}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Progress indicator
          Container(
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF000000),
              borderRadius: BorderRadius.zero,
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFF00FFFF), width: 1),
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: unlockedCount / achievements.length,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF00FFFF),
                  borderRadius: BorderRadius.zero,
                ),
              ).animate()
                .scale(duration: 800.ms, curve: Curves.easeOutQuart),
            ),
          ),
          const SizedBox(height: 15),
          
          // Achievements list
          ...achievements.asMap().entries.map((entry) {
            final index = entry.key;
            final achievement = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: index < achievements.length - 1 ? 12 : 0),
              child: _buildAchievementItem(achievement, index),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.unlocked 
            ? const Color(0xFF00FFFF)
            : const Color(0xFF000000),
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: achievement.unlocked 
              ? const Color(0xFF000000)
              : const Color(0xFF555555),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Achievement icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: achievement.unlocked 
                  ? const Color(0xFF000000)
                  : const Color(0xFF555555),
              borderRadius: BorderRadius.zero,
              border: const Border.fromBorderSide(
                BorderSide(color: Color(0xFF00FFFF), width: 1),
              ),
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 20,
                  color: achievement.unlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Achievement details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: achievement.unlocked 
                        ? const Color(0xFF000000)
                        : const Color(0xFF00FF00),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: achievement.unlocked 
                        ? const Color(0xFF000000)
                        : const Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
          
          // Status indicator
          if (achievement.unlocked)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ).animate()
              .scale(delay: Duration(milliseconds: index * 100))
              .fadeIn(delay: Duration(milliseconds: index * 100)),
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 50))
      .slideX(begin: 0.3, duration: 600.ms, curve: Curves.easeOut)
      .fadeIn();
  }
} 