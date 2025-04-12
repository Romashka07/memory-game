import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/level_select_screen.dart';
import '../widgets/custom_image_button.dart';

// Діалогове вікно ігрового меню
class GameMenuDialog extends StatelessWidget {
  // Посилання на екран гри для повернення
  final Widget gameScreen;

  const GameMenuDialog({
    super.key,
    required this.gameScreen,
  });

  @override
  Widget build(BuildContext context) {
    // Отримання ширини екрану для адаптивного розміру
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            // Зображення тексту "MENU"
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Image.asset(
                'assets/images/menu_text.png',
                height: 75,
              ),
            ),
            // Кнопка "Продовжити гру"
            _buildMenuButton(
              'assets/images/resume_button.png',
              () => Navigator.of(context).pop(),
              screenWidth,
            ),
            const SizedBox(height: 16),
            // Кнопка "Налаштування"
            _buildMenuButton(
              'assets/images/settings_button.png',
              () {
                Navigator.of(context).pop(); // Закриття меню
                // Перехід до екрану налаштувань
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingScreen(
                      nextScreen: SettingsScreen(
                        previousScreen: gameScreen,
                      ),
                    ),
                  ),
                );
              },
              screenWidth,
            ),
            const SizedBox(height: 16),
            // Кнопка "Вихід"
            _buildMenuButton(
              'assets/images/exit_button.png',
              () {
                Navigator.of(context).pop(); // Закриття меню
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
              screenWidth,
            ),
          ],
        ),
      ),
    );
  }

  // Створення кнопки меню з заданими параметрами
  Widget _buildMenuButton(String imagePath, VoidCallback onPressed, double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.7,
      child: CustomImageButton(
        imagePath: imagePath,
        onPressed: onPressed,
        backgroundColor: Colors.blue.shade200,
        borderColor: Colors.blue.shade400,
        borderWidth: 3.0,
      ),
    );
  }
} 