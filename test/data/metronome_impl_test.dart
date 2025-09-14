import 'package:flutter_test/flutter_test.dart';
import 'package:metronome/data/metronome_impl.dart';
import 'package:metronome/domain/metronome.dart';

void main() {
  late Metronome sut;

  setUp(() {
    sut = MetronomeImpl();
  });

  test('Should be initialized with 60 bpm and must be not running', () {
    expect(sut.bpm, 60);
    expect(sut.isRunning, isFalse);
  });
  test('Should set bpm', () {
    expect(sut.bpm, 60);
    sut.setBpm(100);
    expect(sut.bpm, 100);
  });
  test("Should start and stop the metronome", () {
    sut.start();
    expect(sut.isRunning, isTrue);
    sut.stop();
    expect(sut.isRunning, isFalse);
  });
}
