import 'package:flutter/material.dart';
import '../models/level_config.dart';
import '../widgets/custom_image_button.dart';

// Діалогове вікно підтвердження вибору рівня
class LevelConfirmationDialog extends StatelessWidget {
  // Номер вибраного рівня
  final int level;
  // Функція, яка викликається при початку гри
  final VoidCallback onStart;
  // Функція, яка викликається при поверненні назад
  final VoidCallback onBack;

  const LevelConfirmationDialog({
    super.key,
    required this.level,
    required this.onStart,
    required this.onBack,
  });

  // Визначення кольору рівня в залежності від складності
  Color _getLevelColor() {
    if (level <= 3) {
      return Colors.green; // Легкий рівень
    } else if (level <= 6) {
      return Colors.orange; // Середній рівень
    } else {
      return Colors.red; // Складний рівень
    }
  }

  // Форматування часу з секунд у формат MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Розрахунок винагороди за рівень
  int _getDiamondsReward(int level) {
    return level * 5; // Кожен рівень дає на 5 кристалів більше ніж попередній
  }

  @override
  Widget build(BuildContext context) {
    // Отримання конфігурації рівня та розрахунок винагороди
    final levelConfig = LevelConfig.getConfig(level);
    final diamondsReward = _getDiamondsReward(level);
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        // Стилізація контейнера діалогового вікна
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Зображення тексту "Level"
            Image.asset(
              'assets/images/level_text.png',
              height: 75,
            ),
            const SizedBox(height: 16),
            // Контейнер з номером рівня
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getLevelColor(),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/number_${_getLevelNumberText()}.png',
                  height: 65,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Відображення часу на проходження рівня
            Text(
              'You Have: ${_formatTime(levelConfig.timeInSeconds)}',
              style: const TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
                fontFamily: 'IrishGrover',
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Відображення винагороди за рівень
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Reward: +',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                          fontFamily: 'IrishGrover',
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: '$diamondsReward',
                        style: const TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                          fontFamily: 'IrishGrover',
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.diamond, color: Colors.orange, size: 28),
              ],
            ),
            const SizedBox(height: 24),
            // Кнопки керування
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Кнопка "Почати гру"
                SizedBox(
                  width: screenWidth * 0.32,
                  child: CustomImageButton(
                    imagePath: 'assets/images/start_button.png',
                    onPressed: onStart,
                    backgroundColor: Colors.green.shade400,
                    borderColor: Colors.green.shade700,
                    borderWidth: 4.0,
                  ),
                ),
                // Кнопка "Назад"
                SizedBox(
                  width: screenWidth * 0.32,
                  child: CustomImageButton(
                    imagePath: 'assets/images/back_button.png',
                    onPressed: onBack,
                    backgroundColor: Colors.red.shade400,
                    borderColor: Colors.red.shade700,
                    borderWidth: 4.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Отримання текстового представлення номера рівня
  String _getLevelNumberText() {
    switch (level) {
      case 1:
        return 'one';
      case 2:
        return 'two';
      case 3:
        return 'three';
      case 4:
        return 'four';
      case 5:
        return 'five';
      case 6:
        return 'six';
      case 7:
        return 'seven';
      case 8:
        return 'eight';
      case 9:
        return 'nine';
      default:
        return 'one';
    }
  }
} 