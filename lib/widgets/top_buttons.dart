import 'package:flutter/material.dart';

// Віджет рядка верхніх кнопок
class TopButtonsRow extends StatefulWidget {
  const TopButtonsRow({super.key});

  @override
  _TopButtonsRowState createState() => _TopButtonsRowState();
}

// Стан рядка верхніх кнопок
class _TopButtonsRowState extends State<TopButtonsRow> {
  // Стан звуку (увімкнено/вимкнено)
  bool _isSoundOn = true;

  // Перемикання стану звуку
  void _toggleSound() {
    setState(() {
      _isSoundOn = !_isSoundOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Отримання розмірів екрану для адаптивного дизайну
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.12; // 12% від ширини екрану
    
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        // Відступи для контейнера
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, 
          vertical: screenWidth * 0.02
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Кнопка керування звуком
            Container(
              // Стилізація контейнера кнопки
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                // Зміна іконки в залежності від стану звуку
                icon: _isSoundOn
                    ? Icon(Icons.volume_up, color: Colors.black, size: iconSize)
                    : Icon(Icons.volume_off, color: Colors.black, size: iconSize),
                onPressed: _toggleSound,
              ),
            ),

            // Кнопка переходу до профілю
            Container(
              // Стилізація контейнера кнопки
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.person, color: Colors.black, size: iconSize),
                onPressed: () {
                  // Логіка переходу до профілю
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}