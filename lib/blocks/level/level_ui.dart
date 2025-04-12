import 'package:flutter/material.dart';
import '../../utils/sound_manager.dart';
import '../../widgets/level_confirmation_dialog.dart';
import '../../screens/game_screen.dart';
import '../../screens/loading_screen.dart';

class LevelUI {
  static Widget buildDifficultyButton({
    required String difficulty,
    required Color color,
    required double width,
    required bool isSelected,
    required AnimationController controller,
    required Function() onTap,
    required SoundManager soundManager,
  }) {
    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) async {
        controller.reverse();
        await soundManager.playClickSound();
        onTap();
      },
      onTapCancel: () => controller.reverse(),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (controller.value * 0.15),
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/${difficulty}_text.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget buildLevelButton({
    required BuildContext context,
    required int level,
    required bool isCompleted,
    required AnimationController controller,
    required Animation<double> darkeningAnimation,
    required SoundManager soundManager,
  }) {
    Color buttonColor;
    if (level <= 3) {
      buttonColor = Colors.green;
    } else if (level <= 6) {
      buttonColor = Colors.orange;
    } else {
      buttonColor = Colors.red;
    }

    final double opacity = isCompleted ? 0.5 : 0.7;

    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) async {
        controller.reverse();
        await soundManager.playClickSound();
        bool? result = await showDialog<bool>(
          context: context,
          builder: (context) => LevelConfirmationDialog(
            level: level,
            onStart: () {
              Navigator.pop(context, true);
            },
            onBack: () => Navigator.pop(context, false),
          ),
        );

        if (result == true && context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoadingScreen(
                nextScreen: GameScreen(level: level),
              ),
            ),
          );
        }
      },
      onTapCancel: () => controller.reverse(),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (controller.value * 0.15),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(opacity),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          _getNumberImage(level),
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(darkeningAnimation.value),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget buildNavigationButton({
    required IconData icon,
    required bool canNavigate,
    required Function() onTap,
    required SoundManager soundManager,
  }) {
    return GestureDetector(
      onTap: canNavigate ? () async {
        await soundManager.playClickSound();
        onTap();
      } : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: canNavigate ? Colors.cyan.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Icon(
          icon,
          color: canNavigate ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  static Widget buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: isActive ? Colors.cyan : Colors.cyan.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  static String _getNumberImage(int number) {
    final numbers = [
      'one', 'two', 'three', 'four', 'five',
      'six', 'seven', 'eight', 'nine'
    ];
    return 'assets/images/number_${numbers[number - 1]}.png';
  }
} 