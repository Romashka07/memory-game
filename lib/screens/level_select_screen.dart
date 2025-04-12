import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/achievement_notification.dart';
import '../utils/sound_manager.dart';
import 'loading_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import '../blocks/level/level_state.dart';
import '../blocks/level/level_achievements.dart';
import '../blocks/level/level_animations.dart';
import '../blocks/level/level_ui.dart';

// Екран вибору рівня гри
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

// Стан екрану вибору рівня
class _LevelSelectScreenState extends State<LevelSelectScreen> with TickerProviderStateMixin {
  // Менеджер звуків
  final _soundManager = SoundManager();
  // Блоки
  late final LevelState _levelState;
  late final LevelAchievements _levelAchievements;
  late final LevelAnimations _levelAnimations;

  @override
  void initState() {
    super.initState();
    _levelState = LevelState();
    _levelAchievements = LevelAchievements();
    _levelAnimations = LevelAnimations(this);
    
    _loadData();
  }

  Future<void> _loadData() async {
    await _levelState.loadCompletedLevels();
    await _levelAchievements.loadNewAchievements();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _levelAnimations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Розрахунок розмірів елементів інтерфейсу
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.12;
    final difficultyButtonWidth = screenWidth * 0.28;

    return Container(
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
            Column(
              children: [
                // Верхня панель з кнопками навігації
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.person, color: Colors.black, size: iconSize),
                            onPressed: () async {
                              await _soundManager.playClickSound();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                    nextScreen: ProfileScreen(
                                      previousScreen: const LevelSelectScreen(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Заголовок екрану
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Image.asset(
                    'assets/images/select_level_text.png',
                    width: screenWidth * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
                // Складність
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _levelState.currentPage == 1 ? [
                      LevelUI.buildDifficultyButton(
                        difficulty: 'easy',
                        color: Colors.green,
                        width: difficultyButtonWidth,
                        isSelected: _levelState.selectedDifficulty == 'easy',
                        controller: _levelAnimations.difficultyAnimationControllers['easy']!,
                        onTap: () => setState(() => _levelState.updateDifficulty('easy')),
                        soundManager: _soundManager,
                      ),
                      LevelUI.buildDifficultyButton(
                        difficulty: 'medium',
                        color: Colors.orange,
                        width: difficultyButtonWidth,
                        isSelected: _levelState.selectedDifficulty == 'medium',
                        controller: _levelAnimations.difficultyAnimationControllers['medium']!,
                        onTap: () => setState(() => _levelState.updateDifficulty('medium')),
                        soundManager: _soundManager,
                      ),
                      LevelUI.buildDifficultyButton(
                        difficulty: 'hard',
                        color: Colors.red,
                        width: difficultyButtonWidth,
                        isSelected: _levelState.selectedDifficulty == 'hard',
                        controller: _levelAnimations.difficultyAnimationControllers['hard']!,
                        onTap: () => setState(() => _levelState.updateDifficulty('hard')),
                        soundManager: _soundManager,
                      ),
                    ] : [],
                  ),
                ),
                // Сітка рівнів або заглушка
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _levelState.currentPage == 1 
                      ? GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: _levelState.getFilteredLevels().length,
                          itemBuilder: (context, index) {
                            final level = _levelState.getFilteredLevels()[index];
                            return LevelUI.buildLevelButton(
                              context: context,
                              level: level,
                              isCompleted: _levelState.completedLevels.contains(level),
                              controller: _levelAnimations.levelAnimationControllers[level]!,
                              darkeningAnimation: _levelAnimations.levelDarkeningAnimations[level]!,
                              soundManager: _soundManager,
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, -50),
                              child: Image.asset(
                                'assets/images/in_development_text.png',
                                width: MediaQuery.of(context).size.width * 0.8,
                              ),
                            ),
                          ],
                        ),
                  ),
                ),
                // Пагінація
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LevelUI.buildNavigationButton(
                        icon: Icons.arrow_back_ios,
                        canNavigate: _levelState.currentPage > 1,
                        onTap: () => setState(() => _levelState.updatePage(_levelState.currentPage - 1)),
                        soundManager: _soundManager,
                      ),
                      const SizedBox(width: 20),
                      LevelUI.buildPageIndicator(_levelState.currentPage == 1),
                      LevelUI.buildPageIndicator(_levelState.currentPage == 2),
                      LevelUI.buildPageIndicator(_levelState.currentPage == 3),
                      const SizedBox(width: 20),
                      LevelUI.buildNavigationButton(
                        icon: Icons.arrow_forward_ios,
                        canNavigate: _levelState.currentPage < _levelState.totalPages,
                        onTap: () => setState(() => _levelState.updatePage(_levelState.currentPage + 1)),
                        soundManager: _soundManager,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Сповіщення про досягнення
            if (_levelAchievements.isShowingAchievements && _levelAchievements.achievementNotifications.isNotEmpty)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: const AchievementNotification(),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 