import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';

// Екран завантаження, який відображається при переході між екранами
class LoadingScreen extends StatefulWidget {
  // Наступний екран, до якого буде виконано перехід після завантаження
  final Widget nextScreen;

  const LoadingScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

// Стан екрану завантаження
class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  // Поточний прогрес завантаження (0.0 - 1.0)
  double _progress = 0;
  // Таймер для оновлення прогресу
  Timer? _timer;
  // Контролер анімації
  late AnimationController _animationController;
  // Анімація прогресу
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Налаштування анімації прогресу
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Створення анімації прогресу від 0 до 1
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Оновлення прогресу при зміні анімації
    _animationController.addListener(() {
      setState(() {
        _progress = _progressAnimation.value;
      });
    });

    // Перехід до наступного екрану після завершення анімації
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.nextScreen),
        );
      }
    });

    // Запуск анімації
    _animationController.forward();
  }

  @override
  void dispose() {
    // Звільнення ресурсів
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Фонове зображення
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Декоративні хмаринки
            Positioned(
              bottom: 100,
              left: 20,
              child: _buildCloud(80),
            ),
            Positioned(
              bottom: 150,
              right: 30,
              child: _buildCloud(60),
            ),
            Positioned(
              bottom: 80,
              right: 80,
              child: _buildCloud(100),
            ),
            // Основний контент екрану
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Текст "LOADING..."
                  Image.asset(
                    'assets/images/loading_text.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 40),
                  // Круговий індикатор прогресу
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Зовнішнє коло
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 10,
                          ),
                        ),
                      ),
                      // Внутрішнє коло
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 10,
                          ),
                        ),
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                      // Відображення відсотка завантаження
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Декоративні зірочки
            Positioned(
              top: 100,
              left: 50,
              child: _buildStar(20),
            ),
            Positioned(
              top: 80,
              right: 70,
              child: _buildStar(30),
            ),
          ],
        ),
      ),
    );
  }

  // Створення віджета хмаринки
  Widget _buildCloud(double size) {
    return CustomPaint(
      size: Size(size, size * 0.6),
      painter: CloudPainter(),
    );
  }

  // Створення віджета зірочки
  Widget _buildStar(double size) {
    return Icon(
      Icons.star,
      color: Colors.yellow,
      size: size,
    );
  }
}

// Клас для малювання хмаринки
class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Налаштування пензля для малювання
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Створення шляху для хмаринки
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.2, size.height * 0.2,
        size.width * 0.4, size.height * 0.2,
      )
      ..quadraticBezierTo(
        size.width * 0.6, size.height * 0.2,
        size.width * 0.8, size.height * 0.4,
      )
      ..quadraticBezierTo(
        size.width, size.height * 0.6,
        size.width * 0.8, size.height * 0.8,
      )
      ..close();

    // Малювання хмаринки
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 