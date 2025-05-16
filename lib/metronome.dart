import 'package:metronome/tick.dart';

abstract interface class Metronome {
  Stream<Tick> tickStream();
}
