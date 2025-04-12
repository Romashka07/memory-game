class LevelConfig {
  final int timeInSeconds;
  final int numberOfPairs;

  const LevelConfig({
    required this.timeInSeconds,
    required this.numberOfPairs,
  });

  static LevelConfig getConfig(int level) {
    switch (level) {
      // Легкі рівні
      case 1:
        return const LevelConfig(timeInSeconds: 80, numberOfPairs: 8);  // 1:20
      case 2:
        return const LevelConfig(timeInSeconds: 70, numberOfPairs: 8);  // 1:10
      case 3:
        return const LevelConfig(timeInSeconds: 60, numberOfPairs: 8);  // 1:00

      // Середні рівні
      case 4:
        return const LevelConfig(timeInSeconds: 60, numberOfPairs: 10); // 1:00
      case 5:
        return const LevelConfig(timeInSeconds: 50, numberOfPairs: 10); // 0:50
      case 6:
        return const LevelConfig(timeInSeconds: 40, numberOfPairs: 10); // 0:40

      // Складні рівні
      case 7:
        return const LevelConfig(timeInSeconds: 40, numberOfPairs: 10); // 0:40
      case 8:
        return const LevelConfig(timeInSeconds: 30, numberOfPairs: 10); // 0:30
      case 9:
        return const LevelConfig(timeInSeconds: 20, numberOfPairs: 10); // 0:20

      default:
        return const LevelConfig(timeInSeconds: 80, numberOfPairs: 8);
    }
  }
} 