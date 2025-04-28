import 'package:flutter/material.dart';
import '../constants.dart';

// Віджет сповіщення про нове досягнення
class AchievementNotification extends StatefulWidget {
  const AchievementNotification({super.key});

  @override
  State<AchievementNotification> createState() => _AchievementNotificationState();
}

// Стан сповіщення про досягнення
class _AchievementNotificationState extends State<AchievementNotification> with SingleTickerProviderStateMixin {
  // Контролер анімації
  late AnimationController _controller;
  // Анімація зсуву
  late Animation<Offset> _slideAnimation;
  // Анімація прозорості
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Ініціалізація контролера анімації
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Налаштування анімації зсуву зверху вниз
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    // Налаштування анімації появи (fade in)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          // Контейнер сповіщення
          child: Container(
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            // Стилізація контейнера сповіщення
            decoration: BoxDecoration(
              color: Colors.blue.shade300.withOpacity(0.95),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // Вміст сповіщення
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Іконка трофею
                const Icon(
                  Icons.emoji_events,
                  color: Colors.yellow,
                  size: 24,
                ),
                const SizedBox(width: 8),
                // Текст сповіщення
                const Flexible(
                  child: Text(
                    'New achievement unlocked!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IrishGrover',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 