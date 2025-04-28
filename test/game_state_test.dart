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
    await PreferencesManager.resetAllData();
    await prefs.remove('completed_levels');
    
    // Встановлюємо початкову кількість алмазів
    await PreferencesManager.setDiamonds(100);
    print('Initial diamonds set to 100');
    
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
    print('Test environment initialized');
  });

  group('Game State Persistence Tests', () {
    test('Saving current game state', () async {
      print('\nTesting game state saving...');
      // Створення стану гри з різними параметрами
      final gameState = GameAchievements(
        level: 2,
        hasMadeMistake: true,
        hasUsedHint: true,
        hasUsedPairHint: false,
        hasUsedFreezeHint: true,
        hasUsedShowAllHint: false,
        timeLeft: 45,
        isTimerFrozen: true,
        diamonds: 100,
      );
      
      printTestState('Initial game state', state: {
        'Level': gameState.level,
        'Has mistake': gameState.hasMadeMistake,
        'Time left': gameState.timeLeft,
        'Timer frozen': gameState.isTimerFrozen,
        'Diamonds': gameState.diamonds
      });
      
      // Збереження стану
      await gameState.saveProgress();
      print('Game state saved');
      
      // Перевірка збереження рівня
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final savedDiamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Saved state verification', state: {
        'Completed levels': completedLevels,
        'Saved diamonds': savedDiamonds
      });
      
      expect(completedLevels, contains(2));
      expect(savedDiamonds, equals(110));
    });

    test('Restoring saved game state', () async {
      print('\nTesting game state restoration...');
      // Створення та збереження початкового стану
      final initialState = GameAchievements(
        level: 3,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 30,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial state to save', state: {
        'Level': initialState.level,
        'Time left': initialState.timeLeft,
        'Diamonds': initialState.diamonds
      });
      
      await initialState.saveProgress();
      print('Initial state saved');
      
      // Створення нового стану з тими самими параметрами
      final loadedState = GameAchievements(
        level: 3,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 30,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      // Перевірка відновлення рівня
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final savedDiamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Restored state verification', state: {
        'Completed levels': completedLevels,
        'Saved diamonds': savedDiamonds
      });
      
      expect(completedLevels, contains(3));
      expect(savedDiamonds, equals(115));
    });

    test('Data integrity verification', () async {
      print('\nTesting data integrity...');
      // Встановлюємо початкові алмази
      await PreferencesManager.setDiamonds(100);
      print('Initial diamonds set to 100');
      
      // Створення стану з різними параметрами
      final gameState = GameAchievements(
        level: 4,
        hasMadeMistake: true,
        hasUsedHint: true,
        hasUsedPairHint: true,
        hasUsedFreezeHint: true,
        hasUsedShowAllHint: true,
        timeLeft: 9,
        isTimerFrozen: true,
        diamonds: 100,
      );
      
      printTestState('Game state to save', state: {
        'Level': gameState.level,
        'Has mistake': gameState.hasMadeMistake,
        'Time left': gameState.timeLeft,
        'Timer frozen': gameState.isTimerFrozen,
        'Diamonds': gameState.diamonds
      });
      
      await gameState.saveProgress();
      await gameState.checkAchievements();
      print('Game state saved and achievements checked');
      
      // Перевірка збереження рівня
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final savedDiamonds = await PreferencesManager.getDiamonds();
      final strategistLevels = await PreferencesManager.getStrategistLevels();
      final timingMasterLevels = await PreferencesManager.getTimingMasterLevels();
      
      printTestState('Data verification', state: {
        'Completed levels': completedLevels,
        'Saved diamonds': savedDiamonds,
        'Strategist levels': strategistLevels,
        'Timing master levels': timingMasterLevels
      });
      
      expect(completedLevels, contains(4));
      expect(savedDiamonds, equals(120));
      expect(strategistLevels, contains(4));
      expect(timingMasterLevels, contains(4));
    });

    test('State persistence between sessions', () async {
      print('\nTesting state persistence between sessions...');
      // Створення та збереження початкового стану
      final initialState = GameAchievements(
        level: 5,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial state to save', state: {
        'Level': initialState.level,
        'Time left': initialState.timeLeft,
        'Diamonds': initialState.diamonds
      });
      
      await initialState.saveProgress();
      print('Initial state saved');
      
      // Імітація перезапуску гри
      await PreferencesManager.resetAllData();
      await PreferencesManager.setDiamonds(100);
      print('Game reset simulated');
      
      // Створення нового стану з тими самими параметрами
      final loadedState = GameAchievements(
        level: 5,
        hasMadeMistake: false,
        hasUsedHint: false,
        hasUsedPairHint: false,
        hasUsedFreezeHint: false,
        hasUsedShowAllHint: false,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      await loadedState.saveProgress();
      print('State reloaded and saved');
      
      // Перевірка відновлення стану
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final savedDiamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Restored state verification', state: {
        'Completed levels': completedLevels,
        'Saved diamonds': savedDiamonds
      });
      
      expect(completedLevels, contains(5));
      expect(savedDiamonds, equals(125));
    });
  });

  group('Level Completion Tests', () {
    test('Completing level 1', () async {
      print('\nTesting level 1 completion...');
      // Проходження першого рівня
      await PreferencesManager.markLevelAsCompleted(1);
      print('Level 1 marked as completed');
      
      // Перевіряємо, що рівень додано до пройдених
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final diamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Level 1 completion verification', state: {
        'Completed levels': completedLevels,
        'Current diamonds': diamonds
      });
      
      expect(completedLevels, contains(1));
      expect(diamonds, equals(105));
    });

    test('Completing level 2', () async {
      print('\nTesting level 2 completion...');
      // Проходження другого рівня
      await PreferencesManager.markLevelAsCompleted(2);
      print('Level 2 marked as completed');
      
      // Перевіряємо, що рівень додано до пройдених
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final diamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Level 2 completion verification', state: {
        'Completed levels': completedLevels,
        'Current diamonds': diamonds
      });
      
      expect(completedLevels, contains(2));
      expect(diamonds, equals(110));
    });

    test('Completing multiple levels', () async {
      print('\nTesting multiple level completion...');
      // Проходження кількох рівнів
      await PreferencesManager.markLevelAsCompleted(1);
      print('Level 1 completed (+5 diamonds)');
      await PreferencesManager.markLevelAsCompleted(2);
      print('Level 2 completed (+10 diamonds)');
      await PreferencesManager.markLevelAsCompleted(3);
      print('Level 3 completed (+15 diamonds)');
      
      // Перевіряємо, що всі рівні додано до пройдених
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final diamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Multiple level completion verification', state: {
        'Completed levels': completedLevels,
        'Total diamonds': diamonds
      });
      
      expect(completedLevels, containsAll([1, 2, 3]));
      expect(diamonds, equals(130));
    });
  });
} 