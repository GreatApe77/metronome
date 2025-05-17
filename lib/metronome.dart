import 'package:metronome/tick.dart';

abstract interface class Metronome {
  void stop();
  void start();
  setBpm(int bpm);
  Stream<Tick> tickStream();
}
