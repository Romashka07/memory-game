import 'package:flutter/material.dart';
import '../../models/card_item.dart';
import '../../models/saved_game_state.dart';
import '../../models/level_config.dart';
import '../../use_cases/game/state/initialize_game.dart';
import '../../use_cases/game/state/update_diamonds.dart';
import '../../use_cases/game/state/update_score.dart';
import '../../utils/preferences_manager.dart';

class GameState {
  // Основний список карток
  List<CardItem> cards = [];
  // Змінні для відстеження відкритих карток
  CardItem? firstCard;
  CardItem? secondCard;
  // Прапорець, що вказує на обробку ходу
  bool isProcessing = false;
  // Прапорець для показу всіх карток
  bool isShowingAllCards = false;
  // Прапорець замороження таймера
  bool isTimerFrozen = false;
  // Рахунок гравця
  int score = 0;
  // Кількість алмазів
  int diamonds = 0;
  // Час, що залишився
  int timeLeft = 0;
  // Конфігурація поточного рівня
  late LevelConfig levelConfig;
  
  // Змінні для відстеження досягнень
  bool hasUsedHint = false;
  bool hasMadeMistake = false;
  
  // Змінні для відстеження використаних підказок
  bool hasUsedPairHint = false;
  bool hasUsedFreezeHint = false;
  bool hasUsedShowAllHint = false;
  
  // Змінні для таймера замороження
  int freezeTimeLeft = 10;

  final int level;
  final Function(int) onScoreUpdate;
  final Function(int) onDiamondsUpdate;
  final Function(bool) onTimerFrozenUpdate;
  final Function(bool) onShowingAllCardsUpdate;

  // Use cases
  final InitializeGameUseCase _initializeGameUseCase;
  final UpdateDiamondsUseCase _updateDiamondsUseCase;
  final UpdateScoreUseCase _updateScoreUseCase;

  // Список доступних іконок для карток
  static const List<String> _cardImages = [
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
  ];

  GameState({
    required this.level,
    required this.onScoreUpdate,
    required this.onDiamondsUpdate,
    required this.onTimerFrozenUpdate,
    required this.onShowingAllCardsUpdate,
  }) : levelConfig = LevelConfig.getConfig(level),
       timeLeft = LevelConfig.getConfig(level).timeInSeconds,
       _initializeGameUseCase = InitializeGameUseCase(),
       _updateDiamondsUseCase = UpdateDiamondsUseCase(),
       _updateScoreUseCase = UpdateScoreUseCase() {
    _initializeGame();
  }

  void _initializeGame() {
    // Перемішування та вибір іконок для карток
    final List<String> shuffledImages = List.from(_cardImages)..shuffle();
    final selectedImages = shuffledImages.take(levelConfig.numberOfPairs).toList();
    
    // Створення пар карток
    List<CardItem> newCards = [];
    for (int i = 0; i < levelConfig.numberOfPairs; i++) {
      final String currentImage = selectedImages[i];
      newCards.add(CardItem(id: i * 2, imageAsset: currentImage));
      newCards.add(CardItem(id: i * 2 + 1, imageAsset: currentImage));
    }
    
    // Перемішування карток
    newCards.shuffle();
    cards = newCards;
  }

  // Ініціалізація стану гри
  Future<void> initialize(SavedGameState? savedState) async {
    final input = InitializeGameInput(
      level: level,
      savedState: savedState,
      onCardsUpdate: (newCards) => cards = newCards,
      onTimeUpdate: (newTime) => timeLeft = newTime,
      onScoreUpdate: (newScore) => score = newScore,
    );

    final output = await _initializeGameUseCase.execute(input);
    
    cards = output.cards;
    timeLeft = output.timeLeft;
    score = output.score;
    isProcessing = output.isProcessing;
    firstCard = output.firstCard;
    secondCard = output.secondCard;

    await _loadDiamonds();
  }

  // Ініціалізація нової гри
  Future<void> _initializeNewGame() async {
    // Скидання змінних досягнень
    hasUsedHint = false;
    hasMadeMistake = false;
    print('Resetting game state for level $level: hasUsedHint = $hasUsedHint, hasMadeMistake = $hasMadeMistake');
    
    // Перемішування та вибір іконок для карток
    final List<String> shuffledImages = List.from(_cardImages)..shuffle();
    final selectedImages = shuffledImages.take(levelConfig.numberOfPairs).toList();
    
    // Створення пар карток
    List<CardItem> newCards = [];
    for (int i = 0; i < levelConfig.numberOfPairs; i++) {
      final String currentImage = selectedImages[i];
      newCards.add(CardItem(id: i * 2, imageAsset: currentImage));
      newCards.add(CardItem(id: i * 2 + 1, imageAsset: currentImage));
    }
    
    // Перемішування карток
    newCards.shuffle();
    cards = newCards;
  }

  // Завантаження кількості алмазів
  Future<void> _loadDiamonds() async {
    final currentDiamonds = await PreferencesManager.getDiamonds();
    final input = UpdateDiamondsInput(
      currentDiamonds: currentDiamonds,
      diamondsToAdd: 0,
      onDiamondsUpdate: (newDiamonds) => diamonds = newDiamonds,
    );

    final output = await _updateDiamondsUseCase.execute(input);
    diamonds = output.newDiamonds;
    onDiamondsUpdate(diamonds);
  }

  // Оновлення рахунку
  void updateScore(int newScore) {
    final input = UpdateScoreInput(
      currentScore: score,
      pointsToAdd: newScore - score,
      onScoreUpdate: (newScore) {
        score = newScore;
        onScoreUpdate(score);
      },
    );

    _updateScoreUseCase.execute(input);
  }

  // Оновлення кількості алмазів
  void updateDiamonds(int newDiamonds) {
    final input = UpdateDiamondsInput(
      currentDiamonds: diamonds,
      diamondsToAdd: newDiamonds - diamonds,
      onDiamondsUpdate: (newDiamonds) {
        diamonds = newDiamonds;
        onDiamondsUpdate(diamonds);
      },
    );

    _updateDiamondsUseCase.execute(input);
  }

  // Оновлення стану використання підказок
  void updateHasUsedHint(bool used) {
    print('Updating hasUsedHint from $hasUsedHint to $used');
    hasUsedHint = used;
  }

  // Оновлення стану використання підказки пари
  void updateHasUsedPairHint(bool used) {
    print('Updating hasUsedPairHint from $hasUsedPairHint to $used');
    hasUsedPairHint = used;
    if (used) updateHasUsedHint(true);
  }

  // Оновлення стану використання підказки заморозки
  void updateHasUsedFreezeHint(bool used) {
    print('Updating hasUsedFreezeHint from $hasUsedFreezeHint to $used');
    hasUsedFreezeHint = used;
    if (used) updateHasUsedHint(true);
  }

  // Оновлення стану використання підказки показу всіх
  void updateHasUsedShowAllHint(bool used) {
    print('Updating hasUsedShowAllHint from $hasUsedShowAllHint to $used');
    hasUsedShowAllHint = used;
    if (used) updateHasUsedHint(true);
  }

  // Оновлення стану помилок
  void updateHasMadeMistake(bool mistake) {
    print('Updating hasMadeMistake from $hasMadeMistake to $mistake (level: $level)');
    if (mistake) {
      print('Setting hasMadeMistake to true for level $level');
    }
    hasMadeMistake = mistake;
    print('Current state after update: hasMadeMistake = $hasMadeMistake, hasUsedHint = $hasUsedHint');
  }

  // Оновлення стану замороження таймера
  void updateTimerFrozen(bool frozen) {
    isTimerFrozen = frozen;
    onTimerFrozenUpdate(frozen);
  }

  // Оновлення стану показу всіх карток
  void updateShowingAllCards(bool showing) {
    isShowingAllCards = showing;
    onShowingAllCardsUpdate(showing);
  }

  // Відновлення стану з збереженого
  void restoreState(SavedGameState savedState) {
    cards = savedState.cards;
    timeLeft = savedState.timeLeft;
    score = savedState.score;
    isProcessing = savedState.isProcessing;
    
    if (savedState.firstCardIndex != null) {
      firstCard = cards[savedState.firstCardIndex!];
    }
    if (savedState.secondCardIndex != null) {
      secondCard = cards[savedState.secondCardIndex!];
    }

    // Завантаження актуальної кількості алмазів
    _loadDiamonds();
  }

  // Отримання поточного стану для збереження
  SavedGameState getCurrentState() {
    int? firstCardIndex;
    int? secondCardIndex;
    
    if (firstCard != null) {
      firstCardIndex = cards.indexOf(firstCard!);
    }
    if (secondCard != null) {
      secondCardIndex = cards.indexOf(secondCard!);
    }

    return SavedGameState(
      cards: cards,
      timeLeft: timeLeft,
      score: score,
      level: level,
      firstCardIndex: firstCardIndex,
      secondCardIndex: secondCardIndex,
      isProcessing: isProcessing,
    );
  }

  // Прапорець завершення гри
  bool gameOver = false;
} 