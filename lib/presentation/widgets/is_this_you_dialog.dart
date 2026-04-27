import 'package:financial_literacy_game/presentation/widgets/sign_in_dialog_with_code.dart';
import 'package:financial_literacy_game/presentation/widgets/welcome_back_dialog.dart';
import 'package:flutter/material.dart';
import 'package:financial_literacy_game/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/database.dart';
import '../../domain/utils/device_and_personal_data.dart';
import 'menu_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsThisYouDialog extends ConsumerStatefulWidget {
  final Person person;
  const IsThisYouDialog({required this.person, Key? key}) : super(key: key);

  @override
  ConsumerState<IsThisYouDialog> createState() => _IsThisYouDialogState();
}

class _IsThisYouDialogState extends ConsumerState<IsThisYouDialog> {
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.person.firstName ?? '';
    final lastName = widget.person.lastName ?? '';
    final hasName = firstName.isNotEmpty || lastName.isNotEmpty;
    final displayFirst = hasName ? firstName : (widget.person.uid ?? '');
    final displayLast = hasName ? lastName : '';
    return Stack(
      children: [
        MenuDialog(
          showCloseButton: false,
          title: AppLocalizations.of(context)!.confirmNameTitle,
          content: Text(AppLocalizations.of(context)!
              .confirmName(displayFirst, displayLast)),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: ColorPalette().buttonBackground,
                foregroundColor: ColorPalette().lightText,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const SignInDialogNew();
                  },
                );
              },
              child: Text(
                AppLocalizations.of(context)!.noButton,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: ColorPalette().buttonBackground,
                foregroundColor: ColorPalette().lightText,
              ),
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() { isProcessing = true; });

                      final person = widget.person;

                      // Save person locally and set in state
                      ref.read(gameDataNotifierProvider.notifier).setPerson(person);
                      await savePersonLocally(person);

                      // Try to reconnect to an existing Firestore session.
                      // Wrap with timeout + catch so offline devices don't freeze.
                      bool reconnected = false;
                      try {
                        reconnected = await reconnectToGameSession(person: person)
                            .timeout(const Duration(seconds: 5));
                      } catch (_) {
                        reconnected = false;
                      }

                      bool isReturningUser = false;

                      if (reconnected && currentLevelDataRef != null) {
                        // Online path — restore level from Firestore.
                        try {
                          final levelDoc = await currentLevelDataRef!.get();
                          final firestoreLevel =
                              ((levelDoc.data() as Map<String, dynamic>?)?['level'] as int?) ?? 1;
                          final restoredId = (firestoreLevel - 1).clamp(0, levels.length - 1);
                          ref.read(gameDataNotifierProvider.notifier).loadLevel(restoredId);
                          isReturningUser = true;
                        } catch (_) {
                          // Can't read level — start fresh.
                          saveUserInFirestore(person); // fire-and-forget: syncs when online
                          ref.read(gameDataNotifierProvider.notifier).resetGame();
                        }
                      } else {
                        // Offline or new user — check the per-UID level cache
                        // written by "Done for the week" on this device.
                        final prefs = await SharedPreferences.getInstance();
                        final cachedLevel = prefs.getInt('nextLevel_${person.uid}');
                        if (cachedLevel != null && cachedLevel > 0) {
                          // Returning participant who completed a previous week.
                          ref.read(gameDataNotifierProvider.notifier).loadLevel(cachedLevel);
                          isReturningUser = true;
                        } else {
                          // Genuinely new user — register in Firestore when back online.
                          saveUserInFirestore(person); // fire-and-forget: syncs when online
                          ref.read(gameDataNotifierProvider.notifier).resetGame();
                        }
                      }

                      setState(() { isProcessing = false; });

                      if (context.mounted) {
                        Navigator.of(context).pop();
                        if (isReturningUser) {
                          // Show "Welcome back" with Next Level + Restart options.
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => const WelcomeBackDialog(),
                          );
                        }
                        // New users: dialog closes and game starts at Level 1.
                      }
                    },
              child: Text(AppLocalizations.of(context)!.yesButton),
            ),
          ],
        ),
        if (isProcessing)
          const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
