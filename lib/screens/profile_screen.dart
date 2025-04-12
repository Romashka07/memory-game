import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/sound_manager.dart';
import '../blocks/profile/profile_info.dart';
import '../blocks/profile/profile_stats.dart';
import '../blocks/profile/profile_actions.dart';
import '../blocks/profile/profile_ui.dart';
import '../blocks/profile/profile_animations.dart';
import 'loading_screen.dart';
import 'home_screen.dart';

// Екран профілю користувача
class ProfileScreen extends StatefulWidget {
  final Widget previousScreen;

  const ProfileScreen({
    super.key,
    required this.previousScreen,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// Стан екрану профілю
class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late final ProfileInfo _profileInfo;
  late final ProfileStats _profileStats;
  late final ProfileActions _profileActions;
  late final ProfileAnimations _animations;
  final _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _profileInfo = ProfileInfo();
    _profileStats = ProfileStats();
    _profileActions = ProfileActions();
    _animations = ProfileAnimations(this);
    
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _profileInfo.loadNickname();
    await _profileInfo.loadAvatar();
    await _profileInfo.loadDiamonds();
    await _profileStats.loadStatistics();
    setState(() {});
  }

  @override
  void dispose() {
    _profileInfo.dispose();
    _animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.12;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Верхня панель з кнопкою "назад"
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: 7,
                ),
                child: Row(
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
                                nextScreen: widget.previousScreen,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Аватар та кнопка редагування
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/${_profileInfo.currentAvatar}.png'),
                      radius: 60,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () => _profileActions.showAvatarSelectionDialog(
                          context,
                          (avatar) => setState(() => _profileInfo.currentAvatar = avatar),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Нікнейм та кнопка редагування
              ProfileUI.buildNicknameSection(
                isEditingNickname: _profileInfo.isEditingNickname,
                nickname: _profileInfo.nickname,
                nicknameController: _profileInfo.nicknameController,
                onSaveNickname: (nickname) async {
                  await _profileInfo.saveNickname(nickname);
                  setState(() {});
                },
                onEditPressed: () => setState(() => _profileInfo.isEditingNickname = !_profileInfo.isEditingNickname),
                maxNicknameLength: ProfileInfo.maxNicknameLength,
              ),
              const SizedBox(height: 30),
              // Алмази
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_profileInfo.diamonds}',
                      style: const TextStyle(
                        fontSize: 24,
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
                    const SizedBox(width: 10),
                    const Icon(Icons.diamond, color: Colors.orange, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Статистика
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    ProfileUI.buildStatisticRow(
                      'Unlocked:',
                      '${_profileStats.unlockedAchievements}/${_profileStats.totalAchievements}',
                      Icons.emoji_events,
                    ),
                    const SizedBox(height: 15),
                    ProfileUI.buildStatisticRow(
                      'Passed Lvl:',
                      '${_profileStats.completedLevels}/${_profileStats.totalLevels}',
                      Icons.star,
                    ),
                    const SizedBox(height: 15),
                    ProfileUI.buildStatisticRow(
                      'Hints Used:',
                      '${_profileStats.hintsUsed}',
                      Icons.lightbulb_outline,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Кнопка видалення акаунту
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTapDown: (_) => _animations.deleteButtonAnimationController.forward(),
                  onTapUp: (_) async {
                    _animations.deleteButtonAnimationController.reverse();
                    await _soundManager.playClickSound();
                    _profileActions.showDeleteConfirmationDialog(context);
                  },
                  onTapCancel: () => _animations.deleteButtonAnimationController.reverse(),
                  child: AnimatedBuilder(
                    animation: _animations.deleteButtonAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animations.deleteButtonScaleAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                child: Image.asset(
                                  'assets/images/delete_account_text.png',
                                  height: 40,
                                ),
                              ),
                              Positioned.fill(
                                child: AnimatedBuilder(
                                  animation: _animations.deleteButtonDarkeningAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(_animations.deleteButtonDarkeningAnimation.value),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 