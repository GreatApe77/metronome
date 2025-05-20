part of 'metronome_bloc.dart';

sealed class MetronomeEvent {}

class MetronomePaused extends MetronomeEvent {}

class MetronomePlayed extends MetronomeEvent {}

class MetronomeBpmChanged extends MetronomeEvent {}
