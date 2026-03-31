import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/color_palette.dart';

class CashIndicator extends StatelessWidget {
  final double currentCash;
  final double cashGoal;
  final double startingCash;

  const CashIndicator({
    super.key,
    required this.currentCash,
    required this.cashGoal,
    this.startingCash = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Progress goes from 0 (at startingCash) to 1.0 (at cashGoal)
      final gained = currentCash - startingCash;
      final range = cashGoal - startingCash;
      final progress = (range > 0 ? (gained / range) : 0.0).clamp(0.0, 1.0);
      final fillWidth = max(0.0, constraints.maxWidth * progress);
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Container(
            height: 14,
            width: fillWidth,
            decoration: BoxDecoration(
              color: ColorPalette().cashIndicator,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ],
      );
    });
  }
}
