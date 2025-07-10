import 'dart:math';

class Pet {
  final String name;
  final int health;
  final int hunger;
  final int happiness;
  final int energy;
  final int age;
  final PetStage stage;
  final DateTime birthTime;
  final DateTime lastUpdate;
  final DateTime lastFeed;
  final DateTime lastPlay;
  final DateTime lastClean;
  final DateTime lastSleep;
  final bool isDead;
  final bool isSleeping;
  
  // Personality traits
  final int playful;
  final int smart;
  final int affection;
  
  // Game stats
  final int gamesPlayed;
  final int gamesWon;
  final int totalInteractions;
  
  // Messages
  final List<PetMessage> messages;
  final int unreadMessages;

  // Constants for magic numbers
  static const int maxStat = 100;
  static const int minStat = 0;
  static const int sickThreshold = 30;
  static const int sadThreshold = 30;
  static const int happyThreshold = 70;
  static const int hungerThreshold = 70;

  // Cache for emoji randomization
  static final Random _random = Random();

  const Pet({
    this.name = "Your Pet",
    this.health = maxStat,
    this.hunger = minStat,
    this.happiness = maxStat,
    this.energy = maxStat,
    this.age = 0,
    this.stage = PetStage.egg,
    required this.birthTime,
    required this.lastUpdate,
    required this.lastFeed,
    required this.lastPlay,
    required this.lastClean,
    required this.lastSleep,
    this.isDead = false,
    this.isSleeping = false,
    this.playful = 50,
    this.smart = 50,
    this.affection = 50,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalInteractions = 0,
    this.messages = const [],
    this.unreadMessages = 0,
  });

  factory Pet.create({
    String? name,
    int? health,
    int? hunger,
    int? happiness,
    int? energy,
    int? age,
    PetStage? stage,
    DateTime? birthTime,
    DateTime? lastUpdate,
    DateTime? lastFeed,
    DateTime? lastPlay,
    DateTime? lastClean,
    DateTime? lastSleep,
    bool? isDead,
    bool? isSleeping,
    int? playful,
    int? smart,
    int? affection,
    int? gamesPlayed,
    int? gamesWon,
    int? totalInteractions,
    List<PetMessage>? messages,
    int? unreadMessages,
  }) {
    final now = DateTime.now();
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    
    return Pet(
      name: name ?? "Your Pet",
      health: health ?? maxStat,
      hunger: hunger ?? minStat,
      happiness: happiness ?? maxStat,
      energy: energy ?? maxStat,
      age: age ?? 0,
      stage: stage ?? PetStage.egg,
      birthTime: birthTime ?? now,
      lastUpdate: lastUpdate ?? now,
      lastFeed: lastFeed ?? epoch,
      lastPlay: lastPlay ?? epoch,
      lastClean: lastClean ?? epoch,
      lastSleep: lastSleep ?? epoch,
      isDead: isDead ?? false,
      isSleeping: isSleeping ?? false,
      playful: playful ?? 50,
      smart: smart ?? 50,
      affection: affection ?? 50,
      gamesPlayed: gamesPlayed ?? 0,
      gamesWon: gamesWon ?? 0,
      totalInteractions: totalInteractions ?? 0,
      messages: messages ?? [],
      unreadMessages: unreadMessages ?? 0,
    );
  }

  PetMood get mood {
    if (isDead) return PetMood.dead;
    if (isSleeping) return PetMood.sleeping;
    if (health < sickThreshold) return PetMood.sick;
    if (happiness < sadThreshold || hunger > hungerThreshold) return PetMood.sad;
    if (happiness > happyThreshold && hunger < sadThreshold) return PetMood.happy;
    return PetMood.neutral;
  }

  String get faceEmoji {
    switch (stage) {
      case PetStage.egg:
        return "🥚";
      case PetStage.baby:
        return mood == PetMood.happy ? "🐣" : _getMoodEmoji();
      case PetStage.child:
        return mood == PetMood.happy ? "🐥" : _getMoodEmoji();
      case PetStage.adult:
        return mood == PetMood.happy ? "🐤" : _getMoodEmoji();
    }
  }

  String _getMoodEmoji() {
    switch (mood) {
      case PetMood.happy:
        const emojis = ["😊", "😄", "🥰", "😃"];
        return emojis[_random.nextInt(emojis.length)];
      case PetMood.neutral:
        const emojis = ["😐", "🙂", "😌"];
        return emojis[_random.nextInt(emojis.length)];
      case PetMood.sad:
        const emojis = ["😢", "😞", "😔"];
        return emojis[_random.nextInt(emojis.length)];
      case PetMood.sick:
        const emojis = ["🤒", "😷", "🤢"];
        return emojis[_random.nextInt(emojis.length)];
      case PetMood.dead:
        const emojis = ["💀", "👻"];
        return emojis[_random.nextInt(emojis.length)];
      case PetMood.sleeping:
        const emojis = ["😴", "💤"];
        return emojis[_random.nextInt(emojis.length)];
    }
  }

  String get statusText {
    if (isDead) return "Your pet has passed away...";
    if (isSleeping) return "Zzz... sleeping peacefully";
    
    switch (mood) {
      case PetMood.happy:
        return "Feeling great!";
      case PetMood.neutral:
        return "Doing okay";
      case PetMood.sad:
        return "Feeling down...";
      case PetMood.sick:
        return "Not feeling well";
      case PetMood.dead:
        return "Has passed away...";
      case PetMood.sleeping:
        return "Sleeping soundly";
    }
  }

  Pet copyWith({
    String? name,
    int? health,
    int? hunger,
    int? happiness,
    int? energy,
    int? age,
    PetStage? stage,
    DateTime? birthTime,
    DateTime? lastUpdate,
    DateTime? lastFeed,
    DateTime? lastPlay,
    DateTime? lastClean,
    DateTime? lastSleep,
    bool? isDead,
    bool? isSleeping,
    int? playful,
    int? smart,
    int? affection,
    int? gamesPlayed,
    int? gamesWon,
    int? totalInteractions,
    List<PetMessage>? messages,
    int? unreadMessages,
  }) {
    return Pet(
      name: name ?? this.name,
      health: health ?? this.health,
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      age: age ?? this.age,
      stage: stage ?? this.stage,
      birthTime: birthTime ?? this.birthTime,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      lastFeed: lastFeed ?? this.lastFeed,
      lastPlay: lastPlay ?? this.lastPlay,
      lastClean: lastClean ?? this.lastClean,
      lastSleep: lastSleep ?? this.lastSleep,
      isDead: isDead ?? this.isDead,
      isSleeping: isSleeping ?? this.isSleeping,
      playful: playful ?? this.playful,
      smart: smart ?? this.smart,
      affection: affection ?? this.affection,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      messages: messages ?? this.messages,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'name': name,
        'health': health,
        'hunger': hunger,
        'happiness': happiness,
        'energy': energy,
        'age': age,
        'stage': stage.index,
        'birthTime': birthTime.millisecondsSinceEpoch,
        'lastUpdate': lastUpdate.millisecondsSinceEpoch,
        'lastFeed': lastFeed.millisecondsSinceEpoch,
        'lastPlay': lastPlay.millisecondsSinceEpoch,
        'lastClean': lastClean.millisecondsSinceEpoch,
        'lastSleep': lastSleep.millisecondsSinceEpoch,
        'isDead': isDead,
        'isSleeping': isSleeping,
        'playful': playful,
        'smart': smart,
        'affection': affection,
        'gamesPlayed': gamesPlayed,
        'gamesWon': gamesWon,
        'totalInteractions': totalInteractions,
        'messages': messages.map((m) => m.toJson()).toList(),
        'unreadMessages': unreadMessages,
        'version': '3.0',
      };
    } catch (e) {
      throw Exception('Failed to serialize pet data: $e');
    }
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    try {
      final now = DateTime.now();
      final epoch = DateTime.fromMillisecondsSinceEpoch(0);
      
      return Pet(
        name: json['name'] as String? ?? "Your Pet",
        health: (json['health'] as num?)?.clamp(minStat, maxStat).toInt() ?? maxStat,
        hunger: (json['hunger'] as num?)?.clamp(minStat, maxStat).toInt() ?? minStat,
        happiness: (json['happiness'] as num?)?.clamp(minStat, maxStat).toInt() ?? maxStat,
        energy: (json['energy'] as num?)?.clamp(minStat, maxStat).toInt() ?? maxStat,
        age: (json['age'] as num?)?.toInt() ?? 0,
        stage: PetStage.values.elementAtOrNull(json['stage'] as int? ?? 0) ?? PetStage.egg,
        birthTime: DateTime.fromMillisecondsSinceEpoch(
          json['birthTime'] as int? ?? now.millisecondsSinceEpoch,
        ),
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(
          json['lastUpdate'] as int? ?? now.millisecondsSinceEpoch,
        ),
        lastFeed: DateTime.fromMillisecondsSinceEpoch(json['lastFeed'] as int? ?? 0),
        lastPlay: DateTime.fromMillisecondsSinceEpoch(json['lastPlay'] as int? ?? 0),
        lastClean: DateTime.fromMillisecondsSinceEpoch(json['lastClean'] as int? ?? 0),
        lastSleep: DateTime.fromMillisecondsSinceEpoch(json['lastSleep'] as int? ?? 0),
        isDead: json['isDead'] as bool? ?? false,
        isSleeping: json['isSleeping'] as bool? ?? false,
        playful: (json['playful'] as num?)?.clamp(minStat, maxStat).toInt() ?? 50,
        smart: (json['smart'] as num?)?.clamp(minStat, maxStat).toInt() ?? 50,
        affection: (json['affection'] as num?)?.clamp(minStat, maxStat).toInt() ?? 50,
        gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
        gamesWon: (json['gamesWon'] as num?)?.toInt() ?? 0,
        totalInteractions: (json['totalInteractions'] as num?)?.toInt() ?? 0,
        messages: _parseMessages(json['messages']),
        unreadMessages: (json['unreadMessages'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      throw Exception('Failed to deserialize pet data: $e');
    }
  }

  static List<PetMessage> _parseMessages(dynamic messagesData) {
    try {
      if (messagesData is! List) return [];
      return messagesData
          .map((m) => PetMessage.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pet &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          health == other.health &&
          hunger == other.hunger &&
          happiness == other.happiness &&
          energy == other.energy &&
          age == other.age &&
          stage == other.stage &&
          birthTime == other.birthTime;

  @override
  int get hashCode => Object.hash(
        name,
        health,
        hunger,
        happiness,
        energy,
        age,
        stage,
        birthTime,
      );
}

enum PetStage { egg, baby, child, adult }

enum PetMood { happy, neutral, sad, sick, dead, sleeping }

class PetMessage {
  final String text;
  final DateTime timestamp;
  final String sender;

  const PetMessage({
    required this.text,
    required this.timestamp,
    required this.sender,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'sender': sender,
    };
  }

  factory PetMessage.fromJson(Map<String, dynamic> json) {
    return PetMessage(
      text: json['text'] as String? ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      sender: json['sender'] as String? ?? 'Unknown',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetMessage &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          timestamp == other.timestamp &&
          sender == other.sender;

  @override
  int get hashCode => Object.hash(text, timestamp, sender);
} 