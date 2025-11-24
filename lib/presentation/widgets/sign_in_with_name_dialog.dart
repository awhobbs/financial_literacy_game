import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:financial_literacy_game/l10n/app_localizations.dart';
import '../../config/color_palette.dart';

import '../../domain/concepts/person.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/database.dart';
import '../../domain/utils/utils.dart';

import '../../offline/offline_storage.dart';
import '../../offline/offline_sync.dart';

import 'menu_dialog.dart';
import 'sign_in_dialog_with_code.dart';

class SignInWithNameDialog extends ConsumerStatefulWidget {
  const SignInWithNameDialog({super.key});

  @override
  ConsumerState<SignInWithNameDialog> createState() =>
      _SignInWithNameDialogState();
}

class _SignInWithNameDialogState
    extends ConsumerState<SignInWithNameDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------
  // LOGIN FLOW (Name-only)
  // -----------------------------------------------------------
  Future<void> handleNameLogin(Person person) async {
    // 1. Clear saved simple state
    await OfflineStorage.clearSimpleState();

    // 2. Clear SharedPreferences (old UID, flags, etc.)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 3. Reset entire game state
    ref.read(gameDataNotifierProvider.notifier).resetGame();

    // 4. Save person to Firestore
    await saveUserInFirestore(person);

    // 5. Attempt sync using their name-based UID
    await OfflineSync.sync(person.uid ?? "NAMELOGIN");
  }

  // -----------------------------------------------------------
  // CLEAN AND VALIDATE NAME
  // -----------------------------------------------------------
  Future<bool> setPersonData() async {
    String first = firstNameController.text.trim();
    String last = lastNameController.text.trim();

    if (first.isEmpty || last.isEmpty) {
      showErrorSnackBar(
        context: context,
        errorMessage:
        AppLocalizations.of(context)!.enterName.capitalize(),
      );
      return false;
    }

    // Clean names
    first = removeLeading("-", removeTrailing("-", first));
    last = removeLeading("-", removeTrailing("-", last));

    first = "${first[0].toUpperCase()}${first.substring(1).toLowerCase()}";
    last = "${last[0].toUpperCase()}${last.substring(1).toLowerCase()}";

    Person person = Person(
      firstName: first,
      lastName: last,
      uid: "NAMELOGIN", // dummy UID for name-only login
    );

    await handleNameLogin(person);
    return true;
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
                enabled: !isProcessing,
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText:
                  AppLocalizations.of(context)!.hintFirstName.capitalize(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                ],
              ),
              TextField(
                enabled: !isProcessing,
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText:
                  AppLocalizations.of(context)!.hintLastName.capitalize(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                ],
              ),
            ],
          ),
          actions: [
            // BACK BUTTON → Return to main sign-in dialog
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: ColorPalette().buttonBackground,
                foregroundColor: ColorPalette().lightText,
              ),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => const SignInDialogNew(),
                );
              },
              child: Text(AppLocalizations.of(context)!.backButton),
            ),

            // CONTINUE (Submit)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: ColorPalette().buttonBackground,
                foregroundColor: ColorPalette().lightText,
              ),
              onPressed: isProcessing
                  ? null
                  : () async {
                setState(() => isProcessing = true);

                bool ok = await setPersonData();

                if (ok && mounted) {
                  Navigator.pop(context);
                } else {
                  setState(() => isProcessing = false);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.continueButton.capitalize(),
              ),
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

