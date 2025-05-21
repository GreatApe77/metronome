part of 'metronome_bloc.dart';

final class MetronomeState {
  final int bpm;
  final Tick? tick;
  final bool isRunning;
  MetronomeState( {required this.bpm,  this.tick, required this.isRunning});

  MetronomeState copyWith({int? bpm, Tick? tick, bool? isRunning}) {
    return MetronomeState(
      bpm: bpm ?? this.bpm,
      tick: tick ?? this.tick,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
