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

  // Animate the raw cash value (relative to cashGoal) so the bar can
  // move both left (backward) and right (forward) from the start marker.
  double _computeProgress(CashIndicator w) {
    return (w.cashGoal > 0 ? w.currentCash / w.cashGoal : 0.0).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _animBegin = _computeProgress(widget);
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
    // startRatio: where the start marker sits (0..1 of bar width)
    final startRatio = (widget.cashGoal > 0
            ? widget.startingCash / widget.cashGoal
            : 0.0)
        .clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: _animBegin, end: _animEnd),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, animatedProgress, _) {
        return LayoutBuilder(builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          final startX = barWidth * startRatio;
          final currentX = barWidth * animatedProgress;

          final isForward = currentX >= startX;
          final fillLeft = min(startX, currentX);
          final fillWidth = max(0.0, (currentX - startX).abs());
          final markerLeft = (startX - 2).clamp(0.0, barWidth - 4);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Clipped bar: track + directional fill
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: SizedBox(
                  height: 18,
                  width: barWidth,
                  child: Stack(
                    children: [
                      // Background track
                      Container(
                        height: 18,
                        color: Colors.black26,
                      ),
                      // Directional fill
                      if (fillWidth > 0)
                        Positioned(
                          left: fillLeft,
                          child: Container(
                            height: 18,
                            width: fillWidth,
                            color: isForward
                                ? ColorPalette().cashIndicator
                                : Colors.red.shade300,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Start marker — fixed vertical line at startingCash position
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
