
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../config/color_palette.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../l10n/l10n.dart';
import '../../l10n/app_localizations.dart';

class LanguageSelectionDialog extends ConsumerStatefulWidget {
  final String title;
  final Widget? showDialogWidgetAfterPop;
  const LanguageSelectionDialog({
    required this.title,
    this.showDialogWidgetAfterPop,
    super.key,
  });

  @override
  ConsumerState<LanguageSelectionDialog> createState() => _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends ConsumerState<LanguageSelectionDialog> {
  late Locale _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(gameDataNotifierProvider).locale ?? L10n.defaultLocale;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette().backgroundContentCard,
      title: Text(widget.title, style: TextStyle(color: ColorPalette().darkText)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)?.selectLanguage ?? 'Select language',
              style: TextStyle(color: ColorPalette().darkText)),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: _selected,
                isExpanded: true,
                items: L10n.all.map((loc) {
                  final label = L10n.labelFor(loc);
                  return DropdownMenuItem<Locale>(
                    value: loc,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (loc) {
                  if (loc == null) return;
                  setState(() => _selected = loc);
                  ref.read(gameDataNotifierProvider.notifier).setLocale(loc);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette().buttonBackground,
            foregroundColor: ColorPalette().lightText,
          ),
          onPressed: () async {
            await saveLocalLocally(_selected);
            if (!mounted) return;
            Navigator.of(context).pop();
            if (widget.showDialogWidgetAfterPop != null) {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => widget.showDialogWidgetAfterPop!,
              );
            }
          },
          child: Text(AppLocalizations.of(context)?.confirm ?? 'Confirm'),
        ),
      ],
    );
  }
}
