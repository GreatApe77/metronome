import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:metronome/domain/audio_player.dart';
import 'package:metronome/domain/metronome.dart';
import 'package:metronome/domain/tick.dart';

part 'metronome_event.dart';
part 'metronome_state.dart';

class MetronomeBloc extends Bloc<MetronomeEvent, MetronomeState> {
  final Metronome _metronome;
  final AudioPlayer _audioPlayer;
  late StreamSubscription<Tick> _tickStreamSub;
  MetronomeBloc({
    required Metronome metronome,
    required AudioPlayer audioPlayer,
  }) : _audioPlayer = audioPlayer,
       _metronome = metronome,
       super(MetronomeInitial()) {
    _tickStreamSub = _metronome.tickStream().listen((event) {
      
    });

    on<MetronomePlayed>((event, emit) {});
  }
}
