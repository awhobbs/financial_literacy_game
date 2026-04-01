import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/color_palette.dart';

class CashIndicator extends StatefulWidget {
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
  State<CashIndicator> createState() => _CashIndicatorState();
}

class _CashIndicatorState extends State<CashIndicator> {
  double _animBegin = 0.0;
  double _animEnd = 0.0;

  double _computeProgress(CashIndicator w) {
    final gained = w.currentCash - w.startingCash;
    final range = w.cashGoal - w.startingCash;
    return (range > 0 ? gained / range : 0.0).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _animEnd = _computeProgress(widget);
  }

  @override
  void didUpdateWidget(CashIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animBegin = _computeProgress(oldWidget);
    _animEnd = _computeProgress(widget);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: _animBegin, end: _animEnd),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, animatedProgress, _) {
        return LayoutBuilder(builder: (context, constraints) {
          final fillWidth =
              max(0.0, constraints.maxWidth * animatedProgress);
          final markerLeft = fillWidth.clamp(0.0, constraints.maxWidth - 4);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background track
              Container(
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Filled portion
              Container(
                height: 18,
                width: fillWidth,
                decoration: BoxDecoration(
                  color: ColorPalette().cashIndicator,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Position marker — vertical line at fill edge
              Positioned(
                left: markerLeft,
                top: -4,
                child: Container(
                  width: 4,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}