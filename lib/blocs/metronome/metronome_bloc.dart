import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:metronome/domain/audio_player.dart';
import 'package:metronome/domain/metronome.dart';
import 'package:metronome/domain/tick.dart';
import 'package:metronome/shared/assets.dart';

part 'metronome_event.dart';
part 'metronome_state.dart';

class MetronomeBloc extends Bloc<MetronomeEvent, MetronomeState> {
  final Metronome _metronome;
  final AudioPlayer _audioPlayer;
  late StreamSubscription<Tick> _tickStreamSub;
  MetronomeBloc({
    required Metronome metronome,
    required AudioPlayer audioPlayer,
  })  : _audioPlayer = audioPlayer,
        _metronome = metronome,
        super(
          MetronomeState(
            bpm: metronome.bpm,
            isRunning: metronome.isRunning,
            accentOnFirstBeat: true,
          ),
        ) {
    _tickStreamSub = _metronome.tickStream().listen((tick) {
      add(MetronomeTicked(tick: tick));
    });
    on<MetronomeTicked>((event, emit) {
      final audioToBePlayed =
          event.tick.measureIndex == 0 && state.accentOnFirstBeat
              ? Assets.accentTickSoundFilePath
              : Assets.tickSoundFilePath;
      _audioPlayer.playAudio(audioToBePlayed);
      emit(state.copyWith(tick: event.tick));
    });
    on<MetronomePlayed>((event, emit) {
      _metronome.start();
      emit(state.copyWith(isRunning: _metronome.isRunning));
    });
    on<MetronomePaused>((event, emit) {
      _metronome.stop();
      emit(state.copyWith(isRunning: _metronome.isRunning));
    });
    on<MetronomeBpmChanged>((event, emit) {
      if (_isValidBpmRange(event.bpm)) {
        _metronome.setBpm(event.bpm);
        emit(state.copyWith(bpm: event.bpm));
      }
    });
    on<MetronomeBpmIncremented>((event, emit) {
      final nextBpm = _metronome.bpm + 1;
      if (_isValidBpmRange(nextBpm)) {
        _metronome.setBpm(nextBpm);

        emit(state.copyWith(bpm: nextBpm));
      }
    });
    on<MetronomeBpmDecremented>((event, emit) {
      final nextBpm = _metronome.bpm - 1;
      if (_isValidBpmRange(nextBpm)) {
        _metronome.setBpm(nextBpm);
        emit(state.copyWith(bpm: nextBpm));
      }
    });
    on<MetronomeAccentFirstBeatToggled>((event, emit) {
      emit(state.copyWith(accentOnFirstBeat: !state.accentOnFirstBeat));
    });
  }
  @override
  Future<void> close() {
    _tickStreamSub.cancel();
    return super.close();
  }

  bool _isValidBpmRange(int bpm) {
    return 1 <= bpm && bpm <= 250;
  }
}
