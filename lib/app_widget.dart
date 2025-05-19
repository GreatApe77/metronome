import 'package:flutter/material.dart';
import 'package:metronome/view/pages/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
