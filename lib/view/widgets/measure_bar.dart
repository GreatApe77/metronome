import 'package:flutter/material.dart';

class MeasureBar extends StatefulWidget {
  final int? currentIndex;
  final int notesPerMeasure;
  static const double _height = 15;

  const MeasureBar({
    super.key,
    this.currentIndex,
    required this.notesPerMeasure,
  });

  @override
  State<MeasureBar> createState() => _MeasureBarState();
}

class _MeasureBarState extends State<MeasureBar> {
  static const Duration _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.notesPerMeasure, (index) {
        final bool isActive = widget.currentIndex == index;
        return AnimatedContainer(
          duration: _duration,
          height: MeasureBar._height,
          width: MeasureBar._height,
          decoration: BoxDecoration(
            color:
                isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(
              isActive ? 0 : MeasureBar._height / 2,
            ),
          ),
        );
      }),
    );
  }
}
/* class MeasureBar extends StatelessWidget {
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
 */