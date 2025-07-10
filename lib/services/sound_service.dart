import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static const String _soundEnabledKey = 'soundEnabled';
  bool _soundEnabled = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool get soundEnabled => _soundEnabled;

  SoundService() {
    _loadSoundSettings();
  }

  Future<void> _loadSoundSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, _soundEnabled);
  }

  Future<void> _playTone(double frequency, int durationMs) async {
    if (!_soundEnabled) return;

    try {
      // For web and mobile, we'll use a simple beep sound
      // You can replace this with actual sound files in the assets/sounds/ folder
      await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    } catch (e) {
      // If sound files don't exist, we'll use system sounds or ignore
      print('Sound not available: $e');
    }
  }

  void playFeedSound() {
    _playTone(440, 200); // A4 note
  }

  void playPlaySound() {
    _playTone(660, 150); // E5 note
  }

  void playCleanSound() {
    _playTone(880, 100); // A5 note
  }

  void playSleepSound() {
    _playTone(220, 500); // A3 note
  }

  void playAchievementSound() {
    _playTone(1000, 300); // Higher celebratory tone
  }

  void playMessageSound() {
    _playTone(800, 200); // Message notification tone
  }

  void dispose() {
    _audioPlayer.dispose();
  }
} 