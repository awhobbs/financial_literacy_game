import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:financial_literacy_game/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/levels.dart';
import 'cash_indicator.dart';
import 'next_period_button.dart';
import 'section_card.dart';

// NEW: use our safe intl fallback helpers for LG/ACH
import 'package:financial_literacy_game/l10n/intl_fallback.dart';

class LevelInfoCard extends ConsumerWidget {
  const LevelInfoCard({
    super.key,
    required this.levelId,
    required this.currentCash,
    required this.nextLevelCash,
  });

  final int levelId;
  final double currentCash;
  final double nextLevelCash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final loc = ref.watch(gameDataNotifierProvider).locale;

    final convertedCurrentCash =
    ref.read(gameDataNotifierProvider.notifier).convertAmount(currentCash);
    final convertedNextLevelCash =
    ref.read(gameDataNotifierProvider.notifier).convertAmount(nextLevelCash);

    return Stack(
      children: [
        SectionCard(
          title: l10n
              .level(
            (levelId + 1),
            levels.length,
            ref.watch(gameDataNotifierProvider).period.toString(),
          )
              .capitalize(),
          content: Column(
            children: [
              // Don't pass a number into a localized formatter for LG/ACH:
              // format locally and concatenate to avoid intl "Invalid locale".
              Text(
                '${l10n.cashGoal}: ${formatUgx(convertedNextLevelCash, loc)}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette().darkText,
                ),
              ),
              const SizedBox(height: 7.5),
              Row(
                children: [
                  Text(
                    formatUgx(0, loc),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CashIndicator(
                      currentCash: convertedCurrentCash,
                      cashGoal: convertedNextLevelCash,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatUgx(convertedNextLevelCash, loc),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          top: 15.0,
          right: 15.0,
          child: NextPeriodButton(),
        ),
      ],
    );
  }
}

