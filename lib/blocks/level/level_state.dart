import '../../utils/preferences_manager.dart';

class LevelState {
  String selectedDifficulty = 'all'; // 'all', 'easy', 'medium', 'hard'
  List<int> completedLevels = [];
  int currentPage = 1;
  final int totalPages = 3;

  Future<void> loadCompletedLevels() async {
    completedLevels = await PreferencesManager.getCompletedLevels();
  }

  List<int> getFilteredLevels() {
    switch (selectedDifficulty) {
      case 'easy':
        return [1, 2, 3];
      case 'medium':
        return [4, 5, 6];
      case 'hard':
        return [7, 8, 9];
      default:
        return List.generate(9, (index) => index + 1);
    }
  }

  void updateDifficulty(String difficulty) {
    selectedDifficulty = selectedDifficulty == difficulty ? 'all' : difficulty;
  }

  void updatePage(int newPage) {
    if (newPage >= 1 && newPage <= totalPages) {
      currentPage = newPage;
    }
  }
} 