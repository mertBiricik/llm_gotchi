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
  Pet _pet = Pet.create();
  List<Achievement> _achievements = [];
  MemoryGame _memoryGame = MemoryGame();
  Timer? _updateTimer;
  final SoundService _soundService = SoundService();

  // Business logic constants
  static const Duration updateInterval = Duration(minutes: 1);
  static const Duration actionCooldown = Duration(minutes: 10);
  static const Duration sleepDuration = Duration(hours: 8);
  static const double statsDecayRate = 5.0; // per hour
  static const double happinessDecayRate = 3.0; // per hour
  static const double energyDecayRate = 2.0; // per hour
  static const double healthDecayRate = 2.0; // per hour
  static const int feedHungerReduction = 30;
  static const int feedHealthIncrease = 10;
  static const int feedHappinessIncrease = 5;
  static const int playHappinessIncrease = 25;
  static const int playEnergyDecrease = 10;
  static const int playfulIncrease = 5;
  static const int affectionIncrease = 3;
  static const int cleanHealthIncrease = 15;
  static const int cleanHappinessIncrease = 10;
  static const int sleepEnergyIncrease = 50;
  static const int gameSmartIncrease = 10;
  static const int gameHappinessIncrease = 15;
  static const int messageAffectionIncrease = 2;

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
    _updateTimer?.cancel(); // Ensure no duplicate timers
    _updateTimer = Timer.periodic(updateInterval, (timer) {
      try {
        _updateStats();
        _updateAge();
        _checkAchievements();
        notifyListeners();
      } catch (e) {
        debugPrint('Error in update timer: $e');
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _soundService.dispose();
    super.dispose();
  }

  Future<void> _loadPet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petData = prefs.getString(_storageKey);
      final achievementData = prefs.getString(_achievementsKey);

      if (petData != null && petData.isNotEmpty) {
        final Map<String, dynamic> json = jsonDecode(petData);
        _pet = Pet.fromJson(json);
        _updateAge();
        _updateStats();
      }

      if (achievementData != null && achievementData.isNotEmpty) {
        final List<dynamic> achievementList = jsonDecode(achievementData);
        _loadAchievements(achievementList);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading pet: $e');
      // Reset to default pet if loading fails
      _pet = Pet.create();
      _achievements = Achievement.getDefaultAchievements();
      notifyListeners();
    }
  }

  void _loadAchievements(List<dynamic> savedAchievements) {
    try {
      final List<Achievement> updatedAchievements = [];
      
      for (var defaultAchievement in _achievements) {
        // Find saved state for this achievement
        final savedData = savedAchievements
            .cast<Map<String, dynamic>>()
            .where((saved) => saved['id'] == defaultAchievement.id)
            .firstOrNull;
        
        if (savedData != null) {
          final loadedAchievement = Achievement.fromJsonWithDefaults(savedData);
          updatedAchievements.add(loadedAchievement ?? defaultAchievement);
        } else {
          updatedAchievements.add(defaultAchievement);
        }
      }
      
      _achievements = updatedAchievements;
    } catch (e) {
      debugPrint('Error loading achievements: $e');
    }
  }

  Future<void> _savePet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(_pet.toJson()));
      
      final achievementData = _achievements.map((a) => a.toJson()).toList();
      await prefs.setString(_achievementsKey, jsonEncode(achievementData));
    } catch (e) {
      debugPrint('Error saving pet: $e');
    }
  }

  void _updateAge() {
    final now = DateTime.now();
    final timeDiff = now.difference(_pet.birthTime);
    final newAge = timeDiff.inDays;

    if (newAge != _pet.age) {
      // Update stage based on age
      PetStage newStage = _pet.stage;
      if (newAge >= 7) {
        newStage = PetStage.adult;
      } else if (newAge >= 3) {
        newStage = PetStage.child;
      } else if (newAge >= 1) {
        newStage = PetStage.baby;
      }

      _pet = _pet.copyWith(age: newAge, stage: newStage);
    }
  }

  void _updateStats() {
    final now = DateTime.now();
    final timeDiff = now.difference(_pet.lastUpdate);
    final hoursPassed = timeDiff.inMinutes / 60.0;

    if (hoursPassed > 0.1 && !_pet.isDead) {
      // Calculate stat changes
      final hungerIncrease = (hoursPassed * statsDecayRate).round();
      final happinessDecrease = (hoursPassed * happinessDecayRate).round();
      final energyDecrease = (hoursPassed * energyDecayRate).round();

      final newHunger = min(Pet.maxStat, _pet.hunger + hungerIncrease);
      final newHappiness = max(Pet.minStat, _pet.happiness - happinessDecrease);
      final newEnergy = max(Pet.minStat, _pet.energy - energyDecrease);

      // Health decreases if other stats are poor
      int healthDecrease = 0;
      if (newHunger > 80 || newHappiness < 20 || newEnergy < 20) {
        healthDecrease = (hoursPassed * healthDecayRate).round();
      }
      final newHealth = max(Pet.minStat, _pet.health - healthDecrease);

      // End sleep after sleep duration
      bool newIsSleeping = _pet.isSleeping;
      int adjustedEnergy = newEnergy;
      if (_pet.isSleeping && now.difference(_pet.lastSleep) >= sleepDuration) {
        newIsSleeping = false;
        adjustedEnergy = Pet.maxStat;
      }

      // Check if pet dies
      final newIsDead = newHealth <= 0;

      _pet = _pet.copyWith(
        hunger: newHunger,
        happiness: newHappiness,
        energy: adjustedEnergy,
        health: newHealth,
        isSleeping: newIsSleeping,
        isDead: newIsDead,
        lastUpdate: now,
      );

      _savePet();
    }
  }

  bool canPerformAction(String action) {
    if (_pet.isDead) return false;
    if (_pet.isSleeping && action != 'wake') return false;
    
    final now = DateTime.now();
    
    switch (action) {
      case 'feed':
        return now.difference(_pet.lastFeed) >= actionCooldown;
      case 'play':
        return now.difference(_pet.lastPlay) >= actionCooldown;
      case 'clean':
        return now.difference(_pet.lastClean) >= actionCooldown;
      case 'sleep':
        return now.difference(_pet.lastSleep) >= actionCooldown && !_pet.isSleeping;
      default:
        return true;
    }
  }

  String getActionCooldown(String action) {
    if (_pet.isDead || canPerformAction(action)) return '';
    
    final now = DateTime.now();
    int remainingMinutes = 0;
    
    switch (action) {
      case 'feed':
        remainingMinutes = actionCooldown.inMinutes - now.difference(_pet.lastFeed).inMinutes;
        break;
      case 'play':
        remainingMinutes = actionCooldown.inMinutes - now.difference(_pet.lastPlay).inMinutes;
        break;
      case 'clean':
        remainingMinutes = actionCooldown.inMinutes - now.difference(_pet.lastClean).inMinutes;
        break;
      case 'sleep':
        remainingMinutes = actionCooldown.inMinutes - now.difference(_pet.lastSleep).inMinutes;
        break;
    }
    
    return '${remainingMinutes}m';
  }

  void feedPet() {
    if (!canPerformAction('feed')) return;

    final now = DateTime.now();
    _pet = _pet.copyWith(
      hunger: max(Pet.minStat, _pet.hunger - feedHungerReduction),
      health: min(Pet.maxStat, _pet.health + feedHealthIncrease),
      happiness: min(Pet.maxStat, _pet.happiness + feedHappinessIncrease),
      lastFeed: now,
      totalInteractions: _pet.totalInteractions + 1,
    );

    _soundService.playFeedSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void playWithPet() {
    if (!canPerformAction('play')) return;

    final now = DateTime.now();
    _pet = _pet.copyWith(
      happiness: min(Pet.maxStat, _pet.happiness + playHappinessIncrease),
      energy: max(Pet.minStat, _pet.energy - playEnergyDecrease),
      playful: min(Pet.maxStat, _pet.playful + playfulIncrease),
      affection: min(Pet.maxStat, _pet.affection + affectionIncrease),
      lastPlay: now,
      totalInteractions: _pet.totalInteractions + 1,
    );

    _soundService.playPlaySound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void cleanPet() {
    if (!canPerformAction('clean')) return;

    final now = DateTime.now();
    _pet = _pet.copyWith(
      health: min(Pet.maxStat, _pet.health + cleanHealthIncrease),
      happiness: min(Pet.maxStat, _pet.happiness + cleanHappinessIncrease),
      lastClean: now,
      totalInteractions: _pet.totalInteractions + 1,
    );

    _soundService.playCleanSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void putPetToSleep() {
    if (!canPerformAction('sleep')) return;

    final now = DateTime.now();
    _pet = _pet.copyWith(
      isSleeping: true,
      lastSleep: now,
      totalInteractions: _pet.totalInteractions + 1,
    );

    _soundService.playSleepSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void wakePet() {
    if (!_pet.isSleeping) return;

    _pet = _pet.copyWith(
      isSleeping: false,
      energy: min(Pet.maxStat, _pet.energy + sleepEnergyIncrease),
    );
    
    _savePet();
    notifyListeners();
  }

  void startMemoryGame() {
    _memoryGame = _memoryGame.initializeGame();
    _pet = _pet.copyWith(gamesPlayed: _pet.gamesPlayed + 1);
    notifyListeners();
  }

  void onMemoryCardTapped(int index) {
    _memoryGame = _memoryGame.flipCard(index);
    
    if (_memoryGame.flippedCardIndices.length == 2) {
      // Delay to show cards before hiding non-matches
      Timer(const Duration(milliseconds: 1000), () {
        if (_memoryGame.flippedCardIndices.length == 2) {
          final card1 = _memoryGame.cards[_memoryGame.flippedCardIndices[0]];
          final card2 = _memoryGame.cards[_memoryGame.flippedCardIndices[1]];
          
          if (card1.symbol != card2.symbol) {
            _memoryGame = _memoryGame.hideNonMatches();
            notifyListeners();
          }
        }
      });
    }

    if (_memoryGame.gameWon) {
      _pet = _pet.copyWith(
        gamesWon: _pet.gamesWon + 1,
        smart: min(Pet.maxStat, _pet.smart + gameSmartIncrease),
        happiness: min(Pet.maxStat, _pet.happiness + gameHappinessIncrease),
      );
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

    final updatedMessages = List<PetMessage>.from(_pet.messages)..add(message);
    _pet = _pet.copyWith(
      messages: updatedMessages,
      affection: min(Pet.maxStat, _pet.affection + messageAffectionIncrease),
    );

    _soundService.playMessageSound();
    _checkAchievements();
    _savePet();
    notifyListeners();
  }

  void _checkAchievements() {
    bool hasNewAchievement = false;
    for (int i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];
      if (!achievement.unlocked && achievement.condition(_pet)) {
        _achievements[i] = achievement.copyWith(unlocked: true);
        hasNewAchievement = true;
      }
    }
    
    if (hasNewAchievement) {
      _soundService.playAchievementSound();
    }
  }

  List<PetMessage> getRecentMessages() {
    const maxMessages = 10;
    return _pet.messages.length > maxMessages 
        ? _pet.messages.sublist(_pet.messages.length - maxMessages)
        : _pet.messages;
  }

  String exportPetData() {
    try {
      final exportData = _pet.toJson();
      exportData['exportTime'] = DateTime.now().millisecondsSinceEpoch;
      return base64Encode(utf8.encode(jsonEncode(exportData)));
    } catch (e) {
      debugPrint('Error exporting pet data: $e');
      return '';
    }
  }

  bool importPetData(String encodedData) {
    try {
      if (encodedData.trim().isEmpty) return false;
      
      final decodedData = utf8.decode(base64Decode(encodedData));
      final Map<String, dynamic> importData = jsonDecode(decodedData);
      
      // Merge imported data with current pet
      final importedPet = Pet.fromJson(importData);
      
      // Merge messages - avoid duplicates
      final currentMessages = List<PetMessage>.from(_pet.messages);
      for (var message in importedPet.messages) {
        if (!currentMessages.any((m) => 
            m.text == message.text && 
            m.timestamp == message.timestamp && 
            m.sender == message.sender)) {
          currentMessages.add(message);
        }
      }
      
      // Keep the better stats
      _pet = _pet.copyWith(
        name: importedPet.name,
        health: max(_pet.health, importedPet.health),
        happiness: max(_pet.happiness, importedPet.happiness),
        energy: max(_pet.energy, importedPet.energy),
        hunger: min(_pet.hunger, importedPet.hunger),
        messages: currentMessages,
        gamesPlayed: max(_pet.gamesPlayed, importedPet.gamesPlayed),
        gamesWon: max(_pet.gamesWon, importedPet.gamesWon),
        totalInteractions: max(_pet.totalInteractions, importedPet.totalInteractions),
      );
      
      _updateAge();
      _updateStats();
      _checkAchievements();
      _savePet();
      notifyListeners();
      
      return true;
    } catch (e) {
      debugPrint('Error importing pet data: $e');
      return false;
    }
  }

  void resetPet() {
    _pet = Pet.create();
    _achievements = Achievement.getDefaultAchievements();
    _savePet();
    notifyListeners();
  }
} 