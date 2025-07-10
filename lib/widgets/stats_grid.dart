import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pet.dart';

class StatsGrid extends StatefulWidget {
  final Pet pet;

  const StatsGrid({
    super.key,
    required this.pet,
  });

  @override
  State<StatsGrid> createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Pet Vitals',
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getOverallHealthColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getOverallHealthColor().withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getOverallHealthText(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getOverallHealthColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildEnhancedStatCard(
                'Health',
                widget.pet.health,
                Icons.favorite,
                Colors.red.shade400,
                _getHealthTrend(),
                _getHealthAdvice(),
                isGoodWhenHigh: true,
              ),
              _buildEnhancedStatCard(
                'Hunger',
                100 - widget.pet.hunger,
                Icons.restaurant,
                Colors.orange.shade400,
                _getHungerTrend(),
                _getHungerAdvice(),
                isGoodWhenHigh: true,
              ),
              _buildEnhancedStatCard(
                'Happiness',
                widget.pet.happiness,
                Icons.sentiment_very_satisfied,
                Colors.pink.shade400,
                _getHappinessTrend(),
                _getHappinessAdvice(),
                isGoodWhenHigh: true,
              ),
              _buildEnhancedStatCard(
                'Energy',
                widget.pet.energy,
                Icons.battery_charging_full,
                Colors.blue.shade400,
                _getEnergyTrend(),
                _getEnergyAdvice(),
                isGoodWhenHigh: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Care Recommendations
          _buildCareRecommendations(),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    String label,
    int value,
    IconData icon,
    Color baseColor,
    String trend,
    String advice,
    {required bool isGoodWhenHigh}
  ) {
    final percentage = value / 100.0;
    final statColor = _getStatColor(value, baseColor, isGoodWhenHigh);
    final isLow = value < 30;
    final isHigh = value > 80;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final shouldPulse = isLow && isGoodWhenHigh;
        final scale = shouldPulse ? _pulseAnimation.value : 1.0;
        
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  statColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: shouldPulse 
                  ? statColor.withOpacity(0.5)
                  : Colors.grey.shade200,
                width: shouldPulse ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: statColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and trend
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: statColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: statColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            trend,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                // Value display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: statColor,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontSize: 14,
                        color: statColor.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    _buildStatIcon(value, isGoodWhenHigh),
                  ],
                ),

                const SizedBox(height: 8),

                // Animated progress bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                statColor.withOpacity(0.7),
                                statColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: statColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ).animate()
                          .scaleX(
                            duration: 1000.ms,
                            curve: Curves.easeOutQuart,
                          )
                          .shimmer(
                            duration: 2000.ms,
                            color: Colors.white.withOpacity(0.5),
                          ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Advice text
                Text(
                  advice,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatIcon(int value, bool isGoodWhenHigh) {
    IconData icon;
    Color color;
    
    if (isGoodWhenHigh) {
      if (value >= 80) {
        icon = Icons.trending_up;
        color = Colors.green;
      } else if (value >= 50) {
        icon = Icons.trending_flat;
        color = Colors.orange;
      } else {
        icon = Icons.trending_down;
        color = Colors.red;
      }
    } else {
      if (value <= 20) {
        icon = Icons.trending_up;
        color = Colors.green;
      } else if (value <= 50) {
        icon = Icons.trending_flat;
        color = Colors.orange;
      } else {
        icon = Icons.trending_down;
        color = Colors.red;
      }
    }

    return Icon(
      icon,
      size: 16,
      color: color,
    );
  }

  Widget _buildCareRecommendations() {
    final recommendations = _getCareRecommendations();
    
    if (recommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your pet is doing great! Keep up the good work! 🌟',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Care Recommendations',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        ...recommendations.map((rec) => _buildRecommendationItem(rec)),
      ],
    );
  }

  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              recommendation,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Trend analysis methods
  String _getHealthTrend() {
    if (widget.pet.health >= 80) return 'Excellent';
    if (widget.pet.health >= 60) return 'Good';
    if (widget.pet.health >= 40) return 'Fair';
    return 'Needs attention';
  }

  String _getHungerTrend() {
    final fullness = 100 - widget.pet.hunger;
    if (fullness >= 80) return 'Well fed';
    if (fullness >= 60) return 'Content';
    if (fullness >= 40) return 'Getting hungry';
    return 'Very hungry';
  }

  String _getHappinessTrend() {
    if (widget.pet.happiness >= 80) return 'Joyful';
    if (widget.pet.happiness >= 60) return 'Content';
    if (widget.pet.happiness >= 40) return 'Okay';
    return 'Sad';
  }

  String _getEnergyTrend() {
    if (widget.pet.energy >= 80) return 'Energetic';
    if (widget.pet.energy >= 60) return 'Active';
    if (widget.pet.energy >= 40) return 'Tired';
    return 'Exhausted';
  }

  // Advice methods
  String _getHealthAdvice() {
    if (widget.pet.health < 30) return 'Clean and feed regularly';
    if (widget.pet.health < 60) return 'Needs more care';
    return 'Healthy and strong';
  }

  String _getHungerAdvice() {
    if (widget.pet.hunger > 70) return 'Time to feed!';
    if (widget.pet.hunger > 40) return 'Getting hungry';
    return 'Well nourished';
  }

  String _getHappinessAdvice() {
    if (widget.pet.happiness < 30) return 'Play and interact more';
    if (widget.pet.happiness < 60) return 'Needs attention';
    return 'Happy and content';
  }

  String _getEnergyAdvice() {
    if (widget.pet.energy < 30) return 'Let them sleep';
    if (widget.pet.energy < 60) return 'Getting tired';
    return 'Full of energy';
  }

  List<String> _getCareRecommendations() {
    final recommendations = <String>[];
    
    if (widget.pet.health < 50) {
      recommendations.add('Clean your pet to improve health');
    }
    if (widget.pet.hunger > 60) {
      recommendations.add('Feed your pet - they\'re getting hungry');
    }
    if (widget.pet.happiness < 50) {
      recommendations.add('Play with your pet to boost happiness');
    }
    if (widget.pet.energy < 30) {
      recommendations.add('Let your pet sleep to restore energy');
    }
    if (widget.pet.totalInteractions < 5) {
      recommendations.add('Interact more to build a stronger bond');
    }
    
    return recommendations;
  }

  Color _getOverallHealthColor() {
    final average = (widget.pet.health + (100 - widget.pet.hunger) + 
                    widget.pet.happiness + widget.pet.energy) / 4;
    
    if (average >= 80) return Colors.green;
    if (average >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getOverallHealthText() {
    final average = (widget.pet.health + (100 - widget.pet.hunger) + 
                    widget.pet.happiness + widget.pet.energy) / 4;
    
    if (average >= 80) return 'Excellent';
    if (average >= 60) return 'Good';
    if (average >= 40) return 'Fair';
    return 'Poor';
  }

  Color _getStatColor(int value, Color defaultColor, bool isGoodWhenHigh) {
    if (isGoodWhenHigh) {
      if (value >= 70) return Colors.green.shade600;
      if (value >= 40) return Colors.orange.shade600;
      return Colors.red.shade600;
    } else {
      if (value <= 30) return Colors.green.shade600;
      if (value <= 60) return Colors.orange.shade600;
      return Colors.red.shade600;
    }
  }
} 