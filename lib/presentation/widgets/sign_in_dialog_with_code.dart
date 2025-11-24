import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financial_literacy_game/l10n/app_localizations.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/utils/database.dart';
import '../../domain/utils/utils.dart';
import '../../domain/game_data_notifier.dart';

import '../../offline/offline_storage.dart';
import '../../offline/offline_sync.dart';

import 'is_this_you_dialog.dart';
import 'sign_in_with_name_dialog.dart';
import 'menu_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInDialogNew extends ConsumerStatefulWidget {
  const SignInDialogNew({super.key});

  @override
  ConsumerState<SignInDialogNew> createState() => _SignInDialogNewState();
}

class _SignInDialogNewState extends ConsumerState<SignInDialogNew> {
  late TextEditingController uidTextController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    uidTextController = TextEditingController();
  }

  @override
  void dispose() {
    uidTextController.dispose();
    super.dispose();
  }

  Future<Person?> findPerson({required String uid}) async {
    if (uid.length != 7) {
      showErrorSnackBar(
        context: context,
        errorMessage: AppLocalizations.of(context)!.enterUID,
      );
      return null;
    }
    return await searchUserbyUIDInFirestore(uid);
  }

  Future<void> handleLogin(Person person, WidgetRef ref) async {
    // 1. Clear saved state
    await OfflineStorage.clearSimpleState();

    // 2. Clear prefs
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 3. Reset game
    ref.read(gameDataNotifierProvider.notifier).resetGame();

    // 4. Show confirmation
    if (mounted) {
      Navigator.of(context).pop();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => IsThisYouDialog(person: person),
      );
    }

    // 5. sync immediately
    await OfflineSync.sync(person.uid ?? "NOUID");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MenuDialog(
          showCloseButton: false,
          title: AppLocalizations.of(context)!.titleSignIn.capitalize(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: uidTextController,
                maxLength: 7,
                decoration:
                InputDecoration(hintText: AppLocalizations.of(context)!.hintUID),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                ],
              ),
            ],
          ),
          actions: [
            // Name-login fallback
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const SignInWithNameDialog(),
                );
              },
              child: Text(AppLocalizations.of(context)!.noCodeButton),
            ),

            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                setState(() => isProcessing = true);

                Person? user =
                await findPerson(uid: uidTextController.text);

                if (user != null) {
                  await handleLogin(user, ref);
                } else {
                  setState(() => isProcessing = false);
                }
              },
              child: Text(AppLocalizations.of(context)!.continueButton),
            ),
          ],
        ),

        if (isProcessing)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
