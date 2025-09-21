import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:metronome/domain/audio_player.dart';
import 'package:metronome/domain/disposable.dart';
import 'package:metronome/domain/initializable.dart';

class AudioPlayerImpl implements AudioPlayer, Disposable, Initializable {
  final SoLoud _soLoud = SoLoud.instance;

  // Pre-loaded audio sources for instant playback
  AudioSource? _tickSource;
  AudioSource? _accentTickSource;

  @override
  Future<void> dispose() async {
    // AudioSource doesn't need explicit disposal
    _soLoud.deinit();
  }

  @override
  Future<void> initialize() async {
    // Use smaller buffer size for lower latency
    await _soLoud.init(bufferSize: 20);

    // Pre-load audio sources
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
        // Use fire-and-forget for lowest latency
        _soLoud.play(source);
      } else {
        // Fallback for other sounds
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
