import '../../../utils/preferences_manager.dart';
import '../../base_use_case.dart';

class SaveAchievementsInput {
  final int level;
  final String achievementName;

  SaveAchievementsInput({
    required this.level,
    required this.achievementName,
  });
}

class SaveAchievementsOutput {
  final bool success;

  SaveAchievementsOutput({
    required this.success,
  });
}

class SaveAchievementsUseCase implements BaseUseCase<SaveAchievementsInput, SaveAchievementsOutput> {
  @override
  Future<SaveAchievementsOutput> execute(SaveAchievementsInput input) async {
    try {
      await PreferencesManager.addNewAchievement(input.achievementName);
      return SaveAchievementsOutput(success: true);
    } catch (e) {
      return SaveAchievementsOutput(success: false);
    }
  }
} 