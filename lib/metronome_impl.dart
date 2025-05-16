import 'package:metronome/metronome.dart';
import 'package:metronome/tick.dart';

class MetronomeImpl implements Metronome {
  int _bpm = 200;

  // ignore: unnecessary_getters_setters
  int get bpm => _bpm;

  @override
  setBpm(int bpm) {
    _bpm = bpm;
  }

  @override
  Stream<Tick> tickStream() async* {
    final interval = 60 / bpm;
    final intervalInMs = (interval * 1000).toInt();

    while (true) {
      yield Tick(soundName: 'someSound');
      await Future.delayed(Duration(milliseconds: intervalInMs));
    }
  }
}
