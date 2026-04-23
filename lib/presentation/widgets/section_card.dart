import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final titleSize  = w >= 700 ? 24.0 : 20.0;
    final cardPad    = w >= 700 ? 22.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        color: ColorPalette().backgroundSectionCard,
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: ColorPalette().darkText,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}
