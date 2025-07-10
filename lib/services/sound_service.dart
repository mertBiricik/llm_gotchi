import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundService {
  static const String _soundEnabledKey = 'soundEnabled';
  bool _soundEnabled = true;

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
      // Use system feedback for retro beep sound
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('System sound not available: $e');
    }
  }

  void playFeedSound() {
    _playSystemSound();
  }

  void playPlaySound() {
    _playSystemSound();
  }

  void playCleanSound() {
    _playSystemSound();
  }

  void playSleepSound() {
    _playSystemSound();
  }

  void playAchievementSound() {
    _playSystemSound();
  }

  void playMessageSound() {
    _playSystemSound();
  }

  void dispose() {
    // No cleanup needed for system sounds
  }
} 