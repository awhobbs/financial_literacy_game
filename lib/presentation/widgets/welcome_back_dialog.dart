import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:financial_literacy_game/presentation/widgets/sign_in_dialog_with_code.dart';
import 'package:flutter/material.dart';
import 'package:financial_literacy_game/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/utils/database.dart';
import 'menu_dialog.dart';

class WelcomeBackDialog extends ConsumerStatefulWidget {
  const WelcomeBackDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<WelcomeBackDialog> createState() => _WelcomeBackDialogState();
}

class _WelcomeBackDialogState extends ConsumerState<WelcomeBackDialog> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    Person person = ref.read(gameDataNotifierProvider).person;
    final int savedLevelId = ref.read(gameDataNotifierProvider).levelId;
    final String displayFirst =
        (person.firstName?.isNotEmpty == true) ? person.firstName! : (person.uid ?? '');
    final String displayLast =
        (person.lastName?.isNotEmpty == true) ? person.lastName! : '';

    return Stack(
      children: [
        MenuDialog(
          showCloseButton: false,
          title: AppLocalizations.of(context)!.welcomeBack(
              displayFirst.capitalize(), displayLast.capitalize()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.sameUser(displayFirst),
              ),
              const SizedBox(height: 10.0),

              // ── NEXT LEVEL button (only when they have saved progress) ─
              if (savedLevelId > 0) ...[
                Text(
                  'Your last session ended on Level $savedLevelId.\n'
                  'Ready to start Level ${savedLevelId + 1}?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorPalette().darkText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: ColorPalette().buttonBackground,
                    foregroundColor: ColorPalette().lightText,
                  ),
                  onPressed: isClicked
                      ? null
                      : () async {
                          setState(() { isClicked = true; });
                          try {
                            await reconnectToGameSession(person: person)
                                .timeout(const Duration(seconds: 5));
                          } catch (_) {
                            // Offline — proceed anyway; data will sync later.
                          }
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: Text(
                    'Start Level ${savedLevelId + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],

              // ── RESTART button ────────────────────────────────────────
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  backgroundColor: ColorPalette().buttonBackground,
                  foregroundColor: ColorPalette().lightText,
                ),
                onPressed: isClicked
                    ? null
                    : () async {
                        setState(() { isClicked = true; });
                        await endCurrentGameSession(
                            status: Status.abandoned, person: person);
                        ref.read(gameDataNotifierProvider.notifier).resetGame();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                child: Text(
                    AppLocalizations.of(context)!.restartGame.capitalize()),
              ),

              const SizedBox(height: 25.0),
              Text(
                AppLocalizations.of(context)!
                    .signInDifferentPerson
                    .capitalize(),
              ),
              const SizedBox(height: 10.0),

              // ── NOT ME button ─────────────────────────────────────────
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  backgroundColor: ColorPalette().buttonBackground,
                  foregroundColor: ColorPalette().lightText,
                ),
                onPressed: isClicked
                    ? null
                    : () {
                        setState(() { isClicked = true; });
                        Navigator.of(context).pop();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const SignInDialogNew();
                          },
                        );
                      },
                child: Text(AppLocalizations.of(context)!.notMe.capitalize()),
              ),
            ],
          ),
        ),
        if (isClicked) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

//
// class WelcomeBackDialog extends ConsumerWidget {
//   const WelcomeBackDialog({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Person person = ref.read(gameDataNotifierProvider).person;
//     return MenuDialog(
//       showCloseButton: false,
//       title: 'Welcome back, ${person.firstName} ${person.lastName}!',
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "If you are ${person.firstName}, simply start the game.",
//           ),
//           const SizedBox(height: 10.0),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (ref.read(gameDataNotifierProvider).levelId != 0)
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     elevation: 5.0,
//                     backgroundColor: ColorPalette().buttonBackground,
//                     foregroundColor: ColorPalette().lightText,
//                   ),
//                   onPressed: () async {
//                     bool couldReconnect =
//                         await reconnectToGameSession(person: person);
//                     if (!couldReconnect) {
//                       ref.read(gameDataNotifierProvider.notifier).resetGame();
//                     }
//                     if (context.mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text(
//                       'Start at level ${ref.read(gameDataNotifierProvider).levelId + 1}'),
//                 ),
//               if (ref.read(gameDataNotifierProvider).levelId != 0)
//                 const SizedBox(width: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 5.0,
//                   backgroundColor: ColorPalette().buttonBackground,
//                   foregroundColor: ColorPalette().lightText,
//                 ),
//                 onPressed: () async {
//                   await endCurrentGameSession(
//                       status: Status.abandoned, person: person);
//                   ref.read(gameDataNotifierProvider.notifier).resetGame();
//                   if (context.mounted) {
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: Text(AppLocalizations.of(context)!.restartGame),
//               ),
//             ],
//           ),
//           const SizedBox(height: 25.0),
//           Text(
//             AppLocalizations.of(context)!.signInDifferentPerson,
//           ),
//           const SizedBox(height: 10.0),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 5.0,
//               backgroundColor: ColorPalette().buttonBackground,
//               foregroundColor: ColorPalette().lightText,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//               showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (context) {
//                   return const SignInDialog();
//                 },
//               );
//             },
//             child: Text(AppLocalizations.of(context)!.notMe),
//           ),
//         ],
//       ),
//     );
//   }
// }
