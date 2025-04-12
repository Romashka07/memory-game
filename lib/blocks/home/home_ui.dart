import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';
import '../../widgets/custom_image_button.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../utils/sound_manager.dart';
import '../../screens/level_select_screen.dart';
import '../../screens/loading_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/achievements_screen.dart';
import '../../screens/home_screen.dart';

class HomeUI {
  static Widget buildTopBar(BuildContext context, double screenWidth, double iconSize, SoundManager soundManager) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: 7,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.person, color: Colors.black, size: iconSize),
                onPressed: () async {
                  await soundManager.playClickSound();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                        nextScreen: ProfileScreen(
                          previousScreen: const HomeScreen(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          Image.asset("assets/images/welcome_text.png"),
          const SizedBox(height: 5),
          Image.asset("assets/images/welcome_text_2.png"),
        ],
      ),
    );
  }

  static Widget buildMainContent(BuildContext context, SoundManager soundManager) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildWelcomeText(),
        // Кнопка початку гри
        CustomImageButton(
          imagePath: "assets/images/start_button.png",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoadingScreen(
                  nextScreen: const LevelSelectScreen(),
                ),
              ),
            );
          }
        ),
        // Кнопка налаштувань
        CustomImageButton(
          imagePath: "assets/images/settings_button.png",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoadingScreen(
                  nextScreen: SettingsScreen(
                    previousScreen: const HomeScreen(),
                  ),
                ),
              ),
            );
          }
        ),
        // Кнопка досягнень
        CustomImageButton(
          imagePath: "assets/images/achievements_button.png",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoadingScreen(
                  nextScreen: const AchievementsScreen(),
                ),
              ),
            );
          }
        ),
        // Кнопка виходу з гри
        CustomImageButton(
          imagePath: "assets/images/exit_button.png", 
          onPressed: () async {
            await soundManager.playClickSound();
            if (context.mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => ConfirmationDialog(
                  imagePath: 'assets/images/quit_the_game_text.png',
                  onConfirm: () {
                    SystemNavigator.pop();
                  },
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
          }
        ),
      ],
    );
  }
} 