import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class PreferencesManager {
  static const String _completedLevelsKey = 'completed_levels';
  static const String _nicknameKey = 'nickname';
  static const String _defaultNickname = 'Player';
  static const String _avatarKey = 'avatar';
  static const String _defaultAvatar = 'profile_1';
  static const String _volumeKey = 'volume';
  static const String _clickEffectsKey = 'click_effects';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _diamondsKey = 'diamonds';
  static const int _defaultDiamonds = 100;
  static const String _initialDiamondsKey = 'initial_diamonds';
  
  // Ключі для досягнень
  static const String _perfectLevelsKey = 'perfect_levels';
  static const String _levelsWithoutHintsKey = 'levels_without_hints';
  static const String _totalLevelsCompletedKey = 'total_levels_completed';
  static const String _strategistLevelsKey = 'strategist_levels';
  static const String _timingMasterLevelsKey = 'timing_master_levels';
  static const String _newAchievementsKey = 'new_achievements';
  static const String _shownAchievementsKey = 'shown_achievements';
  static const String _hintsUsedKey = 'hints_used';

  static Future<void> setNickname(String nickname) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_nicknameKey, nickname);
      if (success) {
        developer.log('Successfully saved nickname: $nickname');
      } else {
        developer.log('Failed to save nickname', level: 1);
      }
    } catch (e) {
      developer.log('Error saving nickname: $e', level: 2);
    }
  }

  static Future<String> getNickname() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_nicknameKey) ?? _defaultNickname;
    } catch (e) {
      developer.log('Error getting nickname: $e', level: 2);
      return _defaultNickname;
    }
  }

  static Future<void> setAvatar(String avatarName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_avatarKey, avatarName);
      if (success) {
        developer.log('Successfully saved avatar: $avatarName');
      } else {
        developer.log('Failed to save avatar', level: 1);
      }
    } catch (e) {
      developer.log('Error saving avatar: $e', level: 2);
    }
  }

  static Future<String> getAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_avatarKey) ?? _defaultAvatar;
    } catch (e) {
      developer.log('Error getting avatar: $e', level: 2);
      return _defaultAvatar;
    }
  }

  static Future<void> markLevelAsCompleted(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedLevels = await getCompletedLevels();
      
      if (!completedLevels.contains(level) && completedLevels.length < 9) {
        completedLevels.add(level);
        final success = await prefs.setString(_completedLevelsKey, completedLevels.join(','));
        
        if (success) {
          // Нараховуємо кристали за пройдений рівень
          final currentDiamonds = await getDiamonds();
          final reward = _getDiamondsReward(level);
          await setDiamonds(currentDiamonds + reward);
          
          developer.log('Successfully saved completed level: $level');
          developer.log('Current completed levels: ${completedLevels.join(', ')}');
          developer.log('Awarded $reward diamonds for completing level $level');
        } else {
          developer.log('Failed to save completed level: $level', level: 1);
        }
      }
    } catch (e) {
      developer.log('Error saving completed level: $e', level: 2);
    }
  }

  // Метод для визначення кількості кристалів за рівень
  static int _getDiamondsReward(int level) {
    // Кожен рівень дає на 5 кристалів більше ніж попередній
    return level * 5;
  }

  static Future<List<int>> getCompletedLevels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? completedLevelsString = prefs.getString(_completedLevelsKey);
      
      if (completedLevelsString == null || completedLevelsString.isEmpty) {
        return [];
      }
      
      final levels = completedLevelsString
          .split(',')
          .map((e) => int.tryParse(e))
          .where((e) => e != null)
          .map((e) => e!)
          .toList();
      
      // Обмежуємо кількість рівнів до 9
      return levels.length > 9 ? levels.sublist(0, 9) : levels;
    } catch (e) {
      developer.log('Error getting completed levels: $e', level: 2);
      return [];
    }
  }

  static Future<void> resetAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Очищаємо всі дані
      developer.log('Successfully reset all data');
    } catch (e) {
      developer.log('Error resetting data: $e', level: 2);
    }
  }

  static Future<void> setVolume(double volume) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_volumeKey, volume);
      debugPrint('Volume saved: $volume');
    } catch (e) {
      debugPrint('Error saving volume: $e');
    }
  }

  static Future<double> getVolume() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_volumeKey) ?? 0.5; // За замовчуванням 0.5 (50%)
    } catch (e) {
      debugPrint('Error getting volume: $e');
      return 0.5;
    }
  }

  static Future<void> setClickEffects(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_clickEffectsKey, enabled);
      debugPrint('Click effects saved: $enabled');
    } catch (e) {
      debugPrint('Error saving click effects: $e');
    }
  }

  static Future<bool> getClickEffects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_clickEffectsKey) ?? true; // За замовчуванням увімкнено
    } catch (e) {
      debugPrint('Error getting click effects: $e');
      return true;
    }
  }

  static Future<void> setDiamonds(int diamonds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Зберігаємо початкову кількість кристалів при першому встановленні
      if (!prefs.containsKey(_initialDiamondsKey)) {
        await prefs.setInt(_initialDiamondsKey, diamonds);
      }
      await prefs.setInt(_diamondsKey, diamonds);
      debugPrint('Diamonds saved: $diamonds');
    } catch (e) {
      debugPrint('Error saving diamonds: $e');
    }
  }

  static Future<int> getInitialDiamonds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_initialDiamondsKey) ?? _defaultDiamonds;
    } catch (e) {
      debugPrint('Error getting initial diamonds: $e');
      return _defaultDiamonds;
    }
  }

  static Future<int> getDiamonds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_diamondsKey) ?? _defaultDiamonds;
    } catch (e) {
      debugPrint('Error getting diamonds: $e');
      return _defaultDiamonds;
    }
  }

  static Future<int> getDiamondsSpent() async {
    try {
      final initialDiamonds = await getInitialDiamonds();
      final currentDiamonds = await getDiamonds();
      return initialDiamonds - currentDiamonds;
    } catch (e) {
      debugPrint('Error getting diamonds spent: $e');
      return 0;
    }
  }

  static Future<List<int>> getPerfectLevels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? perfectLevelsString = prefs.getString(_perfectLevelsKey);
      if (perfectLevelsString == null || perfectLevelsString.isEmpty) {
        return [];
      }
      final levels = perfectLevelsString.split(',').map((e) => int.parse(e)).toList();
      // Обмежуємо кількість рівнів до 1
      return levels.length > 1 ? levels.sublist(0, 1) : levels;
    } catch (e) {
      debugPrint('Error getting perfect levels: $e');
      return [];
    }
  }

  static Future<void> addPerfectLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final perfectLevels = await getPerfectLevels();
      if (!perfectLevels.contains(level) && perfectLevels.length < 1) {
        perfectLevels.add(level);
        await prefs.setString(_perfectLevelsKey, perfectLevels.join(','));
      }
    } catch (e) {
      debugPrint('Error adding perfect level: $e');
    }
  }

  static Future<List<int>> getLevelsWithoutHints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? levelsString = prefs.getString(_levelsWithoutHintsKey);
      if (levelsString == null || levelsString.isEmpty) {
        return [];
      }
      final levels = levelsString.split(',').map((e) => int.parse(e)).toList();
      // Обмежуємо кількість рівнів до 3
      return levels.length > 3 ? levels.sublist(0, 3) : levels;
    } catch (e) {
      debugPrint('Error getting levels without hints: $e');
      return [];
    }
  }

  static Future<void> addLevelWithoutHints(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final levels = await getLevelsWithoutHints();
      
      debugPrint('=== ADDING LEVEL WITHOUT HINTS ===');
      debugPrint('Level to add: $level');
      debugPrint('Current levels without hints: ${levels.join(', ')}');
      
      // Перевіряємо, чи рівень ще не доданий до списку рівнів без підказок
      if (!levels.contains(level)) {
        levels.add(level);
        // Сортуємо рівні за зростанням
        levels.sort();
        // Обмежуємо кількість рівнів до 3
        final updatedLevels = levels.length > 3 ? levels.sublist(0, 3) : levels;
        await prefs.setString(_levelsWithoutHintsKey, updatedLevels.join(','));
        
        debugPrint('Added level $level to levels without hints');
        debugPrint('Updated levels without hints: ${updatedLevels.join(', ')}');
        
        // Якщо досягнуто 3 рівні без підказок, додаємо досягнення
        if (updatedLevels.length == 3) {
          debugPrint('Reached 3 levels without hints, adding achievement');
          await addNewAchievement('Complete 3 levels without using hints');
        }
      } else {
        debugPrint('Level $level already in list');
      }
    } catch (e) {
      debugPrint('Error adding level without hints: $e');
    }
  }

  static Future<int> getTotalLevelsCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_totalLevelsCompletedKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting total levels completed: $e');
      return 0;
    }
  }

  static Future<void> incrementTotalLevelsCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = await getTotalLevelsCompleted();
      await prefs.setInt(_totalLevelsCompletedKey, currentCount + 1);
    } catch (e) {
      debugPrint('Error incrementing total levels completed: $e');
    }
  }

  static Future<List<int>> getStrategistLevels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? levelsString = prefs.getString(_strategistLevelsKey);
      if (levelsString == null || levelsString.isEmpty) {
        return [];
      }
      final levels = levelsString.split(',').map((e) => int.parse(e)).toList();
      // Обмежуємо кількість рівнів до 1
      return levels.length > 1 ? levels.sublist(0, 1) : levels;
    } catch (e) {
      debugPrint('Error getting strategist levels: $e');
      return [];
    }
  }

  static Future<void> addStrategistLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final levels = await getStrategistLevels();
      if (!levels.contains(level) && levels.length < 1) {
        levels.add(level);
        await prefs.setString(_strategistLevelsKey, levels.join(','));
      }
    } catch (e) {
      debugPrint('Error adding strategist level: $e');
    }
  }

  static Future<List<int>> getTimingMasterLevels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? levelsString = prefs.getString(_timingMasterLevelsKey);
      if (levelsString == null || levelsString.isEmpty) {
        return [];
      }
      final levels = levelsString.split(',').map((e) => int.parse(e)).toList();
      // Обмежуємо кількість рівнів до 1
      return levels.length > 1 ? levels.sublist(0, 1) : levels;
    } catch (e) {
      debugPrint('Error getting timing master levels: $e');
      return [];
    }
  }

  static Future<void> addTimingMasterLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final levels = await getTimingMasterLevels();
      if (!levels.contains(level) && levels.length < 1) {
        levels.add(level);
        await prefs.setString(_timingMasterLevelsKey, levels.join(','));
      }
    } catch (e) {
      debugPrint('Error adding timing master level: $e');
    }
  }

  static Future<List<String>> getNewAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_newAchievementsKey) ?? [];
    } catch (e) {
      debugPrint('Error getting new achievements: $e');
      return [];
    }
  }

  static Future<void> addNewAchievement(String achievementTitle) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final achievements = await getNewAchievements();
      if (!achievements.contains(achievementTitle)) {
        achievements.add(achievementTitle);
        await prefs.setStringList(_newAchievementsKey, achievements);
      }
    } catch (e) {
      debugPrint('Error adding new achievement: $e');
    }
  }

  static Future<void> clearNewAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_newAchievementsKey);
    } catch (e) {
      debugPrint('Error clearing new achievements: $e');
    }
  }

  static Future<List<String>> getShownAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_shownAchievementsKey) ?? [];
    } catch (e) {
      debugPrint('Error getting shown achievements: $e');
      return [];
    }
  }

  static Future<void> markAchievementAsShown(String achievementTitle) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shownAchievements = await getShownAchievements();
      if (!shownAchievements.contains(achievementTitle)) {
        shownAchievements.add(achievementTitle);
        await prefs.setStringList(_shownAchievementsKey, shownAchievements);
      }
    } catch (e) {
      debugPrint('Error marking achievement as shown: $e');
    }
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundEnabledKey, enabled);
      if (!enabled) {
        await setVolume(0.0); // Якщо звук вимкнено, встановлюємо гучність на 0
      } else {
        await setVolume(0.5); // Якщо звук увімкнено, встановлюємо гучність на 50%
      }
      debugPrint('Sound enabled state saved: $enabled');
    } catch (e) {
      debugPrint('Error saving sound enabled state: $e');
    }
  }

  static Future<bool> getSoundEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_soundEnabledKey) ?? true; // За замовчуванням увімкнено
    } catch (e) {
      debugPrint('Error getting sound enabled state: $e');
      return true;
    }
  }

  static Future<void> resetAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_perfectLevelsKey);
      await prefs.remove(_levelsWithoutHintsKey);
      await prefs.remove(_strategistLevelsKey);
      await prefs.remove(_timingMasterLevelsKey);
      await prefs.remove(_newAchievementsKey);
      await prefs.remove(_shownAchievementsKey);
      debugPrint('All achievements have been reset');
    } catch (e) {
      debugPrint('Error resetting achievements: $e');
    }
  }

  static Future<int> getHintsUsed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_hintsUsedKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting hints used: $e');
      return 0;
    }
  }

  static Future<void> incrementHintsUsed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHints = await getHintsUsed();
      await prefs.setInt(_hintsUsedKey, currentHints + 1);
    } catch (e) {
      debugPrint('Error incrementing hints used: $e');
    }
  }
} 