import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:metronome/assets.dart';
import 'package:metronome/metronome.dart';
import 'package:metronome/metronome_impl.dart';
import 'package:metronome/tick.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tickCounter = 0;
  final Metronome metronome = MetronomeImpl();
  late StreamSubscription<Tick> sub;

  AudioPool? audioPool;

  @override
  void initState() {
    super.initState();
    //audioCache.fetchToMemory('metronome_tick.mp3');
    sub = metronome.tickStream().listen(_onTick);
    
    AudioPool.createFromAsset(
      path: Assets.tickSoundFilePath,
      maxPlayers: 30,
      minPlayers: 10,

    ).then((value) {
      audioPool = value;
    });
  }

  void _onTick(Tick metronomeTick) async {
    audioPool?.start();
    setState(() {
      _tickCounter++;
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),

            Text(
              '$_tickCounter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    metronome.start();
                  },
                  child: Text('Play'),
                ),
                TextButton(
                  onPressed: () {
                    metronome.stop();
                  },
                  child: Text('Pause'),
                ),
              ],
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              onChanged: (value) {
                metronome.setBpm(int.parse(value));
              },
              decoration: InputDecoration(label: Text('BPM')),
            ),
          ],
        ),
      ),
    );
  }
}
