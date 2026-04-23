import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/color_palette.dart';
import '../../domain/game_data_notifier.dart';
import '../../offline/offline_storage.dart';
import '../../offline/offline_sync.dart';
import 'sign_in_dialog_with_code.dart';

class RoundCompleteDialog extends StatelessWidget {
  final WidgetRef ref;
  const RoundCompleteDialog({required this.ref, super.key});

  Future<void> _endSession(BuildContext context) async {
    // Capture current level before async work so it persists after clearing.
    final currentLevelId = ref.read(gameDataNotifierProvider).levelId;

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null && uid.isNotEmpty) {
      await OfflineSync.sync(uid);
    }

    // Clear player identity but NOT the offline queue so that any
    // rounds that failed to sync can be retried when this player
    // signs in again.
    await OfflineStorage.clearSimpleState();
    await prefs.remove('uid');
    await prefs.remove('personExists');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('lastRoundNumber');
    await prefs.remove('lastSessionId');

    // Save current level so "Continue from Level X" is shown when the
    // player signs in again on the same device.
    await prefs.setInt('lastPlayedLevelID', currentLevelId);

    // Reset in memory without overwriting the level we just saved.
    ref.read(gameDataNotifierProvider.notifier).resetGameLocalNoSave();

    if (context.mounted) {
      Navigator.of(context).pop();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => const SignInDialogNew(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette().backgroundContentCard,
      title: Text(
        'Congratulations!',
        style: TextStyle(
          color: ColorPalette().gameWinText,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      content: Text(
        'Great job completing this round! Continue playing or end this session for the next player.',
        style: TextStyle(color: ColorPalette().darkText, fontSize: 16),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette().buttonBackground,
            foregroundColor: ColorPalette().lightText,
          ),
          onPressed: () {
            // Mark the level-complete as acknowledged so the dialog does not
            // repeat on every subsequent round while the player continues.
            ref
                .read(gameDataNotifierProvider.notifier)
                .acknowledgeCurrentLevelSolved();
            Navigator.of(context).pop();
          },
          child: const Text('Continue'),
        ),
        TextButton(
          onPressed: () => _endSession(context),
          child: Text(
            'Done for the week',
            style: TextStyle(color: ColorPalette().darkText),
          ),
        ),
      ],
    );
  }
}