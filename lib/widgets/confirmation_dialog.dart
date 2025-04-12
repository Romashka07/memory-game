// Імпорт необхідних бібліотек
import 'package:flutter/material.dart';
import '../widgets/custom_image_button.dart';

// Діалогове вікно підтвердження дії
class ConfirmationDialog extends StatelessWidget {
  // Шлях до зображення в діалоговому вікні
  final String imagePath;
  // Функція, яка викликається при підтвердженні
  final VoidCallback onConfirm;
  // Функція, яка викликається при скасуванні
  final VoidCallback onCancel;

  const ConfirmationDialog({
    super.key,
    required this.imagePath,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // Отримання ширини екрану для адаптивного розміру
    final screenWidth = MediaQuery.of(context).size.width;
    
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
            // Зображення в діалоговому вікні
            Image.asset(
              imagePath,
              width: screenWidth * 0.7,
            ),
            const SizedBox(height: 30),
            // Рядок з кнопками підтвердження та скасування
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Кнопка "Так"
                SizedBox(
                  width: screenWidth * 0.3,
                  child: CustomImageButton(
                    imagePath: 'assets/images/yes_text.png',
                    onPressed: onConfirm,
                    backgroundColor: Colors.green.shade400,
                    borderColor: Colors.green.shade700,
                    borderWidth: 4.0,
                  ),
                ),
                // Кнопка "Ні"
                SizedBox(
                  width: screenWidth * 0.3,
                  child: CustomImageButton(
                    imagePath: 'assets/images/no_text.png',
                    onPressed: onCancel,
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
} 