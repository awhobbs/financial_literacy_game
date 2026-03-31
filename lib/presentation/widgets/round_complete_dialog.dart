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
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null && uid.isNotEmpty) {
      await OfflineSync.sync(uid);
    }
    await OfflineStorage.clearSimpleState();
    await prefs.clear();
    ref.read(gameDataNotifierProvider.notifier).resetGame();

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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Continue'),
        ),
        TextButton(
          onPressed: () => _endSession(context),
          child: Text(
            'End Session',
            style: TextStyle(color: ColorPalette().darkText),
          ),
        ),
      ],
    );
  }
}