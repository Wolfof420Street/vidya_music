import 'package:flutter/material.dart';

extension ThemeModeTileExt on ThemeMode {
  String get tileLabel {
    switch (this) {
      case ThemeMode.system:
        return 'System Theme';
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
    }
  }

  IconData get tileIcon {
    switch (this) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}