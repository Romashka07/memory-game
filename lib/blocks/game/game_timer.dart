import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer {
  Timer? _timer;
  Timer? _freezeTimer;
  int _currentTime;
  int _freezeTime = 10;
  bool _isFrozen = false;
  bool _isPaused = false;

  final Function(int) onTimeUpdate;
  final Function(int) onFreezeTimeUpdate;
  final Function(bool) onTimerFrozenUpdate;
  final Function() onTimeUp;

  GameTimer({
    required int initialTime,
    required this.onTimeUpdate,
    required this.onFreezeTimeUpdate,
    required this.onTimerFrozenUpdate,
    required this.onTimeUp,
  }) : _currentTime = initialTime {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _currentTime > 0) {
        _currentTime--;
        onTimeUpdate(_currentTime);
      } else if (_currentTime <= 0) {
        _timer?.cancel();
        onTimeUp();
      }
    });
  }

  void pauseTimer() {
    _isPaused = true;
    _timer?.cancel();
    _freezeTimer?.cancel();
  }

  void resumeTimer() {
    _isPaused = false;
    if (!_isFrozen) {
      _startTimer();
    } else {
      _startFreezeTimer();
    }
  }

  void _startFreezeTimer() {
    _freezeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _freezeTime > 0) {
        _freezeTime--;
        onFreezeTimeUpdate(_freezeTime);
      } else if (_freezeTime <= 0) {
        _freezeTimer?.cancel();
        _isFrozen = false;
        onTimerFrozenUpdate(false);
        _startTimer();
      }
    });
  }

  void freezeTimer() {
    _timer?.cancel();
    _isFrozen = true;
    _freezeTime = 10;
    onTimerFrozenUpdate(true);

    if (!_isPaused) {
      _startFreezeTimer();
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void dispose() {
    _timer?.cancel();
    _freezeTimer?.cancel();
  }

  int get currentTime => _currentTime;
  int get freezeTime => _freezeTime;
  bool get isFrozen => _isFrozen;
  bool get isPaused => _isPaused;
} 