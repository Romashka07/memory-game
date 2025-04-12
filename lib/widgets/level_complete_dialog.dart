import 'package:flutter/material.dart';
import '../screens/level_select_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/game_screen.dart';
import '../widgets/custom_image_button.dart';

// Діалогове вікно, що відображається при завершенні рівня
class LevelCompleteDialog extends StatelessWidget {
  // Поточний рівень гри
  final int currentLevel;

  const LevelCompleteDialog({
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
            // Контейнер з трофеєм
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
                  'assets/images/trophy.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Зображення тексту "Вітаємо"
            Image.asset(
              'assets/images/congratulation_text.png',
              height: 60,
            ),
            const SizedBox(height: 10),
            // Зображення тексту "Рівень завершено!"
            Image.asset(
              'assets/images/level_complete_text.png',
              height: 45,
            ),
            const SizedBox(height: 30),
            // Кнопка "Наступний рівень"
            CustomImageButton(
              imagePath: 'assets/images/next_level_button.png',
              onPressed: () async {
                if (!context.mounted) return;
                
                Navigator.of(context).pop(); // Закриття діалогового вікна
                if (currentLevel < 9) { // Перевірка чи це не останній рівень
                  // Перехід до наступного рівня
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                        nextScreen: GameScreen(level: currentLevel + 1),
                      ),
                    ),
                  );
                }
              },
              backgroundColor: const Color(0xFF6FA1FF),
              borderColor: Colors.white,
              borderWidth: 2.0,
            ),
            const SizedBox(height: 15),
            // Кнопка "Головне меню"
            CustomImageButton(
              imagePath: 'assets/images/home_button.png',
              onPressed: () async {
                if (!context.mounted) return;
                
                Navigator.of(context).pop(); // Закриття діалогового вікна
                // Повернення до екрану вибору рівнів
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoadingScreen(
                      nextScreen: LevelSelectScreen(),
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