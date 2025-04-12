import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/sound_manager.dart';
import '../blocks/home/home_state.dart';
import '../blocks/home/home_ui.dart';

// Головний екран гри, що відображається при запуску
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Стан головного екрану
class _HomeScreenState extends State<HomeScreen> {
  final _soundManager = SoundManager();
  final _homeState = HomeState();

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  @override
  void dispose() {
    _homeState.dispose();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    await _homeState.initializeAudio();
  }

  @override
  Widget build(BuildContext context) {
    // Розрахунок розміру іконок відносно ширини екрану
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.12;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Фонове зображення
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              // Верхня панель з кнопкою профілю користувача
              HomeUI.buildTopBar(context, screenWidth, iconSize, _soundManager),
              // Основний контент екрану
              Expanded(
                child: HomeUI.buildMainContent(context, _soundManager),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
