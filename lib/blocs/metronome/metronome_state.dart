part of 'metronome_bloc.dart';

sealed class MetronomeState {}

final class MetronomeInitial extends MetronomeState {}

final class MetronomeBeat extends MetronomeState {}

final class MetronomePause extends MetronomeState {}

final class MetronomeStart extends MetronomeState {}
