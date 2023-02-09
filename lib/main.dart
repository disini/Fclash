import 'dart:io';

import 'package:fclash/screen/controller/theme_controller.dart';
import 'package:fclash/screen/main_screen.dart';
import 'package:fclash/service/autostart_service.dart';
import 'package:fclash/service/clash_service.dart';
import 'package:fclash/service/notification_service.dart';
import 'package:fclash/translation/clash_translation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kommon/kommon.dart';
import 'package:proxy_manager/proxy_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

final proxyManager = ProxyManager();
final isDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isDesktop) {
    await Future.wait([
      initAppService(),
      Future.microtask(() async {
        await windowManager.ensureInitialized();
        await windowManager.setPreventClose(true);
      })
    ]);
  }
  runApp(const MyApp());
  initWindow();
}

Future<void> initWindow() async {
  WindowOptions opts = const WindowOptions(
      minimumSize: Size(1024, 768),
      size: Size(1024, 768),
      titleBarStyle: TitleBarStyle.hidden);
  windowManager.waitUntilReadyToShow(opts, () {
    // hide window when start
    if (Get.find<ClashService>().isHideWindowWhenStart() && kReleaseMode) {
      if (Platform.isMacOS) {
        windowManager.minimize();
      } else {
        windowManager.hide();
      }
    }
  });
}

Future<void> initAppTray(
    {List<MenuItem>? details, bool isUpdate = false}) async {
  await trayManager.setIcon(Platform.isWindows
      ? 'assets/images/app_tray.ico'
      : 'assets/images/app_tray.png');
  List<MenuItem> items = [
    MenuItem(
      key: 'show',
      label: 'Show Fclash'.tr,
    ),
    MenuItem.separator(),
    MenuItem(
      key: 'exit',
      label: 'Exit Fclash'.tr,
    ),
  ];
  if (details != null) {
    items.insertAll(0, details);
  }
  await trayManager.setContextMenu(Menu(items: items));
}

Future<void> initAppService() async {
  await SpUtil.getInstance();
  await Get.putAsync(() => NotificationService().init());
  await Get.putAsync(() => ClashService().init());
  await Get.putAsync(() => DialogService().init());
  await Get.putAsync(() => AutostartService().init());
  Get.put(ThemeController());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = SpUtil.getData('lan', defValue: '');
    Locale? storedLocale;
    if (locale.isNotEmpty) {
      final tuple = locale.split('_');
      storedLocale = Locale(tuple[0], tuple[1]);
    }
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: ClashTranslations(),
      locale: storedLocale ?? Get.deviceLocale,
      supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Fclash',
      theme: ThemeData(
          primarySwatch: Colors.blue, fontFamily: 'nssc', useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: Get.find<ThemeController>().getThemeMode(),
      home: const MainScreen(),
    );
  }
}
