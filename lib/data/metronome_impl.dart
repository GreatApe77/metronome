import 'dart:async';

import 'package:metronome/domain/disposable.dart';
import 'package:metronome/domain/metronome.dart';
import 'package:metronome/domain/tick.dart';

class MetronomeImpl implements Metronome, Disposable {
  int _bpm = 60;

  final StreamController<Tick> _metronomeStreamController =
      StreamController<Tick>.broadcast();
  Timer? _timer;
  bool _isRunning = false;
  int get bpm => _bpm;
  bool get isRunning => _isRunning;

  @override
  Future<void> dispose() async {
    if (_timer != null) {
      stop();
    }
    _metronomeStreamController.close();
  }

  @override
  void setBpm(int bpm) {
    _bpm = bpm;
  }

  @override
  void start() {
    if (_isRunning) return;
    final intervalInMs = _calculateIntervalInMs();
    _handleTick();
    _timer = Timer.periodic(
      Duration(milliseconds: intervalInMs),
      (_) => _handleTick(),
    );
    _isRunning = true;
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Stream<Tick> tickStream() => _metronomeStreamController.stream;
  int _calculateIntervalInMs() {
    return (60000 / bpm).round();
  }

  void _handleTick() {
    _metronomeStreamController.add(Tick(tickType: TickType.regular));
  }
}
