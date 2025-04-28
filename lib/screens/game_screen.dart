import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/card_item.dart';
import '../models/saved_game_state.dart';
import '../models/level_config.dart';
import '../widgets/game_menu_dialog.dart';
import '../widgets/level_complete_dialog.dart';
import '../widgets/achievement_notification.dart';
import '../utils/preferences_manager.dart';
import '../utils/sound_manager.dart';
import '../widgets/custom_image_button.dart';
import 'profile_screen.dart';
import 'loading_screen.dart';
import 'level_select_screen.dart';
import '../widgets/game_over_dialog.dart';
import '../blocks/game/game_state.dart';
import '../blocks/game/game_timer.dart';
import '../blocks/game/game_cards.dart';
import '../blocks/game/game_hints.dart';
import '../blocks/game/game_achievements.dart';
import '../blocks/game/game_ui.dart';

// Екран гри, де відбувається основний геймплей
class GameScreen extends StatefulWidget {
  final int level;
  final SavedGameState? savedState;

  const GameScreen({
    super.key,
    required this.level,
    this.savedState,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// Стан екрану гри
class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final GameState _gameState;
  late final GameTimer _gameTimer;
  late final GameCards _gameCards;
  late final GameHints _gameHints;
  late final GameAchievements _gameAchievements;
  late GameUI _gameUI;
  final _soundManager = SoundManager();

  late AnimationController _pairHintAnimationController;
  late AnimationController _freezeHintAnimationController;
  late AnimationController _showHintAnimationController;

  late Animation<double> _pairHintDarkeningAnimation;
  late Animation<double> _freezeHintDarkeningAnimation;
  late Animation<double> _showHintDarkeningAnimation;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _initializeAnimations();
  }

  void _initializeGame() async {
    _gameState = GameState(
      level: widget.level,
      onScoreUpdate: (score) => setState(() {}),
      onDiamondsUpdate: (diamonds) => setState(() {}),
      onTimerFrozenUpdate: (frozen) => setState(() {}),
      onShowingAllCardsUpdate: (showing) => setState(() {}),
    );

    await _gameState.initialize(widget.savedState);

    _gameTimer = GameTimer(
      initialTime: widget.savedState?.timeLeft ?? _gameState.timeLeft,
      onTimeUpdate: (time) => setState(() {}),
      onFreezeTimeUpdate: (time) => setState(() {}),
      onTimerFrozenUpdate: (frozen) {
        setState(() {});
        _gameHints.setTimerFrozen(frozen);
      },
      onTimeUp: _handleTimeUp,
    );

    _gameCards = GameCards(
      cards: _gameState.cards,
      onCardsUpdate: (cards) => setState(() {}),
      onScoreUpdate: (score) => _gameState.updateScore(score),
      onMistakeUpdate: (mistake) {
        setState(() {
          _gameState.updateHasMadeMistake(mistake);
        });
      },
      onLevelComplete: _handleLevelCompletion,
      soundManager: _soundManager,
    );

    _gameHints = GameHints(
      diamonds: _gameState.diamonds,
      onDiamondsUpdate: (diamonds) => _gameState.updateDiamonds(diamonds),
      onHintUsedUpdate: (used) {
        print('onHintUsedUpdate called with used: $used');
        if (used) {
          final hintType = _gameHints.getLastUsedHintType();
          print('Hint type used: $hintType');
          
          switch (hintType) {
            case 'pair':
              _gameState.updateHasUsedPairHint(true);
              break;
            case 'freeze':
              _gameState.updateHasUsedFreezeHint(true);
              break;
            case 'showAll':
              _gameState.updateHasUsedShowAllHint(true);
              break;
          }
          
          print('Updated hint states: pair=${_gameState.hasUsedPairHint}, freeze=${_gameState.hasUsedFreezeHint}, showAll=${_gameState.hasUsedShowAllHint}');
        }
      },
      onPairHint: _gameCards.findPair,
      onFreezeHint: _gameTimer.freezeTimer,
      onShowAllHint: _gameCards.showAllCards,
      soundManager: _soundManager,
    );

    _gameAchievements = GameAchievements(
      level: widget.level,
      hasMadeMistake: _gameState.hasMadeMistake,
      hasUsedHint: _gameState.hasUsedHint,
      hasUsedPairHint: _gameState.hasUsedPairHint,
      hasUsedFreezeHint: _gameState.hasUsedFreezeHint,
      hasUsedShowAllHint: _gameState.hasUsedShowAllHint,
      timeLeft: _gameTimer.currentTime,
      isTimerFrozen: _gameTimer.isFrozen,
      diamonds: _gameState.diamonds,
    );
    
    if (widget.savedState != null) {
      _gameState.restoreState(widget.savedState!);
      _gameCards.restoreState(widget.savedState!);
    }
  }

  void _initializeAnimations() {
    _pairHintAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _freezeHintAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _showHintAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _pairHintDarkeningAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.3),
        weight: 1.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _pairHintAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _freezeHintDarkeningAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.3),
        weight: 1.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _freezeHintAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _showHintDarkeningAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.3),
        weight: 1.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _showHintAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleTimeUp() {
    _gameState.gameOver = true;
    _gameUI.showGameOverDialog(context);
  }

  void _showGameMenu() {
    _gameTimer.pauseTimer();
    _gameUI.showGameMenu(context).then((_) {
      if (!_gameState.gameOver) {
        _gameTimer.resumeTimer();
      }
    });
  }

  void _handleLevelCompletion() async {
    _gameTimer.pauseTimer();
    final achievements = GameAchievements(
      level: widget.level,
      hasMadeMistake: _gameState.hasMadeMistake,
      hasUsedHint: _gameState.hasUsedHint,
      hasUsedPairHint: _gameState.hasUsedPairHint,
      hasUsedFreezeHint: _gameState.hasUsedFreezeHint,
      hasUsedShowAllHint: _gameState.hasUsedShowAllHint,
      timeLeft: _gameTimer.currentTime,
      isTimerFrozen: _gameTimer.isFrozen,
      diamonds: _gameState.diamonds,
    );
    await achievements.checkAchievements();
    await achievements.saveProgress();
    _gameUI.showLevelCompleteDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    _gameUI = GameUI(
      screenWidth: MediaQuery.of(context).size.width,
      cards: _gameState.cards,
      onCardTap: _gameCards.handleCardTap,
      onMenuTap: _showGameMenu,
      diamonds: _gameState.diamonds,
      level: widget.level,
      timeText: _gameTimer.formatTime(_gameTimer.currentTime),
      isTimerFrozen: _gameTimer.isFrozen,
      freezeTimeText: _gameTimer.formatTime(_gameTimer.freezeTime),
      onPairHint: _gameHints.usePairHint,
      onFreezeHint: _gameHints.useFreezeHint,
      onShowAllHint: _gameHints.useShowAllHint,
      canUsePairHint: _gameHints.canUseHint(5),
      canUseFreezeHint: _gameHints.canUseHint(10),
      canUseShowAllHint: _gameHints.canUseHint(20),
    );

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder<Widget>(
            future: _gameUI.buildGameUI(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer.dispose();
    _pairHintAnimationController.dispose();
    _freezeHintAnimationController.dispose();
    _showHintAnimationController.dispose();
    super.dispose();
  }
} 