import 'package:flutter/material.dart';

class MeasureBar extends StatelessWidget {
  final int? currentIndex;
  final int notesPerMeasure;
  static const double _height = 15;

  const MeasureBar({
    super.key,
    this.currentIndex,
    required this.notesPerMeasure,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 2,
      children: List.generate(notesPerMeasure, (index) {
        if (currentIndex == null || currentIndex != index) {
          return Container(
            height: _height,
            width: _height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          );
        }
        return Container(
          height: _height,
          width: _height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }),
    );
  }
}
