import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:financial_literacy_game/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../l10n/l10n.dart';

// Offline
import '../../offline/offline_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// UI
import '../widgets/asset_content.dart';
import '../widgets/game_app_bar.dart';
import '../widgets/language_selection_dialog.dart';
import '../widgets/level_info_card.dart';
import '../widgets/loan_content.dart';
import '../widgets/overview_content.dart';
import '../widgets/section_card.dart';
import '../widgets/sign_in_dialog_with_code.dart';
import '../widgets/welcome_back_dialog.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //--------------------------------------------------------------------
      // 1️⃣ RESTORE SIMPLE AUTOSAVED GAME STATE (cash, level, period, locale)
      //--------------------------------------------------------------------
      final saved = await OfflineStorage.loadSimpleState();

      // Only restore if at least one value exists
      if (saved["cash"] != null ||
          saved["levelId"] != null ||
          saved["period"] != null)
      {
        // Load the last level the user was on
        ref.read(gameDataNotifierProvider.notifier).loadLevel(
          saved["levelId"] ?? 0,
        );

        // Restore locale
        ref.read(gameDataNotifierProvider.notifier).setLocale(
          Locale(saved["locale"] ?? "en"),
        );
      }

      //--------------------------------------------------------------------
      // 2️⃣ DEVICE INFORMATION (system language)
      //--------------------------------------------------------------------
      await getDeviceInfo();

      //--------------------------------------------------------------------
      // 3️⃣ LANGUAGE SELECTION (only if not chosen before)
      //--------------------------------------------------------------------
      final storedLocale = await loadLocaleFromLocal();
      if (storedLocale == null && mounted) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => LanguageSelectionDialog(
            title: AppLocalizations.of(context)!.languagesTitle,
          ),
        );
      }

      //--------------------------------------------------------------------
      // 4️⃣ APPLY SYSTEM LOCALE TO GAME
      //--------------------------------------------------------------------
      final systemLocale = await L10n.getSystemLocale();
      ref.read(gameDataNotifierProvider.notifier).setLocale(systemLocale);

      //--------------------------------------------------------------------
      // 5️⃣ CHECK FOR EXISTING USER SESSION
      //--------------------------------------------------------------------
      final prefs = await SharedPreferences.getInstance();
      final savedUID = prefs.getString('uid');
      final savedPersonExists = prefs.getBool('personExists') ?? false;

      bool personLoaded = false;

      if (savedUID != null && savedUID.isNotEmpty && savedPersonExists) {
        personLoaded = await loadPerson(ref: ref);
      }

      //--------------------------------------------------------------------
      // 6️⃣ WELCOME BACK DIALOG FOR RETURNING USER
      //--------------------------------------------------------------------
      if (personLoaded) {
        final ok = await loadLevelIDFromLocal(ref: ref);
        if (ok && mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => const WelcomeBackDialog(),
          );
        }
      } else {
        //--------------------------------------------------------------------
        // 7️⃣ NEW USER → SHOW SIGN-IN OPTIONS
        //--------------------------------------------------------------------
        if (mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => LanguageSelectionDialog(
              title: AppLocalizations.of(context)!.selectLanguage,
              showDialogWidgetAfterPop: const SignInDialogNew(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelId = ref.watch(gameDataNotifierProvider).levelId;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorPalette().background,
          resizeToAvoidBottomInset: false,
          appBar: const GameAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: playAreaMaxWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        LevelInfoCard(
                          currentCash:
                          ref.watch(gameDataNotifierProvider).cash,
                          levelId: levelId,
                          nextLevelCash: levels[levelId].cashGoal,
                        ),
                        const SizedBox(height: 10),

                        SectionCard(
                          title: AppLocalizations.of(context)!
                              .overview
                              .toUpperCase(),
                          content: const OverviewContent(),
                        ),
                        const SizedBox(height: 10),

                        SectionCard(
                          title: AppLocalizations.of(context)!
                              .assets
                              .toUpperCase(),
                          content: const AssetContent(),
                        ),
                        const SizedBox(height: 10),

                        if (levelId > 1)
                          SectionCard(
                            title: AppLocalizations.of(context)!
                                .loan(2)
                                .toUpperCase(),
                            content: const LoanContent(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Confetti Effect
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController:
            ref.watch(gameDataNotifierProvider).confettiController,
            shouldLoop: true,
            emissionFrequency: 0.03,
            numberOfParticles: 20,
            maxBlastForce: 25,
            minBlastForce: 7,
            gravity: 0.2,
            particleDrag: 0.05,
            blastDirection: pi,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ),
      ],
    );
  }
}
