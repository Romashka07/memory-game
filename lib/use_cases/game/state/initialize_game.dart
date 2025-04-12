import '../../../../models/card_item.dart';
import '../../../../models/saved_game_state.dart';
import '../../../../models/level_config.dart';
import '../../../../use_cases/base_use_case.dart';

class InitializeGameInput {
  final int level;
  final SavedGameState? savedState;
  final Function(List<CardItem>) onCardsUpdate;
  final Function(int) onTimeUpdate;
  final Function(int) onScoreUpdate;

  InitializeGameInput({
    required this.level,
    required this.savedState,
    required this.onCardsUpdate,
    required this.onTimeUpdate,
    required this.onScoreUpdate,
  });
}

class InitializeGameOutput {
  final List<CardItem> cards;
  final int timeLeft;
  final int score;
  final bool isProcessing;
  final CardItem? firstCard;
  final CardItem? secondCard;

  InitializeGameOutput({
    required this.cards,
    required this.timeLeft,
    required this.score,
    required this.isProcessing,
    required this.firstCard,
    required this.secondCard,
  });
}

class InitializeGameUseCase implements BaseUseCase<InitializeGameInput, InitializeGameOutput> {
  @override
  Future<InitializeGameOutput> execute(InitializeGameInput input) async {
    if (input.savedState != null) {
      // Відновлення збереженого стану
      final cards = input.savedState!.cards;
      final timeLeft = input.savedState!.timeLeft;
      final score = input.savedState!.score;
      final isProcessing = input.savedState!.isProcessing;
      
      CardItem? firstCard;
      CardItem? secondCard;
      
      if (input.savedState!.firstCardIndex != null) {
        firstCard = cards[input.savedState!.firstCardIndex!];
      }
      if (input.savedState!.secondCardIndex != null) {
        secondCard = cards[input.savedState!.secondCardIndex!];
      }

      input.onCardsUpdate(cards);
      input.onTimeUpdate(timeLeft);
      input.onScoreUpdate(score);

      return InitializeGameOutput(
        cards: cards,
        timeLeft: timeLeft,
        score: score,
        isProcessing: isProcessing,
        firstCard: firstCard,
        secondCard: secondCard,
      );
    } else {
      // Ініціалізація нової гри
      final levelConfig = LevelConfig.getConfig(input.level);
      final timeLeft = levelConfig.timeInSeconds;
      
      // Створення та перемішування карток
      final List<String> cardImages = [
        'assets/images/game/heart_icon.png',
        'assets/images/game/star_icon.png',
        'assets/images/game/diamond_icon.png',
        'assets/images/game/circle_icon.png',
        'assets/images/game/square_icon.png',
        'assets/images/game/triangle_icon.png',
        'assets/images/game/crown_icon.png',
        'assets/images/game/flower_icon.png',
        'assets/images/game/leaf_icon.png',
        'assets/images/game/pineapple_icon.png',
        'assets/images/game/cloud_icon.png',
        'assets/images/game/snowflake_icon.png',
        'assets/images/game/cherries_icon.png',
        'assets/images/game/sun_icon.png',
      ]..shuffle();
      
      final selectedImages = cardImages.take(levelConfig.numberOfPairs).toList();
      List<CardItem> cards = [];
      
      for (int i = 0; i < levelConfig.numberOfPairs; i++) {
        final String currentImage = selectedImages[i];
        cards.add(CardItem(id: i * 2, imageAsset: currentImage));
        cards.add(CardItem(id: i * 2 + 1, imageAsset: currentImage));
      }
      
      cards.shuffle();
      
      input.onCardsUpdate(cards);
      input.onTimeUpdate(timeLeft);
      input.onScoreUpdate(0);

      return InitializeGameOutput(
        cards: cards,
        timeLeft: timeLeft,
        score: 0,
        isProcessing: false,
        firstCard: null,
        secondCard: null,
      );
    }
  }
} 