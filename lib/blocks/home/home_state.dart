import 'package:flutter/material.dart';
import 'package:memory_game/utils/background_music_manager.dart';
import 'package:memory_game/utils/preferences_manager.dart';

class HomeState extends ChangeNotifier {
  final BackgroundMusicManager _audioManager = BackgroundMusicManager();
  
  bool _isMusicPlaying = false;
  double _volume = 1.0;

  HomeState() {
    initializeAudio();
  }

  Future<void> initializeAudio() async {
    await _audioManager.initialize();
    _volume = await PreferencesManager.getVolume();
    await _audioManager.setVolume(_volume);
    
    // Спробуємо відтворити музику, але не будемо показувати помилку, якщо це не вдасться
    try {
      await _audioManager.play();
      _isMusicPlaying = true;
    } catch (e) {
      _isMusicPlaying = false;
    }
    notifyListeners();
  }

  Future<void> toggleMusic() async {
    if (_isMusicPlaying) {
      await _audioManager.pause();
    } else {
      await _audioManager.play();
    }
    _isMusicPlaying = _audioManager.isPlaying;
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await PreferencesManager.setVolume(volume);
    await _audioManager.setVolume(volume);
    notifyListeners();
  }

  double get volume => _volume;
  bool get isMusicPlaying => _isMusicPlaying;

  @override
  void dispose() {
    _audioManager.dispose();
    super.dispose();
  }
} 