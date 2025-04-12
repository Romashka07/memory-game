import '../../../../utils/preferences_manager.dart';
import '../../../../use_cases/base_use_case.dart';

class UpdateDiamondsInput {
  final int currentDiamonds;
  final int diamondsToAdd;
  final Function(int) onDiamondsUpdate;

  UpdateDiamondsInput({
    required this.currentDiamonds,
    required this.diamondsToAdd,
    required this.onDiamondsUpdate,
  });
}

class UpdateDiamondsOutput {
  final int newDiamonds;

  UpdateDiamondsOutput({
    required this.newDiamonds,
  });
}

class UpdateDiamondsUseCase implements BaseUseCase<UpdateDiamondsInput, UpdateDiamondsOutput> {
  @override
  Future<UpdateDiamondsOutput> execute(UpdateDiamondsInput input) async {
    final newDiamonds = input.currentDiamonds + input.diamondsToAdd;
    await PreferencesManager.setDiamonds(newDiamonds);
    input.onDiamondsUpdate(newDiamonds);
    
    return UpdateDiamondsOutput(newDiamonds: newDiamonds);
  }
} 