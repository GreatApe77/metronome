import 'dart:async';

import 'package:metronome/domain/metronome.dart';
import 'package:metronome/domain/tick.dart';

class MetronomeImpl implements Metronome {
  int _bpm;
  int _beatCounter = 0;
  final int _beatsPerMeasure = 16;
  final StreamController<Tick> _metronomeStreamController =
      StreamController<Tick>.broadcast();
  Timer? _timer;
  bool _isRunning = false;
  MetronomeImpl({int bpm = 60}) : _bpm = bpm;

  @override
  int get beatsPerMeasure => _beatsPerMeasure;

  @override
  int get bpm => _bpm;

  @override
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
    if (_isRunning) {
      final intervalInMs = _calculateIntervalInMs();
      _timer?.cancel();
      _timer = null;
      _timer = Timer.periodic(
        Duration(milliseconds: intervalInMs),
        (_) => _handleTick(),
      );
    }
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
    _isRunning = false;
    _beatCounter = 0;
  }

  @override
  Stream<Tick> tickStream() => _metronomeStreamController.stream;

  int _calculateIntervalInMs() {
    return (60000 / bpm).round();
  }

  void _handleTick() {
    final int measureIndex = _beatCounter % _beatsPerMeasure;

    _metronomeStreamController.add(
      Tick(tickType: TickType.regular, measureIndex: measureIndex),
    );
    _beatCounter++;
  }

  @override
  void setBeatsPerMeasure(int beatsPerMeasure) {
    beatsPerMeasure = beatsPerMeasure;
  }
}
