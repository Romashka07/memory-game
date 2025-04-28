import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/blocks/game/game_achievements.dart';
import 'package:memory_game/utils/preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  void printTestState(String message, {Map<String, dynamic>? state}) {
    print('\n=== $message ===');
    if (state != null) {
      state.forEach((key, value) {
        print('$key: $value');
      });
    }
    print('================\n');
  }

  setUp(() async {
    print('\nSetting up new test...');
    // Ініціалізація SharedPreferences для тестування
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    
    // Скидання всіх досягнень та прогресу
    await PreferencesManager.resetAchievements();
    await prefs.remove('completed_levels');
    print('Test environment reset complete');
  });

  group('Card Mismatch Tests', () {
    test('Cards flip back after mismatch', () async {
      print('\nTesting card flip back after mismatch...');
      // Створення стану гри з помилкою (імітація неспівпадіння карток)
      final gameAchievements = GameAchievements(
        level: 1,
        hasMadeMistake: true,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial game state', state: {
        'Level': gameAchievements.level,
        'Has mistake': gameAchievements.hasMadeMistake,
        'Time left': gameAchievements.timeLeft,
        'Diamonds': gameAchievements.diamonds
      });
      
      await gameAchievements.saveProgress();
      print('Progress saved');
      
      // Перевірка, що рівень позначено як завершений, але не ідеальний
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final perfectLevels = await PreferencesManager.getPerfectLevels();
      
      printTestState('Level completion status', state: {
        'Completed levels': completedLevels,
        'Perfect levels': perfectLevels
      });
      
      expect(completedLevels, contains(1));
      expect(perfectLevels, isEmpty);
      
      // Перевірка, що помилка правильно відстежується
      final newAchievements = await PreferencesManager.getNewAchievements();
      print('New achievements: $newAchievements');
      expect(newAchievements, isEmpty);
    });

    test('Mistake tracking after card mismatch', () async {
      print('\nTesting mistake tracking after card mismatch...');
      // Створення стану гри з помилкою
      final gameAchievements = GameAchievements(
        level: 1,
        hasMadeMistake: true,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial game state', state: {
        'Level': gameAchievements.level,
        'Has mistake': gameAchievements.hasMadeMistake
      });
      
      await gameAchievements.saveProgress();
      print('Progress saved');
      
      // Перевірка, що рівень позначено як завершений, але не ідеальний
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final perfectLevels = await PreferencesManager.getPerfectLevels();
      
      printTestState('Level completion status', state: {
        'Completed levels': completedLevels,
        'Perfect levels': perfectLevels
      });
      
      expect(completedLevels, contains(1));
      expect(perfectLevels, isEmpty);
    });

    test('Multiple mismatches tracking', () async {
      print('\nTesting multiple mismatches tracking...');
      // Створення кількох станів гри з помилками
      for (int i = 0; i < 3; i++) {
        final gameAchievements = GameAchievements(
          level: i + 1,
          hasMadeMistake: true,
          hasUsedHint: false,
          hasUsedPairHint: false,
          hasUsedFreezeHint: false,
          hasUsedShowAllHint: false,
          timeLeft: 60,
          isTimerFrozen: false,
          diamonds: 100,
        );
        
        printTestState('Saving progress for level ${i + 1}', state: {
          'Level': gameAchievements.level,
          'Has mistake': gameAchievements.hasMadeMistake
        });
        
        await gameAchievements.saveProgress();
      }
      
      // Перевірка, що всі рівні позначені як завершені, але не ідеальні
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final perfectLevels = await PreferencesManager.getPerfectLevels();
      
      printTestState('Final level completion status', state: {
        'Completed levels count': completedLevels.length,
        'Perfect levels count': perfectLevels.length
      });
      
      expect(completedLevels.length, 3);
      expect(perfectLevels, isEmpty);
    });

    test('Mistakes affect perfect level achievement', () async {
      print('\nTesting perfect level achievement with mistakes...');
      // Створення стану гри з помилкою
      final gameAchievements = GameAchievements(
        level: 1,
        hasMadeMistake: true,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial game state', state: {
        'Level': gameAchievements.level,
        'Has mistake': gameAchievements.hasMadeMistake
      });
      
      await gameAchievements.checkAchievements();
      print('Achievements checked');
      
      // Перевірка, що досягнення ідеального рівня не нагороджено
      final perfectLevels = await PreferencesManager.getPerfectLevels();
      print('Perfect levels: $perfectLevels');
      expect(perfectLevels, isEmpty);
    });

    test('Mistakes tracked separately for each level', () async {
      print('\nTesting separate mistake tracking for different levels...');
      // Створення стану гри з помилкою для рівня 1
      final level1Achievements = GameAchievements(
        level: 1,
        hasMadeMistake: true,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Level 1 state', state: {
        'Level': level1Achievements.level,
        'Has mistake': level1Achievements.hasMadeMistake
      });
      
      await level1Achievements.saveProgress();
      await level1Achievements.checkAchievements();
      
      // Створення стану гри без помилок для рівня 2
      final level2Achievements = GameAchievements(
        level: 2,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Level 2 state', state: {
        'Level': level2Achievements.level,
        'Has mistake': level2Achievements.hasMadeMistake
      });
      
      await level2Achievements.saveProgress();
      await level2Achievements.checkAchievements();
      
      // Перевірка, що обидва рівні завершені
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final perfectLevels = await PreferencesManager.getPerfectLevels();
      
      printTestState('Final level completion status', state: {
        'Completed levels': completedLevels,
        'Perfect levels': perfectLevels
      });
      
      expect(completedLevels.length, 2);
      expect(perfectLevels, contains(2));
      expect(perfectLevels, isNot(contains(1)));
    });

    test('Mistakes correctly reflected in achievements', () async {
      print('\nTesting achievement reflection with mistakes...');
      // Створення стану гри з помилкою
      final gameAchievements = GameAchievements(
        level: 1,
        hasMadeMistake: true,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial game state', state: {
        'Level': gameAchievements.level,
        'Has mistake': gameAchievements.hasMadeMistake
      });
      
      await gameAchievements.checkAchievements();
      print('Achievements checked');
      
      // Перевірка, що немає нових досягнень
      final newAchievements = await PreferencesManager.getNewAchievements();
      print('New achievements: $newAchievements');
      expect(newAchievements, isEmpty);
    });
  });
} 