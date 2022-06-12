import 'package:flutter/material.dart';
import 'package:kommon/kommon.dart';

enum ThemeType { light, dark }

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  final ThemeData lightTheme = ThemeData.light();
  final ThemeData darkTheme = ThemeData.dark();

  init() async {
    isDarkMode.value = Get.theme.brightness == Brightness.dark;
  }

  changeTheme(ThemeType type) {
    switch (type) {
      case ThemeType.light:
        isDarkMode.value = false;
        Get.changeTheme(lightTheme);
        SpUtil.setData<bool>('dark_theme', false);
        break;
      case ThemeType.dark:
        isDarkMode.value = true;
        Get.changeTheme(darkTheme);
        SpUtil.setData<bool>('dark_theme', true);
        break;
    }
  }
}
