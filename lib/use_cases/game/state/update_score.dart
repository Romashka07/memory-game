import '../../../../use_cases/base_use_case.dart';

class UpdateScoreInput {
  final int currentScore;
  final int pointsToAdd;
  final Function(int) onScoreUpdate;

  UpdateScoreInput({
    required this.currentScore,
    required this.pointsToAdd,
    required this.onScoreUpdate,
  });
}

class UpdateScoreOutput {
  final int newScore;

  UpdateScoreOutput({
    required this.newScore,
  });
}

class UpdateScoreUseCase implements BaseUseCase<UpdateScoreInput, UpdateScoreOutput> {
  @override
  Future<UpdateScoreOutput> execute(UpdateScoreInput input) async {
    final newScore = input.currentScore + input.pointsToAdd;
    input.onScoreUpdate(newScore);
    
    return UpdateScoreOutput(newScore: newScore);
  }
} 