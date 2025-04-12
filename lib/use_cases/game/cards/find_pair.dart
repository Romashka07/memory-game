import '../../../models/card_item.dart';
import '../../base_use_case.dart';

class FindPairInput {
  final List<CardItem> cards;
  final Function(List<CardItem>) onCardsUpdate;
  final Function(int) onScoreUpdate;
  final Function() onLevelComplete;

  FindPairInput({
    required this.cards,
    required this.onCardsUpdate,
    required this.onScoreUpdate,
    required this.onLevelComplete,
  });
}

class FindPairOutput {
  final List<CardItem> updatedCards;
  final bool pairFound;
  final bool isLevelComplete;

  FindPairOutput({
    required this.updatedCards,
    required this.pairFound,
    required this.isLevelComplete,
  });
}

class FindPairUseCase implements BaseUseCase<FindPairInput, FindPairOutput> {
  @override
  Future<FindPairOutput> execute(FindPairInput input) async {
    List<CardItem> updatedCards = List.from(input.cards);
    bool pairFound = false;
    bool isLevelComplete = false;

    // Знаходимо першу незнайдену пару
    List<CardItem> unmatched = [];
    for (int i = 0; i < updatedCards.length; i++) {
      if (!updatedCards[i].isMatched && !updatedCards[i].isFlipped) {
        unmatched.add(updatedCards[i]);
      }
    }
    
    if (unmatched.length >= 2) {
      // Знаходимо дві картки з однаковим зображенням
      String? targetImage;
      for (int i = 0; i < unmatched.length - 1; i++) {
        for (int j = i + 1; j < unmatched.length; j++) {
          if (unmatched[i].imageAsset == unmatched[j].imageAsset) {
            targetImage = unmatched[i].imageAsset;
            break;
          }
        }
        if (targetImage != null) break;
      }

      if (targetImage != null) {
        pairFound = true;
        // Відкриваємо обидві картки з цим зображенням
        for (var card in updatedCards) {
          if (card.imageAsset == targetImage && !card.isMatched) {
            card.isFlipped = true;
            card.isMatched = true;
          }
        }
        input.onScoreUpdate(10);
        input.onCardsUpdate(updatedCards);
        
        // Перевіряємо чи всі пари знайдені
        if (updatedCards.every((card) => card.isMatched)) {
          isLevelComplete = true;
          input.onLevelComplete();
        }
      }
    }

    return FindPairOutput(
      updatedCards: updatedCards,
      pairFound: pairFound,
      isLevelComplete: isLevelComplete,
    );
  }
} 