import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:flutter/material.dart';

import 'how_to_play_dialog.dart';
import 'menu_dialog.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuDialog(
      title: 'Settings',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) {
                  return const HowToPlayDialog();
                },
              );
            },
            child: const Text('How to play'),
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     elevation: 5.0,
          //     backgroundColor: ColorPalette().buttonBackground,
          //     foregroundColor: ColorPalette().lightText,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         return const LanguageSelectionDialog();
          //       },
          //     );
          //   },
          //   child: const Text('Languages'),
          // ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     elevation: 5.0,
          //     backgroundColor: ColorPalette().buttonBackground,
          //     foregroundColor: ColorPalette().lightText,
          //   ),
          //   onPressed: () {},
          //   child: const Text('Restart Game'),
          // ),
        ],
      ),
    );
  }
}
