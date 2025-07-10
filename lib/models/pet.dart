class Pet {
  String name;
  int health;
  int hunger;
  int happiness;
  int energy;
  int age;
  PetStage stage;
  DateTime birthTime;
  DateTime lastUpdate;
  DateTime lastFeed;
  DateTime lastPlay;
  DateTime lastClean;
  DateTime lastSleep;
  bool isDead;
  bool isSleeping;
  
  // Personality traits
  int playful;
  int smart;
  int affection;
  
  // Game stats
  int gamesPlayed;
  int gamesWon;
  int totalInteractions;
  
  // Messages
  List<PetMessage> messages;
  int unreadMessages;

  Pet({
    this.name = "Your Pet",
    this.health = 100,
    this.hunger = 0,
    this.happiness = 100,
    this.energy = 100,
    this.age = 0,
    this.stage = PetStage.egg,
    DateTime? birthTime,
    DateTime? lastUpdate,
    DateTime? lastFeed,
    DateTime? lastPlay,
    DateTime? lastClean,
    DateTime? lastSleep,
    this.isDead = false,
    this.isSleeping = false,
    this.playful = 50,
    this.smart = 50,
    this.affection = 50,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalInteractions = 0,
    List<PetMessage>? messages,
    this.unreadMessages = 0,
  })  : birthTime = birthTime ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now(),
        lastFeed = lastFeed ?? DateTime.fromMillisecondsSinceEpoch(0),
        lastPlay = lastPlay ?? DateTime.fromMillisecondsSinceEpoch(0),
        lastClean = lastClean ?? DateTime.fromMillisecondsSinceEpoch(0),
        lastSleep = lastSleep ?? DateTime.fromMillisecondsSinceEpoch(0),
        messages = messages ?? [];

  PetMood get mood {
    if (isDead) return PetMood.dead;
    if (isSleeping) return PetMood.sleeping;
    if (health < 30) return PetMood.sick;
    if (happiness < 30 || hunger > 70) return PetMood.sad;
    if (happiness > 70 && hunger < 30) return PetMood.happy;
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
        return ["😊", "😄", "🥰", "😃"][DateTime.now().millisecond % 4];
      case PetMood.neutral:
        return ["😐", "🙂", "😌"][DateTime.now().millisecond % 3];
      case PetMood.sad:
        return ["😢", "😞", "😔"][DateTime.now().millisecond % 3];
      case PetMood.sick:
        return ["🤒", "😷", "🤢"][DateTime.now().millisecond % 3];
      case PetMood.dead:
        return ["💀", "👻"][DateTime.now().millisecond % 2];
      case PetMood.sleeping:
        return ["😴", "💤"][DateTime.now().millisecond % 2];
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

  Map<String, dynamic> toJson() {
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
      'version': '2.0',
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'] ?? "Your Pet",
      health: json['health'] ?? 100,
      hunger: json['hunger'] ?? 0,
      happiness: json['happiness'] ?? 100,
      energy: json['energy'] ?? 100,
      age: json['age'] ?? 0,
      stage: PetStage.values[json['stage'] ?? 0],
      birthTime: DateTime.fromMillisecondsSinceEpoch(json['birthTime'] ?? DateTime.now().millisecondsSinceEpoch),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(json['lastUpdate'] ?? DateTime.now().millisecondsSinceEpoch),
      lastFeed: DateTime.fromMillisecondsSinceEpoch(json['lastFeed'] ?? 0),
      lastPlay: DateTime.fromMillisecondsSinceEpoch(json['lastPlay'] ?? 0),
      lastClean: DateTime.fromMillisecondsSinceEpoch(json['lastClean'] ?? 0),
      lastSleep: DateTime.fromMillisecondsSinceEpoch(json['lastSleep'] ?? 0),
      isDead: json['isDead'] ?? false,
      isSleeping: json['isSleeping'] ?? false,
      playful: json['playful'] ?? 50,
      smart: json['smart'] ?? 50,
      affection: json['affection'] ?? 50,
      gamesPlayed: json['gamesPlayed'] ?? 0,
      gamesWon: json['gamesWon'] ?? 0,
      totalInteractions: json['totalInteractions'] ?? 0,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((m) => PetMessage.fromJson(m))
          .toList() ?? [],
      unreadMessages: json['unreadMessages'] ?? 0,
    );
  }
}

enum PetStage { egg, baby, child, adult }

enum PetMood { happy, neutral, sad, sick, dead, sleeping }

class PetMessage {
  final String text;
  final DateTime timestamp;
  final String sender;

  PetMessage({
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
      text: json['text'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      sender: json['sender'],
    );
  }
} 