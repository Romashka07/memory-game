import 'package:flutter/material.dart';
import '../../base_use_case.dart';

class ShowDialogInput {
  final BuildContext context;
  final Widget dialog;
  final bool barrierDismissible;

  ShowDialogInput({
    required this.context,
    required this.dialog,
    this.barrierDismissible = false,
  });
}

class ShowDialogOutput {
  final bool success;
  final String? error;

  ShowDialogOutput({
    required this.success,
    this.error,
  });
}

class ShowDialogUseCase implements BaseUseCase<ShowDialogInput, ShowDialogOutput> {
  @override
  Future<ShowDialogOutput> execute(ShowDialogInput input) async {
    try {
      await showDialog(
        context: input.context,
        barrierDismissible: input.barrierDismissible,
        builder: (context) => input.dialog,
      );
      return ShowDialogOutput(success: true);
    } catch (e) {
      return ShowDialogOutput(
        success: false,
        error: 'Error showing dialog: $e',
      );
    }
  }
} 