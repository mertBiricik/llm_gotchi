import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../models/achievement.dart';
import '../models/memory_game.dart';
import 'sound_service.dart';

class PetService extends ChangeNotifier {
  Pet _pet = Pet();
  List<Achievement> _achievements = [];
  MemoryGame _memoryGame = MemoryGame();
  Timer? _updateTimer;
  final SoundService _soundService = SoundService();

  Pet get pet => _pet;
  List<Achievement> get achievements => _achievements;
  MemoryGame get memoryGame => _memoryGame;
  SoundService get soundService => _soundService;

  static const String _storageKey = 'ldrGotchi';
  static const String _achievementsKey = 'ldrGotchiAchievements';

  PetService() {
    _initializeAchievements();
    _loadPet();
    _startUpdateTimer();
  }

  void _initializeAchievements() {
    _achievements = Achievement.getDefaultAchievements();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateStats();
      _updateAge();
      _checkAchievements();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petData = prefs.getString(_storageKey);
      final achievementData = prefs.getString(_achievementsKey);

      if (petData != null) {
        final Map<String, dynamic> json = jsonDecode(petData);
        _pet = Pet.fromJson(json);
        _updateAge();
        _updateStats();
      }

      if (achievementData != null) {
        final List<dynamic> achievementList = jsonDecode(achievementData);
        _loadAchievements(achievementList);
      }

      notifyListeners();
    } catch (e) {
      print('Error loading pet: $e');
    }
  }

  void _loadAchievements(List<dynamic> savedAchievements) {
    for (var savedAchievement in savedAchievements) {
      final id = savedAchievement['id'];
      final unlocked = savedAchievement['unlocked'] ?? false;
      
      final achievementIndex = _achievements.indexWhere((a) => a.id == id);
      if (achievementIndex != -1) {
        _achievements[achievementIndex].unlocked = unlocked;
      }
    }
  }

  Future<void> _savePet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(_pet.toJson()));
      
      final achievementData = _achievements.map((a) => a.toJson()).toList();
      await prefs.setString(_achievementsKey, jsonEncode(achievementData));
    } catch (e) {
      print('Error saving pet: $e');
    }
  }

  void _updateAge() {
    final now = DateTime.now();
    final timeDiff = now.difference(_pet.birthTime);
    _pet.age = timeDiff.inDays;

    // Update stage based on age
    if (_pet.age >= 7) {
      _pet.stage = PetStage.adult;
    } else if (_pet.age >= 3) {
      _pet.stage = PetStage.child;
    } else if (_pet.age >= 1) {
      _pet.stage = PetStage.baby;
    }
  }

  void _updateStats() {
    final now = DateTime.now();
    final timeDiff = now.difference(_pet.lastUpdate);
    final hoursPassed = timeDiff.inMinutes / 60.0;

    if (hoursPassed > 0.1) {
      // Decrease stats over time
      _pet.hunger = min(100, _pet.hunger + (hoursPassed * 5).round());
      _pet.happiness = max(0, _pet.happiness - (hoursPassed * 3).round());
      _pet.energy = max(0, _pet.energy - (hoursPassed * 2).round());

      // Health decreases if other stats are poor
      if (_pet.hunger > 80 || _pet.happiness < 20 || _pet.energy < 20) {
        _pet.health = max(0, _pet.health - (hoursPassed * 2).round());
      }

      // End sleep after 8 hours
      if (_pet.isSleeping && now.difference(_pet.lastSleep).inHours >= 8) {
        _pet.isSleeping = false;
        _pet.energy = 100;
      }

      // Check if pet dies
      if (_pet.health <= 0) {
        _pet.isDead = true;
      }

      _pet.lastUpdate = now;
      _savePet();
    }
  }

  bool canPerformAction(String action) {
    if (_pet.isDead) return false;
    if (_pet.isSleeping && action != 'wake') return false;
    
    final now = DateTime.now();
    const cooldownMinutes = 10;
    
    switch (action) {
      case 'feed':
        return now.difference(_pet.lastFeed).inMinutes >= cooldownMinutes;
      case 'play':
        return now.difference(_pet.lastPlay).inMinutes >= cooldownMinutes;
      case 'clean':
        return now.difference(_pet.lastClean).inMinutes >= cooldownMinutes;
      case 'sleep':
        return now.difference(_pet.lastSleep).inMinutes >= cooldownMinutes && !_pet.isSleeping;
      default:
        return true;
    }
  }

  String getActionCooldown(String action) {
    if (_pet.isDead || canPerformAction(action)) return '';
    
    final now = DateTime.now();
    const cooldownMinutes = 10;
    int remainingMinutes = 0;
    
    switch (action) {
      case 'feed':
        remainingMinutes = cooldownMinutes - now.difference(_pet.lastFeed).inMinutes;
        break;
      case 'play':
        remainingMinutes = cooldownMinutes - now.difference(_pet.lastPlay).inMinutes;
        break;
      case 'clean':
        remainingMinutes = cooldownMinutes - now.difference(_pet.lastClean).inMinutes;
        break;
      case 'sleep':
        remainingMinutes = cooldownMinutes - now.difference(_pet.lastSleep).inMinutes;
        break;
    }
    
    return '${remainingMinutes}m';
  }

  void feedPet() {
    if (!canPerformAction('feed')) return;

    _pet.hunger = max(0, _pet.hunger - 30);
    _pet.health = min(100, _pet.health + 10);
    _pet.happiness = min(100, _pet.happiness + 5);
    _pet.lastFeed = DateTime.now();
    _pet.totalInteractions++;

    _soundService.playFeedSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void playWithPet() {
    if (!canPerformAction('play')) return;

    _pet.happiness = min(100, _pet.happiness + 25);
    _pet.energy = max(0, _pet.energy - 10);
    _pet.playful = min(100, _pet.playful + 5);
    _pet.affection = min(100, _pet.affection + 3);
    _pet.lastPlay = DateTime.now();
    _pet.totalInteractions++;

    _soundService.playPlaySound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void cleanPet() {
    if (!canPerformAction('clean')) return;

    _pet.health = min(100, _pet.health + 15);
    _pet.happiness = min(100, _pet.happiness + 10);
    _pet.lastClean = DateTime.now();
    _pet.totalInteractions++;

    _soundService.playCleanSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void putPetToSleep() {
    if (!canPerformAction('sleep')) return;

    _pet.isSleeping = true;
    _pet.lastSleep = DateTime.now();
    _pet.totalInteractions++;

    _soundService.playSleepSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void wakePet() {
    if (!_pet.isSleeping) return;

    _pet.isSleeping = false;
    _pet.energy = min(100, _pet.energy + 50);
    
    _savePet();
    notifyListeners();
  }

  void startMemoryGame() {
    _memoryGame.initializeGame();
    _pet.gamesPlayed++;
    notifyListeners();
  }

  void onMemoryCardTapped(int index) {
    _memoryGame.flipCard(index);
    
    if (_memoryGame.flippedCardIndices.length == 2) {
      // Delay to show cards before hiding non-matches
      Timer(const Duration(milliseconds: 1000), () {
        if (_memoryGame.flippedCardIndices.length == 2) {
          final card1 = _memoryGame.cards[_memoryGame.flippedCardIndices[0]];
          final card2 = _memoryGame.cards[_memoryGame.flippedCardIndices[1]];
          
          if (card1.symbol != card2.symbol) {
            _memoryGame.hideNonMatches();
            notifyListeners();
          }
        }
      });
    }

    if (_memoryGame.gameWon) {
      _pet.gamesWon++;
      _pet.smart = min(100, _pet.smart + 10);
      _pet.happiness = min(100, _pet.happiness + 15);
      _soundService.playAchievementSound();
      _checkAchievements();
      _savePet();
    }

    notifyListeners();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = PetMessage(
      text: text.trim(),
      timestamp: DateTime.now(),
      sender: 'You',
    );

    _pet.messages.add(message);
    _pet.affection = min(100, _pet.affection + 2);

    _soundService.playMessageSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void _checkAchievements() {
    for (var achievement in _achievements) {
      if (!achievement.unlocked && achievement.condition(_pet)) {
        achievement.unlocked = true;
        _soundService.playAchievementSound();
        // Achievement unlocked notification can be handled in UI
      }
    }
  }

  List<PetMessage> getRecentMessages() {
    return _pet.messages.length > 10 
        ? _pet.messages.sublist(_pet.messages.length - 10)
        : _pet.messages;
  }

  String exportPetData() {
    final exportData = _pet.toJson();
    exportData['exportTime'] = DateTime.now().millisecondsSinceEpoch;
    return base64Encode(utf8.encode(jsonEncode(exportData)));
  }

  bool importPetData(String encodedData) {
    try {
      final decodedData = utf8.decode(base64Decode(encodedData));
      final Map<String, dynamic> importData = jsonDecode(decodedData);
      
      // Merge imported data with current pet
      final importedPet = Pet.fromJson(importData);
      
      // Keep the more recent data for certain fields
      _pet.name = importedPet.name;
      _pet.health = max(_pet.health, importedPet.health);
      _pet.happiness = max(_pet.happiness, importedPet.happiness);
      _pet.energy = max(_pet.energy, importedPet.energy);
      _pet.hunger = min(_pet.hunger, importedPet.hunger);
      
      // Merge messages
      for (var message in importedPet.messages) {
        if (!_pet.messages.any((m) => 
            m.text == message.text && 
            m.timestamp == message.timestamp && 
            m.sender == message.sender)) {
          _pet.messages.add(message);
        }
      }
      
      // Update stats
      _pet.gamesPlayed = max(_pet.gamesPlayed, importedPet.gamesPlayed);
      _pet.gamesWon = max(_pet.gamesWon, importedPet.gamesWon);
      _pet.totalInteractions = max(_pet.totalInteractions, importedPet.totalInteractions);
      
      _updateAge();
      _updateStats();
      _checkAchievements();
      _savePet();
      notifyListeners();
      
      return true;
    } catch (e) {
      print('Error importing pet data: $e');
      return false;
    }
  }

  void resetPet() {
    _pet = Pet();
    _achievements = Achievement.getDefaultAchievements();
    _savePet();
    notifyListeners();
  }
} 