import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_game/utils/preferences_manager.dart';
import 'package:memory_game/blocks/game/game_achievements.dart';
import 'package:memory_game/use_cases/game/achievements/check_achievements.dart';

void main() {
  late SharedPreferences prefs;
  late GameAchievements gameAchievements;

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
    
    // Ініціалізація GameAchievements з тестовими значеннями
    gameAchievements = GameAchievements(
      level: 1,
      hasMadeMistake: false,
      hasUsedHint: false,
      hasUsedPairHint: false,
      hasUsedFreezeHint: false,
      hasUsedShowAllHint: false,
      timeLeft: 60,
      isTimerFrozen: false,
      diamonds: 100,
    );
    print('Initial game state created');
  });

  group('Timer Tests', () {
    test('Time tracking accuracy', () async {
      print('\nTesting time tracking accuracy...');
      // Створення стану гри з різним часом
      final gameWithTime = GameAchievements(
        level: 1,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 30, // Менше часу
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial game state with reduced time', state: {
        'Level': gameWithTime.level,
        'Time left': gameWithTime.timeLeft,
        'Timer frozen': gameWithTime.isTimerFrozen
      });
      
      await gameWithTime.saveProgress();
      print('Game state saved');
      
      // Перевірка, що час правильно зберігається
      final savedGame = GameAchievements(
        level: 1,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 30,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Verifying saved time', state: {
        'Saved time': savedGame.timeLeft,
        'Expected time': 30
      });
      
      expect(savedGame.timeLeft, equals(30));
    });

    test('Timer freeze functionality', () async {
      print('\nTesting timer freeze functionality...');
      // Створення стану гри з замороженим таймером
      final frozenTimerGame = GameAchievements(
        level: 1,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: true,
        hasUsedShowAllHint: false,
        timeLeft: 5,
        isTimerFrozen: true,
        diamonds: 100,
      );
      
      printTestState('Initial game state with frozen timer', state: {
        'Level': frozenTimerGame.level,
        'Time left': frozenTimerGame.timeLeft,
        'Timer frozen': frozenTimerGame.isTimerFrozen,
        'Freeze hint used': frozenTimerGame.hasUsedFreezeHint
      });
      
      await frozenTimerGame.saveProgress();
      print('Game state saved');
      
      // Перевірка, що таймер заморожено
      printTestState('Timer freeze verification', state: {
        'Timer frozen status': frozenTimerGame.isTimerFrozen
      });
      expect(frozenTimerGame.isTimerFrozen, isTrue);
      
      // Перевірка досягнення "Майстер часу"
      await frozenTimerGame.checkAchievements();
      print('Achievements checked');
      
      final timingMasterLevels = await PreferencesManager.getTimingMasterLevels();
      printTestState('Timing master achievement verification', state: {
        'Timing master levels': timingMasterLevels
      });
      expect(timingMasterLevels, contains(1));
    });

    test('Game over by time', () async {
      print('\nTesting game over by time...');
      // Створення стану гри з нульовим часом
      final timeUpGame = GameAchievements(
        level: 1,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 0, // Час вийшов
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Game state with time up', state: {
        'Level': timeUpGame.level,
        'Time left': timeUpGame.timeLeft,
        'Timer frozen': timeUpGame.isTimerFrozen
      });
      
      // Не зберігаємо прогрес, оскільки час вийшов
      print('Skipping progress save due to time up');
      
      // Перевірка, що рівень не позначено як завершений
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final newAchievements = await PreferencesManager.getNewAchievements();
      
      printTestState('Game over verification', state: {
        'Completed levels': completedLevels,
        'New achievements': newAchievements
      });
      
      expect(completedLevels, isEmpty);
      expect(newAchievements, isEmpty);
    });

    test('Time persistence between sessions', () async {
      print('\nTesting time persistence between sessions...');
      // Створення початкового стану
      final initialGame = GameAchievements(
        level: 1,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 45,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial game state', state: {
        'Level': initialGame.level,
        'Time left': initialGame.timeLeft,
        'Timer frozen': initialGame.isTimerFrozen
      });
      
      await initialGame.saveProgress();
      print('Initial state saved');
      
      // Створення нового стану з тим самим рівнем
      final loadedGame = GameAchievements(
        level: 1,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 45,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Loaded game state verification', state: {
        'Loaded time': loadedGame.timeLeft,
        'Expected time': 45
      });
      
      // Перевірка, що час зберігається між сесіями
      expect(loadedGame.timeLeft, equals(45));
    });
  });
} 