part of 'metronome_bloc.dart';

final class MetronomeState {
  final int bpm;
  final Tick? tick;
  final bool isRunning;
  final bool accentOnFirstBeat;
  MetronomeState({
    required this.bpm,
    this.tick,
    required this.isRunning,
    required this.accentOnFirstBeat,
  });

  MetronomeState copyWith({
    int? bpm,
    Tick? tick,
    bool? isRunning,
    bool? accentOnFirstBeat,
  }) {
    return MetronomeState(
      bpm: bpm ?? this.bpm,
      tick: tick ?? this.tick,
      isRunning: isRunning ?? this.isRunning,
      accentOnFirstBeat: accentOnFirstBeat ?? this.accentOnFirstBeat,
    );
  }
}
