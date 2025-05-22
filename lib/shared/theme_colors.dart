import 'package:flutter/material.dart';

abstract class ThemeColors {
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0x004b88a2),
    //secondary: Color(0xfe67e61),
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity
  );
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xfe67e61),
    //secondary: Color(0xfe67e61),
    brightness: Brightness.dark,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity
  );
}
