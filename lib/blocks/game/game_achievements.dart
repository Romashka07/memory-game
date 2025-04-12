import 'package:flutter/material.dart';
import '../../use_cases/game/achievements/check_achievements.dart';
import '../../use_cases/game/achievements/save_achievements.dart';
import '../../use_cases/game/achievements/update_achievement_progress.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class GameAchievements {
  final int level;
  final bool hasMadeMistake;
  final bool hasUsedHint;
  final bool hasUsedPairHint;
  final bool hasUsedFreezeHint;
  final bool hasUsedShowAllHint;
  final int timeLeft;
  final bool isTimerFrozen;
  final int diamonds;

  final CheckAchievementsUseCase _checkAchievementsUseCase;
  final SaveAchievementsUseCase _saveAchievementsUseCase;
  final UpdateAchievementProgressUseCase _updateAchievementProgressUseCase;

  GameAchievements({
    required this.level,
    required this.hasMadeMistake,
    required this.hasUsedHint,
    required this.hasUsedPairHint,
    required this.hasUsedFreezeHint,
    required this.hasUsedShowAllHint,
    required this.timeLeft,
    required this.isTimerFrozen,
    required this.diamonds,
  }) : _checkAchievementsUseCase = CheckAchievementsUseCase(),
       _saveAchievementsUseCase = SaveAchievementsUseCase(),
       _updateAchievementProgressUseCase = UpdateAchievementProgressUseCase();

  // Перевірка досягнень при завершенні рівня
  Future<void> checkAchievements() async {
    final input = CheckAchievementsInput(
      level: level,
      hasMadeMistake: hasMadeMistake,
      hasUsedHint: hasUsedHint,
      hasUsedPairHint: hasUsedPairHint,
      hasUsedFreezeHint: hasUsedFreezeHint,
      hasUsedShowAllHint: hasUsedShowAllHint,
      timeLeft: timeLeft,
      isTimerFrozen: isTimerFrozen,
      diamonds: diamonds,
    );

    final output = await _checkAchievementsUseCase.execute(input);

    if (output.perfectLevelAchieved) {
      await _saveAchievementsUseCase.execute(SaveAchievementsInput(
        level: level,
        achievementName: 'Complete the level without any mistakes',
      ));
    }

    if (output.strategistAchieved) {
      await _saveAchievementsUseCase.execute(SaveAchievementsInput(
        level: level,
        achievementName: 'Use all hints in one level',
      ));
    }

    if (output.timingMasterAchieved) {
      await _saveAchievementsUseCase.execute(SaveAchievementsInput(
        level: level,
        achievementName: 'Use freeze timer when less than 10 seconds left',
      ));
    }
  }

  // Збереження прогресу рівня
  Future<void> saveProgress() async {
    await _updateAchievementProgressUseCase.execute(UpdateAchievementProgressInput(
      level: level,
      isCompleted: true,
    ));
  }
} 