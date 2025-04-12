import '../../../utils/preferences_manager.dart';
import '../../base_use_case.dart';

class CheckAchievementsInput {
  final int level;
  final bool hasMadeMistake;
  final bool hasUsedHint;
  final bool hasUsedPairHint;
  final bool hasUsedFreezeHint;
  final bool hasUsedShowAllHint;
  final int timeLeft;
  final bool isTimerFrozen;
  final int diamonds;

  CheckAchievementsInput({
    required this.level,
    required this.hasMadeMistake,
    required this.hasUsedHint,
    required this.hasUsedPairHint,
    required this.hasUsedFreezeHint,
    required this.hasUsedShowAllHint,
    required this.timeLeft,
    required this.isTimerFrozen,
    required this.diamonds,
  });
}

class CheckAchievementsOutput {
  final bool perfectLevelAchieved;
  final bool noHintsAchieved;
  final bool strategistAchieved;
  final bool timingMasterAchieved;

  CheckAchievementsOutput({
    required this.perfectLevelAchieved,
    required this.noHintsAchieved,
    required this.strategistAchieved,
    required this.timingMasterAchieved,
  });
}

class CheckAchievementsUseCase implements BaseUseCase<CheckAchievementsInput, CheckAchievementsOutput> {
  @override
  Future<CheckAchievementsOutput> execute(CheckAchievementsInput input) async {
    final completedLevels = await PreferencesManager.getCompletedLevels();
    final perfectLevels = await PreferencesManager.getPerfectLevels();
    final levelsWithoutHints = await PreferencesManager.getLevelsWithoutHints();
    final strategistLevels = await PreferencesManager.getStrategistLevels();
    final timingMasterLevels = await PreferencesManager.getTimingMasterLevels();
    final diamondsSpent = await PreferencesManager.getDiamondsSpent();

    bool perfectLevelAchieved = false;
    bool noHintsAchieved = false;
    bool strategistAchieved = false;
    bool timingMasterAchieved = false;

    // Check Perfect Level achievement
    if (!input.hasMadeMistake && !perfectLevels.contains(input.level) && perfectLevels.length < 1) {
      final initialDiamonds = await PreferencesManager.getInitialDiamonds();
      final currentDiamonds = await PreferencesManager.getDiamonds();
      final diamondsSpentOnLevel = initialDiamonds - currentDiamonds - diamondsSpent;
      
      if (diamondsSpentOnLevel == 0) {
        perfectLevelAchieved = true;
        await PreferencesManager.addPerfectLevel(input.level);
        await PreferencesManager.addNewAchievement('Complete the level without any mistakes');
      }
    }

    // Check No Hints achievement
    if (!input.hasUsedHint && !levelsWithoutHints.contains(input.level) && levelsWithoutHints.length < 3) {
      final initialDiamonds = await PreferencesManager.getInitialDiamonds();
      final currentDiamonds = await PreferencesManager.getDiamonds();
      final diamondsSpentOnLevel = initialDiamonds - currentDiamonds - diamondsSpent;
      
      if (diamondsSpentOnLevel == 0) {
        noHintsAchieved = true;
        await PreferencesManager.addLevelWithoutHints(input.level);
      }
    }

    // Check Strategist achievement
    if (input.hasUsedPairHint && input.hasUsedFreezeHint && input.hasUsedShowAllHint && 
        !strategistLevels.contains(input.level) && strategistLevels.length < 1) {
      strategistAchieved = true;
      await PreferencesManager.addStrategistLevel(input.level);
      await PreferencesManager.addNewAchievement('Use all hints in one level');
    }

    // Check Timing Master achievement
    if (input.timeLeft <= 10 && input.isTimerFrozen && 
        !timingMasterLevels.contains(input.level) && timingMasterLevels.length < 1) {
      timingMasterAchieved = true;
      await PreferencesManager.addTimingMasterLevel(input.level);
      await PreferencesManager.addNewAchievement('Use freeze timer when less than 10 seconds left');
    }

    return CheckAchievementsOutput(
      perfectLevelAchieved: perfectLevelAchieved,
      noHintsAchieved: noHintsAchieved,
      strategistAchieved: strategistAchieved,
      timingMasterAchieved: timingMasterAchieved,
    );
  }
} 