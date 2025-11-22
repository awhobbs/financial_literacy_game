import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:financial_literacy_game/l10n/app_localizations.dart';
import '../../config/color_palette.dart';
import '../../domain/concepts/loan.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/intl_fallback.dart';

class LoanContent extends ConsumerWidget {
  const LoanContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanSizeGroup = AutoSizeGroup();
    final loans = ref.watch(gameDataNotifierProvider).loans;

    final items = loans
        .map((loan) => LoanCard(loan: loan, group: loanSizeGroup))
        .toList();

    return Row(
      children: [
        Expanded(
          child: Column(children: items),
        ),
      ],
    );
  }
}

class LoanCard extends ConsumerWidget {
  const LoanCard({
    super.key,
    required this.loan,
    required this.group,
  });

  final Loan loan;
  final AutoSizeGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    // Convert numeric amounts into the player’s in-game currency
    final convertedTotal = ref
        .read(gameDataNotifierProvider.notifier)
        .convertAmount(loan.asset.price * (1 + loan.interestRate));

    final convertedPerPeriod = ref
        .read(gameDataNotifierProvider.notifier)
        .convertAmount(loan.paymentPerPeriod);

    final totalStr = l10n.cashValue(
      formatAmount(convertedTotal, locale, currency: 'UGX'),
    );
    final perPeriodStr = l10n.cashValue(
      formatAmount(convertedPerPeriod, locale, currency: 'UGX'),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: AspectRatio(
        aspectRatio: 9.0,
        child: Container(
          decoration: BoxDecoration(
            color: ColorPalette().backgroundContentCard,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(loan.asset.imagePath),
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    totalStr, // formatted string
                    maxLines: 1,
                    group: group,
                    style: TextStyle(
                      color: ColorPalette().lightText,
                      fontSize: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      perPeriodStr, // formatted string
                      maxLines: 1,
                      group: group,
                      style: TextStyle(
                        color: ColorPalette().lightText,
                        fontSize: 50.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      '${loan.age} / ${loan.termInPeriods}',
                      maxLines: 1,
                      group: group,
                      style: TextStyle(
                        color: ColorPalette().lightText,
                        fontSize: 50.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
