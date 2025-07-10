enum ChallengeType {
  care,          // Pet care activities
  bonding,       // Couple bonding activities
  memory,        // Memory and learning activities
  achievement,   // Achievement-based challenges
}

enum ChallengeDifficulty {
  easy,
  medium,
  hard,
}

class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final ChallengeType type;
  final ChallengeDifficulty difficulty;
  final int xpReward;
  final int happinessReward;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isCompleted;
  final List<String> requirements;
  final Map<String, dynamic> progress;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.type,
    required this.difficulty,
    required this.xpReward,
    required this.happinessReward,
    required this.createdAt,
    required this.expiresAt,
    this.isCompleted = false,
    this.requirements = const [],
    this.progress = const {},
  });

  // Business logic constants
  static const int baseXpReward = 50;
  static const int baseHappinessReward = 10;
  static const Duration challengeDuration = Duration(hours: 24);

  int get difficultyMultiplier {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return 1;
      case ChallengeDifficulty.medium:
        return 2;
      case ChallengeDifficulty.hard:
        return 3;
    }
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  bool get isActive => !isCompleted && !isExpired;

  double get progressPercentage {
    if (requirements.isEmpty) return isCompleted ? 1.0 : 0.0;
    
    final completedRequirements = requirements.where((req) {
      return progress[req] == true;
    }).length;
    
    return completedRequirements / requirements.length;
  }

  String get timeRemaining {
    if (isExpired) return 'Expired';
    
    final now = DateTime.now();
    final remaining = expiresAt.difference(now);
    
    if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m left';
    } else {
      return '${remaining.inMinutes}m left';
    }
  }

  DailyChallenge copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    ChallengeType? type,
    ChallengeDifficulty? difficulty,
    int? xpReward,
    int? happinessReward,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isCompleted,
    List<String>? requirements,
    Map<String, dynamic>? progress,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      happinessReward: happinessReward ?? this.happinessReward,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isCompleted: isCompleted ?? this.isCompleted,
      requirements: requirements ?? this.requirements,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'emoji': emoji,
      'type': type.name,
      'difficulty': difficulty.name,
      'xpReward': xpReward,
      'happinessReward': happinessReward,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'requirements': requirements,
      'progress': progress,
    };
  }

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    try {
      return DailyChallenge(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        emoji: json['emoji']?.toString() ?? '🎯',
        type: ChallengeType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => ChallengeType.care,
        ),
        difficulty: ChallengeDifficulty.values.firstWhere(
          (d) => d.name == json['difficulty'],
          orElse: () => ChallengeDifficulty.easy,
        ),
        xpReward: (json['xpReward'] as num?)?.toInt() ?? baseXpReward,
        happinessReward: (json['happinessReward'] as num?)?.toInt() ?? baseHappinessReward,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (json['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
        ),
        expiresAt: DateTime.fromMillisecondsSinceEpoch(
          (json['expiresAt'] as num?)?.toInt() ?? 
          DateTime.now().add(challengeDuration).millisecondsSinceEpoch,
        ),
        isCompleted: json['isCompleted'] as bool? ?? false,
        requirements: (json['requirements'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ?? [],
        progress: (json['progress'] as Map<String, dynamic>?) ?? {},
      );
    } catch (e) {
      // Return a default challenge if parsing fails
      return DailyChallenge.getDefaultChallenge();
    }
  }

  factory DailyChallenge.getDefaultChallenge() {
    final now = DateTime.now();
    return DailyChallenge(
      id: 'default',
      title: 'Show Some Love',
      description: 'Feed and pet your companion',
      emoji: '💕',
      type: ChallengeType.care,
      difficulty: ChallengeDifficulty.easy,
      xpReward: baseXpReward,
      happinessReward: baseHappinessReward,
      createdAt: now,
      expiresAt: now.add(challengeDuration),
      requirements: ['feed', 'pet'],
      progress: {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyChallenge && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DailyChallenge(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}

// Predefined challenge templates for generation
class ChallengeTemplates {
  static const List<Map<String, dynamic>> careTemplates = [
    {
      'title': 'Perfect Care Day',
      'description': 'Feed, clean, and play with your pet',
      'emoji': '✨',
      'difficulty': 'medium',
      'requirements': ['feed', 'clean', 'play'],
      'xpMultiplier': 1.5,
    },
    {
      'title': 'Health Guardian',
      'description': 'Keep your pet\'s health above 80%',
      'emoji': '🏥',
      'difficulty': 'easy',
      'requirements': ['maintain_health_80'],
      'xpMultiplier': 1.0,
    },
    {
      'title': 'Energy Master',
      'description': 'Help your pet sleep when energy is low',
      'emoji': '😴',
      'difficulty': 'easy',
      'requirements': ['sleep_when_tired'],
      'xpMultiplier': 1.0,
    },
  ];

  static const List<Map<String, dynamic>> bondingTemplates = [
    {
      'title': 'Love Exchange',
      'description': 'Send 3 loving messages to your partner',
      'emoji': '💌',
      'difficulty': 'easy',
      'requirements': ['send_messages_3'],
      'xpMultiplier': 1.2,
    },
    {
      'title': 'Memory Masters',
      'description': 'Complete the memory game together',
      'emoji': '🧠',
      'difficulty': 'medium',
      'requirements': ['complete_memory_game'],
      'xpMultiplier': 2.0,
    },
    {
      'title': 'Caring Duo',
      'description': 'Both partners interact with pet 5 times',
      'emoji': '👫',
      'difficulty': 'hard',
      'requirements': ['both_interact_5'],
      'xpMultiplier': 2.5,
    },
  ];

  static const List<Map<String, dynamic>> memoryTemplates = [
    {
      'title': 'Quick Thinker',
      'description': 'Complete memory game in under 2 minutes',
      'emoji': '⚡',
      'difficulty': 'hard',
      'requirements': ['memory_game_speed'],
      'xpMultiplier': 3.0,
    },
    {
      'title': 'Perfect Match',
      'description': 'Complete memory game without mistakes',
      'emoji': '🎯',
      'difficulty': 'hard',
      'requirements': ['memory_game_perfect'],
      'xpMultiplier': 3.0,
    },
  ];

  static const List<Map<String, dynamic>> achievementTemplates = [
    {
      'title': 'Achievement Hunter',
      'description': 'Unlock a new achievement today',
      'emoji': '🏆',
      'difficulty': 'medium',
      'requirements': ['unlock_achievement'],
      'xpMultiplier': 2.0,
    },
    {
      'title': 'Milestone Seeker',
      'description': 'Reach 50 total interactions',
      'emoji': '🎖️',
      'difficulty': 'hard',
      'requirements': ['reach_50_interactions'],
      'xpMultiplier': 2.5,
    },
  ];

  static List<Map<String, dynamic>> getAllTemplates() {
    return [
      ...careTemplates,
      ...bondingTemplates,
      ...memoryTemplates,
      ...achievementTemplates,
    ];
  }

  static List<Map<String, dynamic>> getTemplatesByType(ChallengeType type) {
    switch (type) {
      case ChallengeType.care:
        return careTemplates;
      case ChallengeType.bonding:
        return bondingTemplates;
      case ChallengeType.memory:
        return memoryTemplates;
      case ChallengeType.achievement:
        return achievementTemplates;
    }
  }
} 