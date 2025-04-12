import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/sound_manager.dart';
import '../utils/background_music_manager.dart';
import 'loading_screen.dart';
import 'home_screen.dart';
import '../blocks/settings/settings_state.dart';
import '../blocks/settings/settings_animations.dart';
import '../blocks/settings/settings_ui.dart';

// Екран налаштувань гри
class SettingsScreen extends StatefulWidget {
  final Widget previousScreen;

  const SettingsScreen({
    super.key,
    required this.previousScreen,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// Стан екрану налаштувань
class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late final SettingsState _state;
  late final SettingsAnimations _animations;

  @override
  void initState() {
    super.initState();
    _state = SettingsState(
      soundManager: SoundManager(),
      backgroundMusicManager: BackgroundMusicManager(),
    );
    _animations = SettingsAnimations(this);
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    await _state.loadSettings();
    setState(() {});
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  Future<void> _handleBack() async {
    await _state.soundManager.playClickSound();
    await _state.saveSettings();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            nextScreen: widget.previousScreen,
          ),
        ),
      );
    }
  }

  Future<void> _handleRestore() async {
    await _state.soundManager.playClickSound();
    await _state.restoreDefaultSettings();
    setState(() {});
  }

  Future<void> _handlePrivacy() async {
    await _state.soundManager.playClickSound();
    // Privacy logic
  }

  void _handleVolumeChange(double value) {
    setState(() {
      _state.volume = value;
    });
    _state.saveSettings();
  }

  Future<void> _handleClickEffectsChange(bool value) async {
    setState(() {
      _state.clickEffects = value;
    });
    await _state.saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    final _ui = SettingsUI(
      screenWidth: MediaQuery.of(context).size.width,
      state: _state,
      animations: _animations,
      onBackPressed: _handleBack,
      onRestorePressed: _handleRestore,
      onPrivacyPressed: _handlePrivacy,
      onVolumeChanged: _handleVolumeChange,
      onClickEffectsChanged: _handleClickEffectsChange,
    );

    return _ui.build(context);
  }
} 