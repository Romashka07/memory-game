import '../../utils/preferences_manager.dart';

class LevelAchievements {
  final List<String> achievementNotifications = [];
  bool isShowingAchievements = false;

  Future<void> loadNewAchievements() async {
    final achievements = await PreferencesManager.getNewAchievements();
    final shownAchievements = await PreferencesManager.getShownAchievements();
    
    if (achievements.isNotEmpty) {
      // Фільтрація досягнень, які ще не були показані
      final newAchievements = achievements.where((achievement) => !shownAchievements.contains(achievement)).toList();
      
      // Перевірка на повне виконання досягнень
      bool hasCompletedAchievement = false;
      
      for (final achievement in newAchievements) {
        // Перевірка повного виконання досягнення
        if (await _isAchievementCompleted(achievement)) {
          hasCompletedAchievement = true;
          // Позначення досягнення як показаного
          await PreferencesManager.markAchievementAsShown(achievement);
        }
      }
      
      if (hasCompletedAchievement) {
        achievementNotifications.addAll(newAchievements);
        isShowingAchievements = true;
      }
    }
  }
  
  Future<bool> _isAchievementCompleted(String achievementTitle) async {
    // Перевірка різних типів досягнень
    if (achievementTitle == 'Complete the level without any mistakes') {
      final perfectLevels = await PreferencesManager.getPerfectLevels();
      return perfectLevels.length >= 1;
    } else if (achievementTitle == 'Complete 3 levels without using hints') {
      final levelsWithoutHints = await PreferencesManager.getLevelsWithoutHints();
      return levelsWithoutHints.length >= 3;
    } else if (achievementTitle == 'Use all hints in one level') {
      final strategistLevels = await PreferencesManager.getStrategistLevels();
      return strategistLevels.length >= 1;
    } else if (achievementTitle == 'Use freeze timer when less than 10 seconds left') {
      final timingMasterLevels = await PreferencesManager.getTimingMasterLevels();
      return timingMasterLevels.length >= 1;
    }
    
    // Для інших досягнень повертаємо false
    return false;
  }

  void clearAchievements() {
    achievementNotifications.clear();
    isShowingAchievements = false;
  }
} 