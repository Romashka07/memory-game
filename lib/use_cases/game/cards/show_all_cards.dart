import '../../../models/card_item.dart';
import '../../base_use_case.dart';

class ShowAllCardsInput {
  final List<CardItem> cards;
  final Function(List<CardItem>) onCardsUpdate;

  ShowAllCardsInput({
    required this.cards,
    required this.onCardsUpdate,
  });
}

class ShowAllCardsOutput {
  final List<CardItem> updatedCards;

  ShowAllCardsOutput({
    required this.updatedCards,
  });
}

class ShowAllCardsUseCase implements BaseUseCase<ShowAllCardsInput, ShowAllCardsOutput> {
  @override
  Future<ShowAllCardsOutput> execute(ShowAllCardsInput input) async {
    List<CardItem> updatedCards = List.from(input.cards);
    
    // Показуємо всі картки
    for (var card in updatedCards) {
      if (!card.isMatched) {
        card.isFlipped = true;
      }
    }
    input.onCardsUpdate(updatedCards);

    // Закриваємо картки через 1 секунду
    await Future.delayed(const Duration(seconds: 1));
    for (var card in updatedCards) {
      if (!card.isMatched) {
        card.isFlipped = false;
      }
    }
    input.onCardsUpdate(updatedCards);

    return ShowAllCardsOutput(updatedCards: updatedCards);
  }
} 