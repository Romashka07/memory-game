import '../../utils/preferences_manager.dart';

class AchievementsState {
  int perfectLevelsCount = 0;
  int levelsWithoutHintsCount = 0;
  int totalLevelsCompleted = 0;
  int strategistLevelsCount = 0;
  int timingMasterLevelsCount = 0;

  Future<void> loadAchievements() async {
    final perfectLevels = await PreferencesManager.getPerfectLevels();
    final levelsWithoutHints = await PreferencesManager.getLevelsWithoutHints();
    final completedLevels = await PreferencesManager.getCompletedLevels();
    final strategistLevels = await PreferencesManager.getStrategistLevels();
    final timingMasterLevels = await PreferencesManager.getTimingMasterLevels();

    perfectLevelsCount = perfectLevels.length.clamp(0, 1);
    levelsWithoutHintsCount = levelsWithoutHints.length.clamp(0, 3);
    totalLevelsCompleted = completedLevels.length.clamp(0, 9);
    strategistLevelsCount = strategistLevels.length.clamp(0, 1);
    timingMasterLevelsCount = timingMasterLevels.length.clamp(0, 1);
  }
} 