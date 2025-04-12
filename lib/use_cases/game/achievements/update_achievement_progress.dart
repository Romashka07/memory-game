import '../../../utils/preferences_manager.dart';
import '../../base_use_case.dart';

class UpdateAchievementProgressInput {
  final int level;
  final bool isCompleted;

  UpdateAchievementProgressInput({
    required this.level,
    required this.isCompleted,
  });
}

class UpdateAchievementProgressOutput {
  final bool success;

  UpdateAchievementProgressOutput({
    required this.success,
  });
}

class UpdateAchievementProgressUseCase implements BaseUseCase<UpdateAchievementProgressInput, UpdateAchievementProgressOutput> {
  @override
  Future<UpdateAchievementProgressOutput> execute(UpdateAchievementProgressInput input) async {
    try {
      if (input.isCompleted) {
        await PreferencesManager.markLevelAsCompleted(input.level);
      }
      return UpdateAchievementProgressOutput(success: true);
    } catch (e) {
      return UpdateAchievementProgressOutput(success: false);
    }
  }
} 