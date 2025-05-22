import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metronome/blocs/theme/theme_bloc.dart';
import 'package:metronome/shared/theme_colors.dart';
import 'package:metronome/view/pages/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Metronome',
          themeMode: state is ThemeDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.from(colorScheme: ThemeColors.darkColorScheme),
          theme: ThemeData.from(colorScheme: ThemeColors.lightColorScheme),
          home: const HomePage(),
        );
      },
    );
  }
}
