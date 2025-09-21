import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:metronome/domain/audio_player.dart';
import 'package:metronome/domain/disposable.dart';
import 'package:metronome/domain/initializable.dart';

class AudioPlayerImpl implements AudioPlayer, Disposable, Initializable {
  final SoLoud _soLoud = SoLoud.instance;

  AudioSource? _tickSource;
  AudioSource? _accentTickSource;

  @override
  Future<void> dispose() async {
    _soLoud.deinit();
  }

  @override
  Future<void> initialize() async {
    await _soLoud.init(bufferSize: 20);
    try {
      _tickSource = await _soLoud.loadAsset(
        'assets/tick.wav',
        mode: LoadMode.memory,
      );
      _accentTickSource = await _soLoud.loadAsset(
        'assets/accent_tick.wav',
        mode: LoadMode.memory,
      );
    } on SoLoudException catch (e) {
      print('Error loading audio sources: $e');
    }
  }

  @override
  Future<void> playAudio(String soundFilePath) async {
    try {
      AudioSource? source;
      if (soundFilePath == 'tick.wav' && _tickSource != null) {
        source = _tickSource!;
      } else if (soundFilePath == 'accent_tick.wav' &&
          _accentTickSource != null) {
        source = _accentTickSource!;
      }

      if (source != null) {
        _soLoud.play(source);
      } else {
        final loadedSource = await _soLoud.loadAsset(
          'assets/$soundFilePath',
          mode: LoadMode.memory,
        );
        _soLoud.play(loadedSource);
      }
    } on SoLoudException catch (e) {
      print('Error playing audio: $e');
    }
  }
}
