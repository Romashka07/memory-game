import 'package:flutter/material.dart';

class LevelAnimations {
  final Map<int, AnimationController> levelAnimationControllers;
  final Map<int, Animation<double>> levelDarkeningAnimations;
  final Map<String, AnimationController> difficultyAnimationControllers;

  LevelAnimations(TickerProviderStateMixin vsync) 
    : levelAnimationControllers = Map.fromIterable(
        List.generate(9, (index) => index + 1),
        key: (level) => level,
        value: (_) => AnimationController(
          duration: const Duration(milliseconds: 100),
          vsync: vsync,
        ),
      ),
      levelDarkeningAnimations = Map.fromIterable(
        List.generate(9, (index) => index + 1),
        key: (level) => level,
        value: (level) => TweenSequence<double>([
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
            parent: AnimationController(
              duration: const Duration(milliseconds: 100),
              vsync: vsync,
            ),
            curve: Interval(0.0, 1.0, curve: Curves.easeInOutQuad),
          ),
        ),
      ),
      difficultyAnimationControllers = {
        'easy': AnimationController(duration: const Duration(milliseconds: 150), vsync: vsync),
        'medium': AnimationController(duration: const Duration(milliseconds: 150), vsync: vsync),
        'hard': AnimationController(duration: const Duration(milliseconds: 150), vsync: vsync),
      };

  void dispose() {
    for (var controller in levelAnimationControllers.values) {
      controller.dispose();
    }
    for (var controller in difficultyAnimationControllers.values) {
      controller.dispose();
    }
  }
} 