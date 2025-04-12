import '../../../utils/sound_manager.dart';
import '../../../utils/preferences_manager.dart';
import '../../base_use_case.dart';

class UsePairHintInput {
  final int diamonds;
  final Function() onPairHint;
  final Function(int) onDiamondsUpdate;
  final Function(bool) onHintUsedUpdate;
  final SoundManager soundManager;

  UsePairHintInput({
    required this.diamonds,
    required this.onPairHint,
    required this.onDiamondsUpdate,
    required this.onHintUsedUpdate,
    required this.soundManager,
  });
}

class UsePairHintOutput {
  final int remainingDiamonds;
  final bool hintUsed;

  UsePairHintOutput({
    required this.remainingDiamonds,
    required this.hintUsed,
  });
}

class UsePairHintUseCase implements BaseUseCase<UsePairHintInput, UsePairHintOutput> {
  @override
  Future<UsePairHintOutput> execute(UsePairHintInput input) async {
    if (input.diamonds >= 5) {
      final newDiamonds = input.diamonds - 5;
      await PreferencesManager.setDiamonds(newDiamonds);
      await PreferencesManager.incrementHintsUsed();
      input.onPairHint();
      input.onDiamondsUpdate(newDiamonds);
      input.onHintUsedUpdate(true);
      await input.soundManager.playClickSound();

      return UsePairHintOutput(
        remainingDiamonds: newDiamonds,
        hintUsed: true,
      );
    }

    return UsePairHintOutput(
      remainingDiamonds: input.diamonds,
      hintUsed: false,
    );
  }
} 