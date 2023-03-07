import 'package:flutter/material.dart';
import 'package:kommon/kommon.dart';

enum ThemeType { light, dark }

class ThemeController extends GetxController {
  bool? get isDark => SpUtil.getData<bool>("dark_theme", defValue: false);

  ThemeMode getThemeMode() {
    final darkMode = isDark;
    switch (darkMode) {
      case null:
        return ThemeMode.system;
      case true:
        return ThemeMode.dark;
      case false:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  changeTheme(ThemeType type) {
    switch (type) {
      case ThemeType.light:
        Get.changeThemeMode(ThemeMode.light);
        SpUtil.setData<bool>('dark_theme', false);
        break;
      case ThemeType.dark:
        Get.changeThemeMode(ThemeMode.dark);
        SpUtil.setData<bool>('dark_theme', true);
        break;
    }
  }
}
