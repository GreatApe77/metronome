import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:metronome/domain/audio_player.dart';
import 'package:metronome/domain/disposable.dart';
import 'package:metronome/domain/initializable.dart';

class AudioPlayerImpl implements AudioPlayer, Disposable, Initializable {
  final SoLoud _soLoud = SoLoud.instance;

  @override
  Future<void> dispose() async {
    _soLoud.deinit();
  }

  @override
  Future<void> initialize() async {
    await _soLoud.init(bufferSize: 20);
  }

  @override
  Future<void> playAudio(String soundFilePath) async {
    try {
      final source = await _soLoud.loadAsset(
        'assets/$soundFilePath',
        mode: LoadMode.memory,
      );
      await _soLoud.play(source);
    } on SoLoudException {}
  }
}
