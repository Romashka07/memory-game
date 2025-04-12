import '../../../utils/sound_manager.dart';
import '../../../utils/preferences_manager.dart';
import '../../base_use_case.dart';

class UseFreezeHintInput {
  final int diamonds;
  final bool isTimerFrozen;
  final Function() onFreezeHint;
  final Function(int) onDiamondsUpdate;
  final Function(bool) onHintUsedUpdate;
  final SoundManager soundManager;

  UseFreezeHintInput({
    required this.diamonds,
    required this.isTimerFrozen,
    required this.onFreezeHint,
    required this.onDiamondsUpdate,
    required this.onHintUsedUpdate,
    required this.soundManager,
  });
}

class UseFreezeHintOutput {
  final int remainingDiamonds;
  final bool hintUsed;

  UseFreezeHintOutput({
    required this.remainingDiamonds,
    required this.hintUsed,
  });
}

class UseFreezeHintUseCase implements BaseUseCase<UseFreezeHintInput, UseFreezeHintOutput> {
  @override
  Future<UseFreezeHintOutput> execute(UseFreezeHintInput input) async {
    if (!input.isTimerFrozen && input.diamonds >= 10) {
      final newDiamonds = input.diamonds - 10;
      await PreferencesManager.setDiamonds(newDiamonds);
      await PreferencesManager.incrementHintsUsed();
      input.onFreezeHint();
      input.onDiamondsUpdate(newDiamonds);
      input.onHintUsedUpdate(true);
      await input.soundManager.playClickSound();

      return UseFreezeHintOutput(
        remainingDiamonds: newDiamonds,
        hintUsed: true,
      );
    }

    return UseFreezeHintOutput(
      remainingDiamonds: input.diamonds,
      hintUsed: false,
    );
  }
} 