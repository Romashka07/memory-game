import '../../../utils/sound_manager.dart';
import '../../../utils/preferences_manager.dart';
import '../../base_use_case.dart';

class UseShowAllHintInput {
  final int diamonds;
  final bool isShowingAllCards;
  final Function() onShowAllHint;
  final Function(int) onDiamondsUpdate;
  final Function(bool) onHintUsedUpdate;
  final SoundManager soundManager;

  UseShowAllHintInput({
    required this.diamonds,
    required this.isShowingAllCards,
    required this.onShowAllHint,
    required this.onDiamondsUpdate,
    required this.onHintUsedUpdate,
    required this.soundManager,
  });
}

class UseShowAllHintOutput {
  final int remainingDiamonds;
  final bool hintUsed;

  UseShowAllHintOutput({
    required this.remainingDiamonds,
    required this.hintUsed,
  });
}

class UseShowAllHintUseCase implements BaseUseCase<UseShowAllHintInput, UseShowAllHintOutput> {
  @override
  Future<UseShowAllHintOutput> execute(UseShowAllHintInput input) async {
    if (!input.isShowingAllCards && input.diamonds >= 20) {
      final newDiamonds = input.diamonds - 20;
      await PreferencesManager.setDiamonds(newDiamonds);
      await PreferencesManager.incrementHintsUsed();
      input.onShowAllHint();
      input.onDiamondsUpdate(newDiamonds);
      input.onHintUsedUpdate(true);
      await input.soundManager.playClickSound();

      return UseShowAllHintOutput(
        remainingDiamonds: newDiamonds,
        hintUsed: true,
      );
    }

    return UseShowAllHintOutput(
      remainingDiamonds: input.diamonds,
      hintUsed: false,
    );
  }
} 