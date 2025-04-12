import 'package:flutter/material.dart';
import '../../models/card_item.dart';
import '../../use_cases/game/ui/build_game_ui.dart';
import '../../use_cases/game/ui/handle_button_press.dart';
import '../../use_cases/game/ui/show_dialog.dart';
import '../../widgets/game_over_dialog.dart';
import '../../widgets/game_menu_dialog.dart';
import '../../widgets/level_complete_dialog.dart';
import '../../screens/game_screen.dart';

class GameUI {
  final BuildGameUIUseCase _buildGameUIUseCase;
  final HandleButtonPressUseCase _handleButtonPressUseCase;
  final ShowDialogUseCase _showDialogUseCase;
  final double screenWidth;
  final List<CardItem> cards;
  final Function(int) onCardTap;
  final Function() onMenuTap;
  final int diamonds;
  final int level;
  final String timeText;
  final bool isTimerFrozen;
  final String freezeTimeText;
  final Function() onPairHint;
  final Function() onFreezeHint;
  final Function() onShowAllHint;
  final bool canUsePairHint;
  final bool canUseFreezeHint;
  final bool canUseShowAllHint;

  GameUI({
    required this.screenWidth,
    required this.cards,
    required this.onCardTap,
    required this.onMenuTap,
    required this.diamonds,
    required this.level,
    required this.timeText,
    required this.isTimerFrozen,
    required this.freezeTimeText,
    required this.onPairHint,
    required this.onFreezeHint,
    required this.onShowAllHint,
    required this.canUsePairHint,
    required this.canUseFreezeHint,
    required this.canUseShowAllHint,
  }) : _buildGameUIUseCase = BuildGameUIUseCase(),
       _handleButtonPressUseCase = HandleButtonPressUseCase(),
       _showDialogUseCase = ShowDialogUseCase();

  Future<Widget> buildGameUI() async {
    final input = BuildGameUIInput(
      screenWidth: screenWidth,
      cards: cards,
      onCardTap: onCardTap,
      onMenuTap: onMenuTap,
      diamonds: diamonds,
      level: level,
      timeText: timeText,
      isTimerFrozen: isTimerFrozen,
      freezeTimeText: freezeTimeText,
      onPairHint: onPairHint,
      onFreezeHint: onFreezeHint,
      onShowAllHint: onShowAllHint,
      canUsePairHint: canUsePairHint,
      canUseFreezeHint: canUseFreezeHint,
      canUseShowAllHint: canUseShowAllHint,
    );

    final output = await _buildGameUIUseCase.execute(input);
    
    return Column(
      children: [
        output.topPanel,
        output.gameField,
        output.freezeIndicator,
        output.hintsPanel,
      ],
    );
  }

  Future<bool> handleButtonPress({
    required BuildContext context,
    required int level,
    required String buttonType,
  }) async {
    final input = HandleButtonPressInput(
      context: context,
      level: level,
      buttonType: buttonType,
    );

    final output = await _handleButtonPressUseCase.execute(input);
    return output.success;
  }

  Future<bool> showDialog({
    required BuildContext context,
    required Widget dialog,
    bool barrierDismissible = false,
  }) async {
    final input = ShowDialogInput(
      context: context,
      dialog: dialog,
      barrierDismissible: barrierDismissible,
    );

    final output = await _showDialogUseCase.execute(input);
    return output.success;
  }

  Future<bool> showGameOverDialog(BuildContext context) async {
    return showDialog(
      context: context,
      dialog: GameOverDialog(currentLevel: level),
      barrierDismissible: false,
    );
  }

  Future<bool> showGameMenu(BuildContext context) async {
    return showDialog(
      context: context,
      dialog: GameMenuDialog(gameScreen: GameScreen(level: level)),
      barrierDismissible: false,
    );
  }

  Future<bool> showLevelCompleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      dialog: LevelCompleteDialog(currentLevel: level),
      barrierDismissible: false,
    );
  }
} 