import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/daily_challenge.dart';

class DailyChallengesSection extends StatefulWidget {
  final List<DailyChallenge> challenges;
  final Function(DailyChallenge challenge)? onChallengeComplete;
  final VoidCallback? onViewAllChallenges;

  const DailyChallengesSection({
    super.key,
    required this.challenges,
    this.onChallengeComplete,
    this.onViewAllChallenges,
  });

  @override
  State<DailyChallengesSection> createState() => _DailyChallengeSectionState();
}

class _DailyChallengeSectionState extends State<DailyChallengesSection>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_shimmerController);
    
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeChallenges = widget.challenges
        .where((c) => c.isActive)
        .take(3)
        .toList();

    if (activeChallenges.isEmpty) {
      return _buildNoChallengesCard();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.zero,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFFF00FF), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF00FF),
                    borderRadius: BorderRadius.zero,
                    border: Border.fromBorderSide(
                      BorderSide(color: Color(0xFF000000), width: 2),
                    ),
                  ),
                  child: const Text(
                    '[!]',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFF000000),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAILY CHALLENGES',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF00FF),
                        ),
                      ),
                      Text(
                        'COMPLETE TOGETHER FOR REWARDS!',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Color(0xFF00FFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onViewAllChallenges != null)
                  TextButton(
                    onPressed: widget.onViewAllChallenges,
                    child: const Text(
                      'VIEW ALL',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF00FF00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Challenges List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: activeChallenges
                  .asMap()
                  .entries
                  .map((entry) => _buildChallengeCard(
                        entry.value,
                        entry.key,
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(DailyChallenge challenge, int index) {
    final progress = challenge.progressPercentage;
    final isCompleted = challenge.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted
              ? const Color(0xFF00FF00)
              : const Color(0xFF000000),
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: isCompleted 
                ? const Color(0xFF000000)
                : _getChallengeTypeColor(challenge.type),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge Header
            Row(
              children: [
                // Emoji and Type Badge
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getChallengeTypeColor(challenge.type),
                    borderRadius: BorderRadius.zero,
                    border: const Border.fromBorderSide(
                      BorderSide(color: Color(0xFF000000), width: 1),
                    ),
                  ),
                  child: Text(
                    challenge.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              challenge.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                                decoration: isCompleted 
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          _buildDifficultyBadge(challenge.difficulty),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Completion Status
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ).animate()
                    .scale(duration: 500.ms, curve: Curves.bounceOut)
                    .rotate(duration: 500.ms),
              ],
            ),

            const SizedBox(height: 12),

            // Progress Bar
            if (!isCompleted) ...[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getChallengeTypeColor(challenge.type),
                                    _getChallengeTypeColor(challenge.type).withOpacity(0.7),
                                  ],
                                  stops: [
                                    (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                                    (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getChallengeTypeColor(challenge.type),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Rewards and Time
            Row(
              children: [
                // XP Reward
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.orange.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${challenge.xpReward} XP',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Happiness Reward
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.pink.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, size: 12, color: Colors.pink.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '+${challenge.happinessReward}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Time Remaining
                Text(
                  challenge.timeRemaining,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideX(begin: 0.2, duration: const Duration(milliseconds: 600)),
    );
  }

  Widget _buildDifficultyBadge(ChallengeDifficulty difficulty) {
    Color color;
    String text;
    
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        color = Colors.green;
        text = 'Easy';
        break;
      case ChallengeDifficulty.medium:
        color = Colors.orange;
        text = 'Medium';
        break;
      case ChallengeDifficulty.hard:
        color = Colors.red;
        text = 'Hard';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
      ),
    );
  }

  Widget _buildNoChallengesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.zero,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFFF00FF), width: 3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFF00FF),
              borderRadius: BorderRadius.zero,
            ),
            child: const Text(
              '[*]',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 32,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'NO ACTIVE CHALLENGES',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF00),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'NEW CHALLENGES APPEAR DAILY.\nCHECK BACK TOMORROW!',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: Color(0xFF00FFFF),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getChallengeTypeColor(ChallengeType type) {
    switch (type) {
      case ChallengeType.care:
        return Colors.blue.shade400;
      case ChallengeType.bonding:
        return Colors.pink.shade400;
      case ChallengeType.memory:
        return Colors.purple.shade400;
      case ChallengeType.achievement:
        return Colors.orange.shade400;
    }
  }
} 