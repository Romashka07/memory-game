import 'package:flutter/material.dart';
import '../../utils/preferences_manager.dart';
import '../../utils/sound_manager.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../screens/loading_screen.dart';
import '../../screens/home_screen.dart';

class ProfileActions {
  final SoundManager _soundManager = SoundManager();
  bool isButtonPressed = false;

  void showAvatarSelectionDialog(BuildContext context, Function(String) onAvatarSelected) async {
    await _soundManager.playClickSound();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade900.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.4), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Avatar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(9, (index) {
                    final avatarName = 'profile_${index + 1}';
                    return GestureDetector(
                      onTap: () async {
                        await _soundManager.playClickSound();
                        await PreferencesManager.setAvatar(avatarName);
                        onAvatarSelected(avatarName);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/$avatarName.png'),
                          radius: 40,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        imagePath: 'assets/images/delete_account_button.png',
        onConfirm: () async {
          await PreferencesManager.resetAllData();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoadingScreen(
                  nextScreen: const HomeScreen(),
                ),
              ),
              (route) => false,
            );
          }
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
} 