import '../../utils/preferences_manager.dart';
import '../../utils/sound_manager.dart';
import '../../utils/background_music_manager.dart';

class SettingsState {
  double volume = 0.5;
  bool clickEffects = true;
  final SoundManager soundManager;
  final BackgroundMusicManager backgroundMusicManager;

  SettingsState({
    required this.soundManager,
    required this.backgroundMusicManager,
  });

  Future<void> loadSettings() async {
    final volume = await PreferencesManager.getVolume();
    final clickEffects = await PreferencesManager.getClickEffects();
    final soundEnabled = await PreferencesManager.getSoundEnabled();
    this.volume = soundEnabled ? volume : 0.0;
    this.clickEffects = clickEffects;
  }

  Future<void> saveSettings() async {
    await PreferencesManager.setVolume(volume);
    await PreferencesManager.setClickEffects(clickEffects);
    await PreferencesManager.setSoundEnabled(volume > 0);
    await soundManager.updateSoundState(volume > 0);
    await soundManager.updateClickEffectsState(clickEffects);
    await backgroundMusicManager.setVolume(volume);
  }

  Future<void> restoreDefaultSettings() async {
    volume = 0.5;
    clickEffects = true;
    await saveSettings();
  }
} 