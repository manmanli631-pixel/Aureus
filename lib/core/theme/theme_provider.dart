import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';

// Provider to manage the current theme dynamically based on time of day
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_determineThemeFromTime()) {
    // Optionally, we could set up a timer to check the theme periodically if the app is left open
  }

  static ThemeData _determineThemeFromTime() {
    final hour = DateTime.now().hour;
    // Morning (6 AM - 12 PM) and Noon/Afternoon (12 PM - 6 PM) -> Light Theme
    // Night (6 PM - 6 AM) -> Dark Theme
    if (hour >= 6 && hour < 18) {
      return AppTheme.lightTheme;
    } else {
      return AppTheme.darkTheme;
    }
  }

  void refreshTheme() {
    state = _determineThemeFromTime();
  }

  // Method to allow user to force a specific theme if needed later
  void forceTheme(ThemeData theme) {
    state = theme;
  }
}
