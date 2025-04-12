import '../../utils/preferences_manager.dart';

class ProfileStats {
  int unlockedAchievements = 0;
  int totalAchievements = 5;
  int completedLevels = 0;
  int totalLevels = 9;
  int hintsUsed = 0;

  Future<void> loadStatistics() async {
    // Завантаження даних про досягнення
    final perfectLevels = await PreferencesManager.getPerfectLevels();
    final levelsWithoutHints = await PreferencesManager.getLevelsWithoutHints();
    final strategistLevels = await PreferencesManager.getStrategistLevels();
    final timingMasterLevels = await PreferencesManager.getTimingMasterLevels();
    
    // Підрахунок відкритих досягнень
    int unlockedCount = 0;
    if (perfectLevels.isNotEmpty) unlockedCount++;
    if (levelsWithoutHints.length >= 3) unlockedCount++;
    if (strategistLevels.isNotEmpty) unlockedCount++;
    if (timingMasterLevels.isNotEmpty) unlockedCount++;
    
    // Завантаження даних про пройдені рівні
    final completedLevels = await PreferencesManager.getCompletedLevels();
    
    // Завантаження даних про використані підказки
    final hintsUsed = await PreferencesManager.getHintsUsed();
    
    this.unlockedAchievements = unlockedCount;
    this.completedLevels = completedLevels.length;
    this.hintsUsed = hintsUsed;
  }
} 