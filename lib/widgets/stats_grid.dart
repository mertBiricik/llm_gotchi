import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pet.dart';

class StatsGrid extends StatelessWidget {
  final Pet pet;

  const StatsGrid({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard('Health', pet.health, Icons.favorite, Colors.red),
        _buildStatCard('Hunger', 100 - pet.hunger, Icons.restaurant, Colors.orange),
        _buildStatCard('Happiness', pet.happiness, Icons.sentiment_very_satisfied, Colors.pink),
        _buildStatCard('Energy', pet.energy, Icons.battery_charging_full, Colors.blue),
      ],
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    final percentage = value / 100.0;
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          // Icon and Label
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: _getStatColor(value, color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ).animate()
                .scale(duration: 800.ms, curve: Curves.easeOutQuart)
                .fadeIn(duration: 600.ms),
            ),
          ),
          const SizedBox(height: 8),

          // Value Text
          Text(
            '$value%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getStatColor(value, color),
            ),
          ).animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideX(begin: 0.3, duration: 600.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }

  Color _getStatColor(int value, Color defaultColor) {
    if (value >= 70) {
      return Colors.green;
    } else if (value >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
} 