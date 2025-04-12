import 'package:flutter/material.dart';
import '../../constants.dart';
import 'settings_animations.dart';
import 'settings_state.dart';

class SettingsUI {
  final double screenWidth;
  final SettingsState state;
  final SettingsAnimations animations;
  final Function() onBackPressed;
  final Function() onRestorePressed;
  final Function() onPrivacyPressed;
  final Function(double) onVolumeChanged;
  final Function(bool) onClickEffectsChanged;

  SettingsUI({
    required this.screenWidth,
    required this.state,
    required this.animations,
    required this.onBackPressed,
    required this.onRestorePressed,
    required this.onPrivacyPressed,
    required this.onVolumeChanged,
    required this.onClickEffectsChanged,
  });

  Widget buildTopPanel() {
    final iconSize = screenWidth * 0.12;
    return Padding(
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
              onPressed: onBackPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVolumeSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/volume_text.png',
                height: 60,
              ),
              Text(
                '${(state.volume * 100).round()}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
        Slider(
          value: state.volume,
          onChanged: onVolumeChanged,
          activeColor: Colors.blue,
          inactiveColor: Colors.blue.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget buildClickEffectsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/click_effects_text.png',
            height: 60,
          ),
          Switch(
            value: state.clickEffects,
            onChanged: onClickEffectsChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget buildRestoreButton() {
    return Container(
      width: screenWidth * 0.7,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTapDown: (_) => animations.restoreButtonAnimationController.forward(),
        onTapUp: (_) {
          animations.restoreButtonAnimationController.reverse();
          onRestorePressed();
        },
        onTapCancel: () => animations.restoreButtonAnimationController.reverse(),
        child: AnimatedBuilder(
          animation: animations.restoreButtonAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: animations.restoreButtonScaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.lerp(
                    Colors.blue.shade300,
                    Colors.blue.shade700,
                    animations.restoreButtonDarkeningAnimation.value,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset(
                      'assets/images/restore_settings_text.png',
                      height: 45,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPrivacyButton() {
    return Container(
      width: screenWidth * 0.7,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTapDown: (_) => animations.privacyButtonAnimationController.forward(),
        onTapUp: (_) {
          animations.privacyButtonAnimationController.reverse();
          onPrivacyPressed();
        },
        onTapCancel: () => animations.privacyButtonAnimationController.reverse(),
        child: AnimatedBuilder(
          animation: animations.privacyButtonAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: animations.privacyButtonScaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.lerp(
                    Colors.blue.shade300,
                    Colors.blue.shade700,
                    animations.privacyButtonDarkeningAnimation.value,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset(
                      'assets/images/privacy_text.png',
                      height: 45,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
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
              buildTopPanel(),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/settings_button.png',
                height: 100,
              ),
              const SizedBox(height: 40),
              buildVolumeSection(),
              const SizedBox(height: 20),
              buildClickEffectsSection(),
              const Spacer(),
              buildRestoreButton(),
              const SizedBox(height: 15),
              buildPrivacyButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
} 