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
      final range = cashGoal - startingCash;
      final progress = range > 0 ? ((currentCash - startingCash) / range).clamp(0.0, 1.0) : 0.0;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Positioned(
            top: -1.0,
            child: Container(
              height: 12,
              width:
                  max(0, min(constraints.maxWidth, constraints.maxWidth * progress)),
              decoration: BoxDecoration(
                color: ColorPalette().cashIndicator,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      );
    });
  }
}
