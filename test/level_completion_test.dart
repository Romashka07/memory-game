import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_game/utils/preferences_manager.dart';
import 'package:memory_game/blocks/game/game_achievements.dart';
import 'package:memory_game/use_cases/game/achievements/check_achievements.dart';
import 'package:memory_game/use_cases/game/achievements/update_achievement_progress.dart';

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
    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    
    // Reset all achievements and progress
    await PreferencesManager.resetAchievements();
    await prefs.remove('completed_levels');
    print('Test environment reset complete');
    
    // Initialize GameAchievements with test values
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

  group('Level Completion Tests', () {
    test('Level completion is properly tracked', () async {
      print('\nTesting level completion tracking...');
      // Complete a level
      await gameAchievements.saveProgress();
      print('Level progress saved');
      
      // Verify level is marked as completed
      final completedLevels = await PreferencesManager.getCompletedLevels();
      
      printTestState('Level completion verification', state: {
        'Completed levels': completedLevels
      });
      
      expect(completedLevels, contains(1));
    });

    test('Perfect level achievement is awarded correctly', () async {
      print('\nTesting perfect level achievement...');
      // Complete a level perfectly (no mistakes, no hints)
      await gameAchievements.checkAchievements();
      print('Achievements checked');
      
      // Verify perfect level achievement
      final perfectLevels = await PreferencesManager.getPerfectLevels();
      final newAchievements = await PreferencesManager.getNewAchievements();
      
      printTestState('Achievement verification', state: {
        'Perfect levels': perfectLevels,
        'New achievements': newAchievements
      });
      
      expect(perfectLevels, contains(1));
      expect(newAchievements, contains('Complete the level without any mistakes'));
    });

    test('No hints achievement is tracked correctly', () async {
      print('\nTesting no hints achievement...');
      // Complete a level without using hints
      await gameAchievements.checkAchievements();
      print('Achievements checked');
      
      // Verify level is added to levels without hints
      final levelsWithoutHints = await PreferencesManager.getLevelsWithoutHints();
      
      printTestState('No hints achievement verification', state: {
        'Levels without hints': levelsWithoutHints
      });
      
      expect(levelsWithoutHints, contains(1));
    });

    test('Strategist achievement is awarded correctly', () async {
      print('\nTesting strategist achievement...');
      // Create a game state where all hints were used
      final strategistGameAchievements = GameAchievements(
        level: 1,
        hasMadeMistake: false,
        hasUsedHint: true,
        hasUsedPairHint: true,
        hasUsedFreezeHint: true,
        hasUsedShowAllHint: true,
        timeLeft: 60,
        isTimerFrozen: false,
        diamonds: 100,
      );
      
      printTestState('Initial strategist game state', state: {
        'Level': strategistGameAchievements.level,
        'All hints used': true
      });
      
      await strategistGameAchievements.checkAchievements();
      print('Achievements checked');
      
      // Verify strategist achievement
      final strategistLevels = await PreferencesManager.getStrategistLevels();
      final newAchievements = await PreferencesManager.getNewAchievements();
      
      printTestState('Strategist achievement verification', state: {
        'Strategist levels': strategistLevels,
        'New achievements': newAchievements
      });
      
      expect(strategistLevels, contains(1));
      expect(newAchievements, contains('Use all hints in one level'));
    });

    test('Timing master achievement is awarded correctly', () async {
      print('\nTesting timing master achievement...');
      // Create a game state where timer was frozen with less than 10 seconds left
      final timingMasterGameAchievements = GameAchievements(
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
      
      printTestState('Initial timing master game state', state: {
        'Level': timingMasterGameAchievements.level,
        'Time left': timingMasterGameAchievements.timeLeft,
        'Timer frozen': timingMasterGameAchievements.isTimerFrozen
      });
      
      await timingMasterGameAchievements.checkAchievements();
      print('Achievements checked');
      
      // Verify timing master achievement
      final timingMasterLevels = await PreferencesManager.getTimingMasterLevels();
      final newAchievements = await PreferencesManager.getNewAchievements();
      
      printTestState('Timing master achievement verification', state: {
        'Timing master levels': timingMasterLevels,
        'New achievements': newAchievements
      });
      
      expect(timingMasterLevels, contains(1));
      expect(newAchievements, contains('Use freeze timer when less than 10 seconds left'));
    });

    test('Diamonds are awarded correctly for level completion', () async {
      print('\nTesting diamond rewards...');
      // Complete a level
      await gameAchievements.saveProgress();
      print('Level progress saved');
      
      // Verify diamonds are awarded
      final currentDiamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Diamond reward verification', state: {
        'Current diamonds': currentDiamonds,
        'Initial diamonds': 100
      });
      
      expect(currentDiamonds, greaterThan(100));
    });

    test('Progress is saved correctly after level completion', () async {
      print('\nTesting progress saving...');
      // Complete a level
      await gameAchievements.saveProgress();
      print('Level progress saved');
      
      // Verify progress is saved
      final completedLevels = await PreferencesManager.getCompletedLevels();
      final diamonds = await PreferencesManager.getDiamonds();
      
      printTestState('Progress verification', state: {
        'Completed levels count': completedLevels.length,
        'Current diamonds': diamonds
      });
      
      expect(completedLevels.length, 1);
      expect(diamonds, greaterThan(100));
    });

    test('Multiple level completions are tracked correctly', () async {
      print('\nTesting multiple level completions...');
      // Complete multiple levels
      for (int level = 1; level <= 3; level++) {
        final achievements = GameAchievements(
          level: level,
          hasMadeMistake: false,
          hasUsedHint: false,
          hasUsedPairHint: false,
          hasUsedFreezeHint: false,
          hasUsedShowAllHint: false,
          timeLeft: 60,
          isTimerFrozen: false,
          diamonds: 100,
        );
        
        printTestState('Completing level $level', state: {
          'Level': achievements.level,
          'Time left': achievements.timeLeft
        });
        
        await achievements.saveProgress();
        print('Level $level progress saved');
      }
      
      // Verify all levels are marked as completed
      final completedLevels = await PreferencesManager.getCompletedLevels();
      
      printTestState('Multiple level completion verification', state: {
        'Completed levels': completedLevels,
        'Total levels completed': completedLevels.length
      });
      
      expect(completedLevels.length, 3);
      expect(completedLevels, contains(1));
      expect(completedLevels, contains(2));
      expect(completedLevels, contains(3));
    });
  });
} 