import 'package:flutter/material.dart';

class SettingsAnimations {
  late AnimationController restoreButtonAnimationController;
  late AnimationController privacyButtonAnimationController;
  late Animation<double> restoreButtonScaleAnimation;
  late Animation<double> restoreButtonDarkeningAnimation;
  late Animation<double> privacyButtonScaleAnimation;
  late Animation<double> privacyButtonDarkeningAnimation;

  SettingsAnimations(TickerProvider vsync) {
    restoreButtonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: vsync,
    );

    privacyButtonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: vsync,
    );

    restoreButtonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(restoreButtonAnimationController);

    restoreButtonDarkeningAnimation = Tween<double>(
      begin: 0.0,
      end: 0.3,
    ).animate(restoreButtonAnimationController);

    privacyButtonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(privacyButtonAnimationController);

    privacyButtonDarkeningAnimation = Tween<double>(
      begin: 0.0,
      end: 0.3,
    ).animate(privacyButtonAnimationController);
  }

  void dispose() {
    restoreButtonAnimationController.dispose();
    privacyButtonAnimationController.dispose();
  }
} 