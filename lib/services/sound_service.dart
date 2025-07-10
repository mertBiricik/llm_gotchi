import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundService {
  static const String _soundEnabledKey = 'soundEnabled';
  bool _soundEnabled = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Sound frequencies for synthetic sounds
  static const Map<String, double> _soundFrequencies = {
    'feed': 440.0,    // A4 note
    'play': 660.0,    // E5 note

    'clean': 880.0,   // A5 note
    'sleep': 220.0,   // A3 note
    'achievement': 1000.0, // Higher celebratory tone
    'message': 800.0, // Message notification tone
  };

  bool get soundEnabled => _soundEnabled;

  SoundService() {
    _loadSoundSettings();
  }

  Future<void> _loadSoundSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _soundEnabled = prefs.getBool(_soundEnabledKey) ?? true;
    } catch (e) {
      debugPrint('Error loading sound settings: $e');
      _soundEnabled = true;
    }
  }

  Future<void> toggleSound() async {
    try {
      _soundEnabled = !_soundEnabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundEnabledKey, _soundEnabled);
    } catch (e) {
      debugPrint('Error toggling sound: $e');
    }
  }

  Future<void> _playSystemSound() async {
    if (!_soundEnabled) return;

    try {
      // Use system feedback for a simple beep sound
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('System sound not available: $e');
    }
  }

  Future<void> _playAssetSound(String soundPath) async {
    if (!_soundEnabled) return;

    try {
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint('Asset sound not available ($soundPath): $e');
      // Fallback to system sound
      await _playSystemSound();
    }
  }

  void playFeedSound() {
    _playSound('feed');
  }

  void playPlaySound() {
    _playSound('play');
  }

  void playCleanSound() {
    _playSound('clean');
  }

  void playSleepSound() {
    _playSound('sleep');
  }

  void playAchievementSound() {
    _playSound('achievement');
  }

  void playMessageSound() {
    _playSound('message');
  }

  void _playSound(String soundType) {
    if (!_soundEnabled) return;

    // Try to play asset sound first, fallback to system sound
    final soundPath = 'sounds/$soundType.mp3';
    _playAssetSound(soundPath);
  }

  void dispose() {
    try {
      _audioPlayer.dispose();
    } catch (e) {
      debugPrint('Error disposing audio player: $e');
    }
  }
} 