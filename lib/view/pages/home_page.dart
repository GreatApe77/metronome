import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metronome/blocs/metronome/metronome_bloc.dart';
import 'package:metronome/blocs/theme/theme_bloc.dart';

import 'package:metronome/view/widgets/measure_bar.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late StreamSubscription<MetronomeState> sub;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      sub = context.read<MetronomeBloc>().stream.listen((event) {
        if (event.isRunning) {
          WakelockPlus.enable();
        } else {
          WakelockPlus.disable();
        }
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      context.read<MetronomeBloc>().add(MetronomePaused());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<MetronomeBloc, MetronomeState>(
                buildWhen:
                    (previous, current) =>
                        previous.tick?.measureIndex !=
                        current.tick?.measureIndex,
                builder: (context, state) {
                  return MeasureBar(
                    notesPerMeasure: 4,
                    currentIndex: state.tick?.measureIndex,
                  );
                },
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<MetronomeBloc>().add(
                        MetronomeBpmDecremented(),
                      );
                    },
                    icon: Icon(Icons.remove),
                  ),
                  BlocBuilder<MetronomeBloc, MetronomeState>(
                    builder: (context, state) {
                      return Text(
                        '${state.bpm}',
                        style: Theme.of(context).textTheme.displayLarge,
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<MetronomeBloc>().add(
                        MetronomeBpmIncremented(),
                      );
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Text('BPM'),
              SizedBox(height: 20),
              BlocBuilder<MetronomeBloc, MetronomeState>(
                buildWhen: (previous, current) => previous.bpm != current.bpm,
                builder: (context, state) {
                  return Slider(
                    value: state.bpm.toDouble(),
                    min: 1,
                    max: 350,
                    onChanged: (value) {
                      context.read<MetronomeBloc>().add(
                        MetronomeBpmChanged(bpm: value.round()),
                      );
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed:
                            () => context.read<ThemeBloc>().add(ThemeToggled()),
                        icon: Icon(
                          state is ThemeDark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                      );
                    },
                  ),
                  BlocBuilder<MetronomeBloc, MetronomeState>(
                    builder: (context, state) {
                      return FloatingActionButton(
                        onPressed: () {
                          if (state.isRunning) {
                            context.read<MetronomeBloc>().add(
                              MetronomePaused(),
                            );
                            return;
                          }
                          context.read<MetronomeBloc>().add(MetronomePlayed());
                        },
                        child:
                            state.isRunning
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_arrow),
                      );
                    },
                  ),
                  BlocBuilder<MetronomeBloc, MetronomeState>(
                    buildWhen:
                        (previous, current) =>
                            previous.accentOnFirstBeat !=
                            current.accentOnFirstBeat,
                    builder: (context, state) {
                      return Switch(
                        value: state.accentOnFirstBeat,
                        onChanged: (value) {
                          context.read<MetronomeBloc>().add(
                            MetronomeAccentFirstBeatToggled(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
