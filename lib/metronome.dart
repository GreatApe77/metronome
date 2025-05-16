import 'package:metronome/tick.dart';

abstract interface class Metronome {
  setBpm(int bpm);
  Stream<Tick> tickStream();
}
