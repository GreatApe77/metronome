part of 'metronome_bloc.dart';

final class MetronomeState {
  final int bpm;
  final Tick? tick;
  final bool isRunning;
  final bool accentOnFirstBeat;
  final int beatsPerMeasure;
  MetronomeState({
    required this.bpm,
    this.tick,
    required this.isRunning,
    required this.accentOnFirstBeat,
    required this.beatsPerMeasure,
  });

  MetronomeState copyWith({
    int? bpm,
    Tick? tick,
    bool? isRunning,
    bool? accentOnFirstBeat,
    int? beatsPerMeasure,
  }) {
    return MetronomeState(
      beatsPerMeasure: beatsPerMeasure ?? this.beatsPerMeasure,
      bpm: bpm ?? this.bpm,
      tick: tick ?? this.tick,
      isRunning: isRunning ?? this.isRunning,
      accentOnFirstBeat: accentOnFirstBeat ?? this.accentOnFirstBeat,
    );
  }
}
