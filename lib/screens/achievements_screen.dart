import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'home_screen.dart';
import '../utils/sound_manager.dart';
import '../blocks/achievements/achievements_state.dart';
import '../blocks/achievements/achievements_ui.dart';

// Екран досягнень гравця
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

// Стан екрану досягнень
class _AchievementsScreenState extends State<AchievementsScreen> {
  final _soundManager = SoundManager();
  final _achievementsState = AchievementsState();

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    await _achievementsState.loadAchievements();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Розрахунок розміру іконок відносно ширини екрану
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.12;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Кнопка повернення
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: 7
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black, size: iconSize),
                        onPressed: () async {
                          await _soundManager.playClickSound();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoadingScreen(
                                nextScreen: const HomeScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: iconSize),
                  ],
                ),
              ),
            ),
              
            // Заголовок екрану
            Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Image.asset(
                'assets/images/achievements_button.png',
                width: screenWidth * 0.9,
              ),
            ),
            
            // Зображення трофею
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'assets/images/trophy.png',
                height: 80,
              ),
            ),

            // Список досягнень
            Expanded(
              child: AchievementsUI.buildAchievementsList(_achievementsState),
            ),
          ],
        ),
      ),
    );
  }
} 