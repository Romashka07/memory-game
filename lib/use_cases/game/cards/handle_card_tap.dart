import '../../../models/card_item.dart';
import '../../../utils/sound_manager.dart';
import '../../base_use_case.dart';

class HandleCardTapInput {
  final List<CardItem> cards;
  final int index;
  final CardItem? firstCard;
  final CardItem? secondCard;
  final bool isProcessing;
  final Function(List<CardItem>) onCardsUpdate;
  final Function(int) onScoreUpdate;
  final Function(bool) onMistakeUpdate;
  final Function() onLevelComplete;
  final SoundManager soundManager;

  HandleCardTapInput({
    required this.cards,
    required this.index,
    required this.firstCard,
    required this.secondCard,
    required this.isProcessing,
    required this.onCardsUpdate,
    required this.onScoreUpdate,
    required this.onMistakeUpdate,
    required this.onLevelComplete,
    required this.soundManager,
  });
}

class HandleCardTapOutput {
  final List<CardItem> updatedCards;
  final CardItem? newFirstCard;
  final CardItem? newSecondCard;
  final bool newIsProcessing;
  final bool isLevelComplete;

  HandleCardTapOutput({
    required this.updatedCards,
    required this.newFirstCard,
    required this.newSecondCard,
    required this.newIsProcessing,
    required this.isLevelComplete,
  });
}

class HandleCardTapUseCase implements BaseUseCase<HandleCardTapInput, HandleCardTapOutput> {
  @override
  Future<HandleCardTapOutput> execute(HandleCardTapInput input) async {
    final card = input.cards[input.index];
    List<CardItem> updatedCards = List.from(input.cards);
    CardItem? newFirstCard = input.firstCard;
    CardItem? newSecondCard = input.secondCard;
    bool newIsProcessing = input.isProcessing;
    bool isLevelComplete = false;

    if (input.isProcessing || card.isFlipped || card.isMatched) {
      return HandleCardTapOutput(
        updatedCards: updatedCards,
        newFirstCard: newFirstCard,
        newSecondCard: newSecondCard,
        newIsProcessing: newIsProcessing,
        isLevelComplete: isLevelComplete,
      );
    }

    await input.soundManager.playClickSound();

    // Перевертаємо картку
    card.isFlipped = true;
    input.onCardsUpdate(updatedCards);

    if (input.firstCard == null) {
      newFirstCard = card;
    } else {
      newSecondCard = card;
      newIsProcessing = true;
      input.onCardsUpdate(updatedCards);

      // Перевіряємо, чи картки співпадають
      if (input.firstCard!.imageAsset == card.imageAsset) {
        // Картки співпадають
        input.firstCard!.isMatched = true;
        card.isMatched = true;
        input.onScoreUpdate(10);
      } else {
        // Картки не співпадають
        input.onMistakeUpdate(true);
        await Future.delayed(const Duration(milliseconds: 500));
        input.firstCard!.isFlipped = false;
        card.isFlipped = false;
      }

      newFirstCard = null;
      newSecondCard = null;
      newIsProcessing = false;
      input.onCardsUpdate(updatedCards);

      // Перевіряємо, чи всі картки відкриті
      if (updatedCards.every((card) => card.isMatched)) {
        isLevelComplete = true;
        input.onLevelComplete();
      }
    }

    return HandleCardTapOutput(
      updatedCards: updatedCards,
      newFirstCard: newFirstCard,
      newSecondCard: newSecondCard,
      newIsProcessing: newIsProcessing,
      isLevelComplete: isLevelComplete,
    );
  }
} 