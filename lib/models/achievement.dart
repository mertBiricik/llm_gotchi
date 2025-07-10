import 'pet.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  bool unlocked;
  final bool Function(Pet pet) condition;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.unlocked = false,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unlocked': unlocked,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    // Create achievement with default condition, will be updated in service
    final achievement = Achievement(
      id: json['id'],
      name: '',
      description: '',
      icon: '',
      unlocked: json['unlocked'] ?? false,
      condition: (pet) => false,
    );
    return achievement;
  }

  static List<Achievement> getDefaultAchievements() {
    return [
      Achievement(
        id: 'firstFeed',
        name: 'First Meal',
        description: 'Feed your pet for the first time',
        icon: '🍼',
        condition: (pet) => pet.totalInteractions >= 1,
      ),
      Achievement(
        id: 'happyPet',
        name: 'Happy Pet',
        description: 'Keep happiness above 80%',
        icon: '😊',
        condition: (pet) => pet.happiness >= 80,
      ),
      Achievement(
        id: 'weekOld',
        name: 'One Week Old',
        description: 'Your pet survived a week',
        icon: '📅',
        condition: (pet) => pet.age >= 7,
      ),
      Achievement(
        id: 'gameWinner',
        name: 'Brain Games',
        description: 'Win 3 memory games',
        icon: '🧠',
        condition: (pet) => pet.gamesWon >= 3,
      ),
      Achievement(
        id: 'socialButterfly',
        name: 'Social Butterfly',
        description: 'Send 10 messages',
        icon: '💌',
        condition: (pet) => pet.messages.length >= 10,
      ),
      Achievement(
        id: 'adulthood',
        name: 'All Grown Up',
        description: 'Pet reaches adulthood',
        icon: '🎓',
        condition: (pet) => pet.stage == PetStage.adult,
      ),
    ];
  }
} 