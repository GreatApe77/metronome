enum TickType { regular, accent }

class Tick {
  final TickType tickType;
  final int measureIndex;
  Tick({required this.tickType, required this.measureIndex});
}
