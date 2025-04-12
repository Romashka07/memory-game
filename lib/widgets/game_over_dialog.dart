import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/loading_screen.dart';
import '../screens/game_screen.dart';
import '../screens/home_screen.dart';
import '../widgets/custom_image_button.dart';

// Діалогове вікно, що відображається при програші в грі
class GameOverDialog extends StatelessWidget {
  // Поточний рівень гри
  final int currentLevel;

  const GameOverDialog({
    super.key,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        // Стилізація контейнера діалогового вікна
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.4), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Контейнер з сумним смайликом
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/sad_smile.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Зображення тексту "Game Over"
            Image.asset(
              'assets/images/game_over_text.png',
              height: 60,
            ),
            const SizedBox(height: 30),
            // Кнопка "Спробувати знову"
            CustomImageButton(
              imagePath: 'assets/images/try_again_text.png',
              onPressed: () {
                // Перехід до екрану гри з тим самим рівнем
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingScreen(
                      nextScreen: GameScreen(
                        level: currentLevel,
                      ),
                    ),
                  ),
                );
              },
              backgroundColor: const Color(0xFF6FA1FF),
              borderColor: Colors.white,
              borderWidth: 2.0,
            ),
            const SizedBox(height: 15),
            // Кнопка "Головне меню"
            CustomImageButton(
              imagePath: 'assets/images/home_button.png',
              onPressed: () {
                // Повернення до головного меню
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingScreen(
                      nextScreen: const HomeScreen(),
                    ),
                  ),
                  (route) => false,
                );
              },
              backgroundColor: const Color(0xFF6FA1FF),
              borderColor: Colors.white,
              borderWidth: 2.0,
            ),
          ],
        ),
      ),
    );
  }
} 