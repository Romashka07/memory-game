import 'package:flutter/material.dart';
import '../../utils/preferences_manager.dart';
import '../../utils/sound_manager.dart';

class ProfileInfo {
  final SoundManager _soundManager = SoundManager();
  
  String nickname = '';
  String currentAvatar = 'profile_1';
  int diamonds = 0;
  bool isEditingNickname = false;
  final TextEditingController nicknameController = TextEditingController();
  static const int maxNicknameLength = 12;

  Future<void> loadNickname() async {
    final nickname = await PreferencesManager.getNickname();
    this.nickname = nickname;
  }

  Future<void> saveNickname(String newNickname) async {
    await _soundManager.playClickSound();
    if (newNickname.trim().isEmpty) {
      newNickname = 'Player';
    }
    await PreferencesManager.setNickname(newNickname);
    nickname = newNickname;
    isEditingNickname = false;
  }

  Future<void> loadAvatar() async {
    final avatar = await PreferencesManager.getAvatar();
    currentAvatar = avatar;
  }

  Future<void> loadDiamonds() async {
    final diamonds = await PreferencesManager.getDiamonds();
    this.diamonds = diamonds;
  }

  void dispose() {
    nicknameController.dispose();
  }
} 