import '../../models/card_item.dart';
import '../../models/saved_game_state.dart';
import '../base_use_case.dart';

class SaveGameStateInput {
  final List<CardItem> cards;
  final int timeLeft;
  final int score;
  final int level;
  final CardItem? firstCard;
  final CardItem? secondCard;
  final bool isProcessing;

  SaveGameStateInput({
    required this.cards,
    required this.timeLeft,
    required this.score,
    required this.level,
    required this.firstCard,
    required this.secondCard,
    required this.isProcessing,
  });
}

class SaveGameStateOutput {
  final SavedGameState savedState;

  SaveGameStateOutput({
    required this.savedState,
  });
}

class SaveGameStateUseCase implements BaseUseCase<SaveGameStateInput, SaveGameStateOutput> {
  @override
  Future<SaveGameStateOutput> execute(SaveGameStateInput input) async {
    int? firstCardIndex;
    int? secondCardIndex;
    
    if (input.firstCard != null) {
      firstCardIndex = input.cards.indexOf(input.firstCard!);
    }
    if (input.secondCard != null) {
      secondCardIndex = input.cards.indexOf(input.secondCard!);
    }

    final savedState = SavedGameState(
      cards: input.cards,
      timeLeft: input.timeLeft,
      score: input.score,
      level: input.level,
      firstCardIndex: firstCardIndex,
      secondCardIndex: secondCardIndex,
      isProcessing: input.isProcessing,
    );

    return SaveGameStateOutput(savedState: savedState);
  }
} 