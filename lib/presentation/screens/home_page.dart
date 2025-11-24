import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financial_literacy_game/l10n/app_localizations.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../l10n/l10n.dart';

// Offline system
import 'package:shared_preferences/shared_preferences.dart';

// UI Components
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

      // ------------------------------------------------------------------
      // 1️⃣ DO NOT RESTORE ANY OLD GAME STATE
      // ------------------------------------------------------------------
      // Removed: loadSessionState(), loadFromJson()

      // ------------------------------------------------------------------
      // 2️⃣ Load device info (language, locale)
      // ------------------------------------------------------------------
      await getDeviceInfo();

      // If language not chosen, ask user
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

      // Apply preferred locale
      final chosenLocale = await L10n.getSystemLocale();
      ref.read(gameDataNotifierProvider.notifier).setLocale(chosenLocale);

      // ------------------------------------------------------------------
      // 3️⃣ Check if user already exists
      // ------------------------------------------------------------------
      final prefs = await SharedPreferences.getInstance();
      final savedUID = prefs.getString('uid');
      final savedPersonExists = prefs.getBool('personExists') ?? false;

      bool personLoaded = false;

      if (savedUID != null && savedUID.isNotEmpty && savedPersonExists) {
        // Restore ONLY the PERSON — not game progress
        personLoaded = await loadPerson(ref: ref);
      }

      // ------------------------------------------------------------------
      // 4️⃣ If person exists → reset game but show welcome back
      // ------------------------------------------------------------------
      if (personLoaded) {
        // Start game fresh (no previous level, cash, animals, loans)
        ref.read(gameDataNotifierProvider.notifier).resetGame();

        if (mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => const WelcomeBackDialog(),
          );
        }

      } else {
        // ------------------------------------------------------------------
        // 5️⃣ If no user → force sign-in flow
        // ------------------------------------------------------------------
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
                        // LEVEL CARD
                        LevelInfoCard(
                          currentCash: ref.watch(gameDataNotifierProvider).cash,
                          levelId: levelId,
                          nextLevelCash: levels[levelId].cashGoal,
                        ),
                        const SizedBox(height: 10),

                        // OVERVIEW
                        SectionCard(
                          title: AppLocalizations.of(context)!.overview.toUpperCase(),
                          content: const OverviewContent(),
                        ),
                        const SizedBox(height: 10),

                        // ASSETS
                        SectionCard(
                          title: AppLocalizations.of(context)!.assets.toUpperCase(),
                          content: const AssetContent(),
                        ),
                        const SizedBox(height: 10),

                        // LOANS – only after Level 1
                        if (levelId > 1)
                          SectionCard(
                            title: AppLocalizations.of(context)!.loan(2).toUpperCase(),
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

        // CONFETTI CELEBRATION
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

