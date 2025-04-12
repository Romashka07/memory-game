import 'card_item.dart';

class GameState {
  final List<CardItem> cards;
  final int timeLeft;
  final int score;
  final int level;
  final int? firstCardIndex;
  final int? secondCardIndex;
  final bool isProcessing;

  GameState({
    required this.cards,
    required this.timeLeft,
    required this.score,
    required this.level,
    this.firstCardIndex,
    this.secondCardIndex,
    this.isProcessing = false,
  });
} 