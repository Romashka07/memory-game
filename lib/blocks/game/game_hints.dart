import 'package:flutter/material.dart';
import '../../utils/sound_manager.dart';
import '../../utils/preferences_manager.dart';
import '../../use_cases/game/hints/use_pair_hint.dart';
import '../../use_cases/game/hints/use_freeze_hint.dart';
import '../../use_cases/game/hints/use_show_all_hint.dart';

class GameHints {
  int diamonds;
  bool _isShowingAllCards = false;
  bool _isTimerFrozen = false;
  final Function(int) onDiamondsUpdate;
  final Function(bool) onHintUsedUpdate;
  final Function() onPairHint;
  final Function() onFreezeHint;
  final Function() onShowAllHint;
  final SoundManager soundManager;
  
  // Додаємо змінну для відстеження типу використаної підказки
  String? _lastUsedHintType;

  // Use cases
  final UsePairHintUseCase _usePairHintUseCase;
  final UseFreezeHintUseCase _useFreezeHintUseCase;
  final UseShowAllHintUseCase _useShowAllHintUseCase;

  GameHints({
    required this.diamonds,
    required this.onDiamondsUpdate,
    required this.onHintUsedUpdate,
    required this.onPairHint,
    required this.onFreezeHint,
    required this.onShowAllHint,
    required this.soundManager,
  }) : _usePairHintUseCase = UsePairHintUseCase(),
       _useFreezeHintUseCase = UseFreezeHintUseCase(),
       _useShowAllHintUseCase = UseShowAllHintUseCase() {
    onDiamondsUpdate(diamonds);
  }

  // Оновлення стану підказок
  void updateDiamonds(int newDiamonds) {
    diamonds = newDiamonds;
    onDiamondsUpdate(diamonds);
  }

  // Оновлення стану замороження таймера
  void setTimerFrozen(bool frozen) {
    _isTimerFrozen = frozen;
  }

  Future<void> usePairHint() async {
    _lastUsedHintType = 'pair';
    final result = await _usePairHintUseCase.execute(UsePairHintInput(
      diamonds: diamonds,
      onPairHint: onPairHint,
      onDiamondsUpdate: onDiamondsUpdate,
      onHintUsedUpdate: onHintUsedUpdate,
      soundManager: soundManager,
    ));
    
    diamonds = result.remainingDiamonds;
  }

  Future<void> useFreezeHint() async {
    if (!_isTimerFrozen) {
      _lastUsedHintType = 'freeze';
      final result = await _useFreezeHintUseCase.execute(UseFreezeHintInput(
        diamonds: diamonds,
        isTimerFrozen: _isTimerFrozen,
        onFreezeHint: onFreezeHint,
        onDiamondsUpdate: onDiamondsUpdate,
        onHintUsedUpdate: onHintUsedUpdate,
        soundManager: soundManager,
      ));
      
      diamonds = result.remainingDiamonds;
    }
  }

  Future<void> useShowAllHint() async {
    _lastUsedHintType = 'showAll';
    final result = await _useShowAllHintUseCase.execute(UseShowAllHintInput(
      diamonds: diamonds,
      isShowingAllCards: _isShowingAllCards,
      onShowAllHint: onShowAllHint,
      onDiamondsUpdate: onDiamondsUpdate,
      onHintUsedUpdate: onHintUsedUpdate,
      soundManager: soundManager,
    ));
    
    diamonds = result.remainingDiamonds;
  }

  bool canUseHint(int cost) {
    // Для підказки заморозки часу (cost = 10) перевіряємо стан заморозки
    if (cost == 10) {
      return diamonds >= cost && !_isShowingAllCards && !_isTimerFrozen;
    }
    // Для інших підказок перевіряємо тільки алмази та стан показу всіх карток
    return diamonds >= cost && !_isShowingAllCards;
  }

  // Додаємо метод для отримання типу останньої використаної підказки
  String? getLastUsedHintType() => _lastUsedHintType;
} 