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

class SignInDialog extends ConsumerStatefulWidget {
  const SignInDialog({super.key});

  @override
  ConsumerState<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends ConsumerState<SignInDialog> {
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

  // -------------------------------------------------------------
  // SAFE LOGIN (Name-only login)
  // -------------------------------------------------------------
  Future<void> handleNameLogin(Person person) async {
    // 1. Clear simple local game state
    await OfflineStorage.clearSimpleState();

    // 2. Clear SharedPreferences (old UID, flags, etc.)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 3. Reset Riverpod game state
    ref.read(gameDataNotifierProvider.notifier).resetGame();

    // 4. Save user to Firestore (existing function)
    await saveUserInFirestore(person);

    // 5. Attempt to sync any queued offline actions
    await OfflineSync.sync(person.uid ?? "NAMELOGIN");
  }

  // -------------------------------------------------------------
  // CLEAN NAMES
  // -------------------------------------------------------------
  Future<bool> setPersonData() async {
    String first = firstNameController.text.trim();
    String last = lastNameController.text.trim();

    if (first.isEmpty || last.isEmpty) {
      showErrorSnackBar(
        context: context,
        errorMessage: AppLocalizations.of(context)!.enterName.capitalize(),
      );
      return false;
    }

    // clean names
    first = removeLeading("-", removeTrailing("-", first));
    last = removeLeading("-", removeTrailing("-", last));

    first = "${first[0].toUpperCase()}${first.substring(1).toLowerCase()}";
    last = "${last[0].toUpperCase()}${last.substring(1).toLowerCase()}";

    Person cleaned = Person(
      firstName: first,
      lastName: last,
      uid: "NAMELOGIN", // always same for name-only
    );

    await handleNameLogin(cleaned);
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
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
