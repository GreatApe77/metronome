import 'package:metronome/domain/tick.dart';

abstract interface class Metronome {
  int get bpm;
  bool get isRunning;
  void stop();
  void start();
  void setBpm(int bpm);
  Stream<Tick> tickStream();
}
