import 'pet.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool unlocked;
  final bool Function(Pet pet) condition;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.unlocked = false,
    required this.condition,
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? unlocked,
    bool Function(Pet pet)? condition,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlocked: unlocked ?? this.unlocked,
      condition: condition ?? this.condition,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unlocked': unlocked,
    };
  }

  static Achievement? fromJsonWithDefaults(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String?;
      final unlocked = json['unlocked'] as bool? ?? false;
      
      if (id == null) return null;
      
      // Find the default achievement with this ID
      final defaultAchievements = getDefaultAchievements();
      final defaultAchievement = defaultAchievements
          .where((a) => a.id == id)
          .firstOrNull;
      
      if (defaultAchievement == null) return null;
      
      return defaultAchievement.copyWith(unlocked: unlocked);
    } catch (e) {
      return null;
    }
  }

  static List<Achievement> getDefaultAchievements() {
    return [
      const Achievement(
        id: 'firstFeed',
        name: 'First Meal',
        description: 'Feed your pet for the first time',
        icon: '🍼',
        condition: _firstFeedCondition,
      ),
      const Achievement(
        id: 'happyPet',
        name: 'Happy Pet',
        description: 'Keep happiness above 80%',
        icon: '😊',
        condition: _happyPetCondition,
      ),
      const Achievement(
        id: 'weekOld',
        name: 'One Week Old',
        description: 'Your pet survived a week',
        icon: '📅',
        condition: _weekOldCondition,
      ),
      const Achievement(
        id: 'gameWinner',
        name: 'Brain Games',
        description: 'Win 3 memory games',
        icon: '🧠',
        condition: _gameWinnerCondition,
      ),
      const Achievement(
        id: 'socialButterfly',
        name: 'Social Butterfly',
        description: 'Send 10 messages',
        icon: '💌',
        condition: _socialButterflyCondition,
      ),
      const Achievement(
        id: 'adulthood',
        name: 'All Grown Up',
        description: 'Pet reaches adulthood',
        icon: '🎓',
        condition: _adulthoodCondition,
      ),
    ];
  }

  // Static condition functions
  static bool _firstFeedCondition(Pet pet) => pet.totalInteractions >= 1;
  static bool _happyPetCondition(Pet pet) => pet.happiness >= 80;
  static bool _weekOldCondition(Pet pet) => pet.age >= 7;
  static bool _gameWinnerCondition(Pet pet) => pet.gamesWon >= 3;
  static bool _socialButterflyCondition(Pet pet) => pet.messages.length >= 10;
  static bool _adulthoodCondition(Pet pet) => pet.stage == PetStage.adult;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          icon == other.icon &&
          unlocked == other.unlocked;

  @override
  int get hashCode => Object.hash(id, name, description, icon, unlocked);
} 