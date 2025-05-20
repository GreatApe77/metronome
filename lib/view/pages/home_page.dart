import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:metronome/shared/assets.dart';
import 'package:metronome/domain/metronome.dart';
import 'package:metronome/data/metronome_impl.dart';
import 'package:metronome/domain/tick.dart';
import 'package:metronome/view/widgets/measure_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Metronome metronome = MetronomeImpl();
  late StreamSubscription<Tick> sub;
  int? _currentBeat;
  SoLoud _soLoud = SoLoud.instance;
  @override
  void initState() {
    super.initState();
    //audioCache.fetchToMemory('metronome_tick.mp3');
    sub = metronome.tickStream().listen(_onTick);
    _initSoLoud();

    /* AudioPool.createFromAsset(
      path: Assets.tickSoundFilePath,
      maxPlayers: 200,
    ).then((value) {
      audioPool = value;
    }); */
  }

  Future<void> _initSoLoud() async {
    await _soLoud.init(bufferSize: 20);
  }

  Future<void> _playSound() async {
    try {
      final source = await _soLoud.loadAsset(
        'assets/${Assets.tickSoundFilePath}',
        mode: LoadMode.memory,
      );
      await _soLoud.play(source);
    } on SoLoudException catch (e) {
      print('Could not play audio');
      print(e.description);
    }
  }

  void _onTick(Tick metronomeTick) async {
    _playSound();
    setState(() {
      _currentBeat = metronomeTick.measureIndex;
    });
  }

  @override
  void dispose() {
    super.dispose();

    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        title: Text('Metronome'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MeasureBar(notesPerMeasure: 4, currentIndex: _currentBeat),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (metronome.bpm <= 1) return;
                      setState(() {
                        metronome.setBpm(metronome.bpm - 1);
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(
                    '${metronome.bpm}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      if (metronome.bpm >= 250) return;
                      setState(() {
                        metronome.setBpm(metronome.bpm + 1);
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Text('BPM'),
              SizedBox(height: 20),
              Slider(
                value: metronome.bpm.toDouble(),
                min: 1,
                max: 250,
                onChanged: (value) {
                  setState(() {
                    metronome.setBpm(value.toInt());
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.light_mode)),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if (metronome.isRunning) {
                          return metronome.stop();
                        }
                        metronome.start();
                      });
                    },
                    child:
                        metronome.isRunning
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.music_note)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
