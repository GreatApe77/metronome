import 'package:metronome/domain/disposable.dart';
import 'package:metronome/domain/tick.dart';

abstract interface class Metronome implements Disposable {
  int get bpm;
  bool get isRunning;
  int get beatsPerMeasure;
  void stop();
  void start();
  void setBpm(int bpm);
  Stream<Tick> tickStream();
}
