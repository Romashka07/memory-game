import 'package:flutter/material.dart';
import '../utils/sound_manager.dart';

// Віджет кнопки з зображенням та анімацією
class CustomImageButton extends StatefulWidget {
  // Шлях до зображення кнопки
  final String imagePath;
  // Функція, яка викликається при натисканні
  final VoidCallback onPressed;
  // Колір фону кнопки
  final Color backgroundColor;
  // Колір рамки кнопки
  final Color borderColor;
  // Товщина рамки кнопки
  final double borderWidth;

  const CustomImageButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.backgroundColor = Colors.lightBlue,
    this.borderColor = Colors.blueAccent,
    this.borderWidth = 5.0,
  });

  @override
  _CustomImageButtonState createState() => _CustomImageButtonState();
}

// Стан кнопки з зображенням
class _CustomImageButtonState extends State<CustomImageButton>
    with SingleTickerProviderStateMixin {
  // Контролер анімації
  late AnimationController _animationController;
  // Анімація масштабування
  late Animation<double> _scaleAnimation;
  // Анімація затемнення
  late Animation<double> _darkeningAnimation;
  // Менеджер звуків
  final _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    // Ініціалізація контролера анімації
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Налаштування анімації масштабування
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Налаштування анімації затемнення
    _darkeningAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0.3),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutQuad),
      ),
    );
  }

  @override
  void dispose() {
    // Звільнення ресурсів анімації
    _animationController.dispose();
    super.dispose();
  }

  // Обробка натискання на кнопку
  Future<void> _handleTapDown(TapDownDetails details) async {
    _animationController.forward();
  }

  // Обробка відпускання кнопки
  Future<void> _handleTapUp(TapUpDetails details) async {
    _animationController.reverse();
    await _soundManager.playClickSound();
    widget.onPressed();
  }

  // Обробка скасування натискання
  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Розрахунок розмірів кнопки
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.7; // 70% від ширини екрану
    final buttonHeight = buttonWidth * 0.3; // Зберігаємо пропорції

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              // Стилізація кнопки
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(
                    color: widget.borderColor,
                    width: widget.borderWidth
                ),
                borderRadius: BorderRadius.circular(buttonHeight * 0.7),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Зображення кнопки
                    Image.asset(
                      widget.imagePath,
                      fit: BoxFit.contain,
                    ),
                    // Ефект затемнення при натисканні
                    AnimatedBuilder(
                      animation: _darkeningAnimation,
                      builder: (context, child) {
                        return Container(
                          color: Colors.black.withOpacity(
                              _darkeningAnimation.value
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}