import 'package:flutter/material.dart';
import '../../base_use_case.dart';
import '../../../widgets/game_over_dialog.dart';
import '../../../widgets/level_complete_dialog.dart';
import '../../../widgets/game_menu_dialog.dart';
import '../../../screens/game_screen.dart';

class HandleButtonPressInput {
  final BuildContext context;
  final int level;
  final String buttonType;

  HandleButtonPressInput({
    required this.context,
    required this.level,
    required this.buttonType,
  });
}

class HandleButtonPressOutput {
  final bool success;
  final String? error;

  HandleButtonPressOutput({
    required this.success,
    this.error,
  });
}

class HandleButtonPressUseCase implements BaseUseCase<HandleButtonPressInput, HandleButtonPressOutput> {
  @override
  Future<HandleButtonPressOutput> execute(HandleButtonPressInput input) async {
    try {
      switch (input.buttonType) {
        case 'menu':
          await _showGameMenu(input.context, input.level);
          break;
        case 'level_complete':
          await _showLevelCompleteDialog(input.context, input.level);
          break;
        case 'game_over':
          await _showGameOverDialog(input.context, input.level);
          break;
        default:
          return HandleButtonPressOutput(
            success: false,
            error: 'Unknown button type: ${input.buttonType}',
          );
      }
      return HandleButtonPressOutput(success: true);
    } catch (e) {
      return HandleButtonPressOutput(
        success: false,
        error: 'Error handling button press: $e',
      );
    }
  }

  Future<void> _showGameMenu(BuildContext context, int level) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameMenuDialog(gameScreen: GameScreen(level: level)),
    );
  }

  Future<void> _showLevelCompleteDialog(BuildContext context, int level) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LevelCompleteDialog(currentLevel: level),
    );
  }

  Future<void> _showGameOverDialog(BuildContext context, int level) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(currentLevel: level),
    );
  }
} 