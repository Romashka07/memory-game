import 'package:audioplayers/audioplayers.dart';
import 'preferences_manager.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundEnabled = true;
  bool _areClickEffectsEnabled = true;

  factory SoundManager() {
    return _instance;
  }

  SoundManager._internal() {
    _loadSoundState();
  }

  Future<void> _loadSoundState() async {
    _isSoundEnabled = await PreferencesManager.getSoundEnabled();
    _areClickEffectsEnabled = await PreferencesManager.getClickEffects();
  }

  Future<void> playClickSound() async {
    if (_isSoundEnabled && _areClickEffectsEnabled) {
      await _audioPlayer.play(AssetSource('audio/click_sound.wav'));
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  Future<void> updateSoundState(bool isEnabled) async {
    _isSoundEnabled = isEnabled;
  }

  Future<void> updateClickEffectsState(bool isEnabled) async {
    _areClickEffectsEnabled = isEnabled;
  }
} 