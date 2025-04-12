import 'package:flutter/material.dart';

class ProfileAnimations {
  late AnimationController deleteButtonAnimationController;
  late Animation<double> deleteButtonScaleAnimation;
  late Animation<double> deleteButtonDarkeningAnimation;

  ProfileAnimations(TickerProvider vsync) {
    deleteButtonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: vsync,
    );

    deleteButtonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: deleteButtonAnimationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    deleteButtonDarkeningAnimation = TweenSequence<double>([
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
        parent: deleteButtonAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOutQuad),
      ),
    );
  }

  void dispose() {
    deleteButtonAnimationController.dispose();
  }
} 