import 'package:flutter/material.dart';
import '../../models/card_item.dart';
import '../../models/saved_game_state.dart';
import '../../utils/sound_manager.dart';
import '../../use_cases/game/cards/handle_card_tap.dart';
import '../../use_cases/game/cards/show_all_cards.dart';
import '../../use_cases/game/cards/find_pair.dart';

class GameCards {
  final List<CardItem> cards;
  final Function(List<CardItem>) onCardsUpdate;
  final Function(int) onScoreUpdate;
  final Function(bool) onMistakeUpdate;
  final Function() onLevelComplete;
  final SoundManager soundManager;

  CardItem? _firstCard;
  CardItem? _secondCard;
  bool _isProcessing = false;

  // Use cases
  final HandleCardTapUseCase _handleCardTapUseCase;
  final ShowAllCardsUseCase _showAllCardsUseCase;
  final FindPairUseCase _findPairUseCase;

  GameCards({
    required this.cards,
    required this.onCardsUpdate,
    required this.onScoreUpdate,
    required this.onMistakeUpdate,
    required this.onLevelComplete,
    required this.soundManager,
  }) : _handleCardTapUseCase = HandleCardTapUseCase(),
       _showAllCardsUseCase = ShowAllCardsUseCase(),
       _findPairUseCase = FindPairUseCase();

  // Обробка натискання на картку
  Future<void> handleCardTap(int index) async {
    final result = await _handleCardTapUseCase.execute(HandleCardTapInput(
      cards: cards,
      index: index,
      firstCard: _firstCard,
      secondCard: _secondCard,
      isProcessing: _isProcessing,
      onCardsUpdate: onCardsUpdate,
      onScoreUpdate: onScoreUpdate,
      onMistakeUpdate: onMistakeUpdate,
      onLevelComplete: onLevelComplete,
      soundManager: soundManager,
    ));

    _firstCard = result.newFirstCard;
    _secondCard = result.newSecondCard;
    _isProcessing = result.newIsProcessing;
  }

  // Показ всіх карток
  Future<void> showAllCards() async {
    final result = await _showAllCardsUseCase.execute(ShowAllCardsInput(
      cards: cards,
      onCardsUpdate: onCardsUpdate,
    ));
  }

  // Знаходження пари карток
  Future<void> findPair() async {
    final result = await _findPairUseCase.execute(FindPairInput(
      cards: cards,
      onCardsUpdate: onCardsUpdate,
      onScoreUpdate: onScoreUpdate,
      onLevelComplete: onLevelComplete,
    ));
  }

  // Відновлення стану карток
  void restoreState(SavedGameState savedState) {
    if (savedState.firstCardIndex != null) {
      _firstCard = cards[savedState.firstCardIndex!];
    }
    if (savedState.secondCardIndex != null) {
      _secondCard = cards[savedState.secondCardIndex!];
    }
    _isProcessing = savedState.isProcessing;
    onCardsUpdate(cards);
  }

  // Отримання поточної пари карток
  List<CardItem?> get currentPair => [_firstCard, _secondCard];

  // Перевірка чи обробляється хід
  bool get isProcessing => _isProcessing;
} 