import 'package:just_audio/just_audio.dart';

class BackgroundMusicManager {
  static final BackgroundMusicManager _instance = BackgroundMusicManager._internal();
  factory BackgroundMusicManager() => _instance;
  BackgroundMusicManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isPlaying = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _audioPlayer.setAsset('assets/audio/moonlightdrive.mp3');
      await _audioPlayer.setLoopMode(LoopMode.all); // Зациклюємо відтворення
      _isInitialized = true;
    }
  }

  Future<void> play() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      await _audioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      // Якщо виникла помилка відтворення (наприклад, через обмеження браузера),
      // спробуємо відтворити після наступної взаємодії користувача
      _isPlaying = false;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  bool get isPlaying => _isPlaying;
} 