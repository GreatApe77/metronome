import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metronome/blocs/theme/theme_bloc.dart';
import 'package:metronome/view/pages/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Metronome',
          themeMode: state is ThemeDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          home: const HomePage(),
        );
      },
    );
  }
}
