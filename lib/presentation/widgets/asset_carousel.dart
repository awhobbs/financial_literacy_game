// lib/presentation/widgets/asset_carousel.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:financial_literacy_game/l10n/app_localizations.dart';
import 'package:financial_literacy_game/domain/utils/intl_fallback.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import '../../config/color_palette.dart';
import '../../domain/concepts/asset.dart';
import '../../domain/game_data_notifier.dart';

class AssetCarousel extends ConsumerWidget {
  final List<Asset> assets;
  final AutoSizeGroup textGroup;
  final Function changingIndex;

  const AssetCarousel({
    Key? key,
    required this.assets,
    required this.textGroup,
    required this.changingIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).toString();
    final notifier = ref.read(gameDataNotifierProvider.notifier);

    // build widget to display from asset
    final widgetList = <Widget>[];
    for (final asset in assets) {
      widgetList.add(
        LayoutBuilder(builder: (context, constraints) {
          String assetName;
          switch (asset.type) {
            case AssetType.pig:
              assetName = l10n.pig;
              break;
            case AssetType.chicken:
              assetName = l10n.chicken;
              break;
            case AssetType.goat:
              assetName = l10n.goat;
              break;
            default:
              assetName = l10n.chicken;
          }

          // format strings expected by l10n (no doubles passed directly)
          final priceStr = formatAmount(
            notifier.convertAmount(asset.price),
            localeCode,
            currency: 'UGX',
          );
          final incomeStr = formatAmount(
            notifier.convertAmount(asset.income),
            localeCode,
            currency: 'UGX',
          );

          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth * 1.2,
            decoration: BoxDecoration(
              color: ColorPalette().backgroundContentCard,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '${asset.numberOfAnimals} x $assetName',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(asset.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      l10n.price(priceStr),
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                      group: textGroup,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      l10n.incomePerYear(incomeStr),
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                      group: textGroup,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      l10n.lifeExpectancy(asset.lifeExpectancy).capitalize(),
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                      group: textGroup,
                    ),
                  ),
                  if (asset.riskLevel > 0)
                    Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        l10n
                            .lifeRisk(
                            (100 / (asset.riskLevel * 100)).toStringAsFixed(0))
                            .capitalize(),
                        style: TextStyle(
                          fontSize: 100,
                          color: Colors.grey[200],
                        ),
                        group: textGroup,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) => changingIndex(index),
      ),
      items: widgetList,
    );
  }
}
