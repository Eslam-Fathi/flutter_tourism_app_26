import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      // If system, explicitly set based on current brightness
      // We don't have context here, so toggle to dark by default if they explicitly press toggle from system
      state = ThemeMode.dark; 
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}
