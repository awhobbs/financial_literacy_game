import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:financial_literacy_game/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/game_data_notifier.dart';
import '../../offline/offline_storage.dart';
import '../../offline/offline_sync.dart';
import 'how_to_play_dialog.dart';
import 'language_selection_dialog.dart';
import 'menu_dialog.dart';
import 'sign_in_dialog_with_code.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuDialog(
      title: AppLocalizations.of(context)!.settings.capitalize(),
      content: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) {
                  // returns the how to dialog
                  return const HowToPlayDialog();
                },
              );
            },
            child: Text(AppLocalizations.of(context)!.howToPlay),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('New Player'),
                  content: const Text(
                    'This will save the current player\'s data and let a new player sign in.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;

              // Sync current player's pending data before clearing
              final prefs = await SharedPreferences.getInstance();
              final uid = prefs.getString('uid');
              if (uid != null && uid.isNotEmpty) {
                await OfflineSync.sync(uid);
              }

              // Clear player identity but NOT the offline queue so that any
              // rounds that failed to sync can be retried on next sign-in.
              await OfflineStorage.clearSimpleState();
              await prefs.remove('uid');
              await prefs.remove('personExists');
              await prefs.remove('firstName');
              await prefs.remove('lastName');
              await prefs.remove('lastPlayedLevelID');
              await prefs.remove('lastRoundNumber');
              await prefs.remove('lastSessionId');
              ref.read(gameDataNotifierProvider.notifier).resetGame();

              if (context.mounted) {
                Navigator.of(context).pop(); // close settings
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => const SignInDialogNew(),
                );
              }
            },
            child: const Text('New Player'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: Colors.red.shade700,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content: const Text(
                    'This will erase all saved data and start a completely fresh session.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;

              final prefs = await SharedPreferences.getInstance();
              await OfflineStorage.clearSimpleState();
              await OfflineStorage.clearLastRound();
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
            },
            child: const Text('Clear Cache'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Restart Game'),
                  content: const Text(
                    'This will restart from the beginning for the current player.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Restart'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
              ref.read(gameDataNotifierProvider.notifier).resetGame();
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Restart Game'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () {
              ref.read(gameDataNotifierProvider.notifier).moveToNextLevel();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.nextLevel.capitalize()),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) {
                  return LanguageSelectionDialog(
                    title: AppLocalizations.of(context)!
                        .languagesTitle
                        .capitalize(),
                  );
                },
              );
            },
            child:
                Text(AppLocalizations.of(context)!.languagesTitle.capitalize()),
          ),
        ],
      ),
      ),
    );
  }
}
