import 'dart:io';

import 'package:fclash/main.dart';
import 'package:fclash/screen/component/speed.dart';
import 'package:fclash/screen/controller/theme_controller.dart';
import 'package:fclash/screen/page/about.dart';
import 'package:fclash/screen/page/clash_log.dart';
import 'package:fclash/screen/page/connection.dart';
import 'package:fclash/screen/page/profile.dart';
import 'package:fclash/screen/page/proxy.dart';
import 'package:fclash/screen/page/setting.dart';
import 'package:fclash/service/clash_service.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:kommon/kommon.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with WindowListener, TrayListener {
  var index = 0.obs;
  final pages = const [
    Proxy(),
    Profile(),
    Setting(),
    Connections(),
    ClashLog(),
    AboutPage()
  ];

  @override
  void onWindowClose() {
    super.onWindowClose();
    if (Platform.isMacOS) {
      windowManager.minimize();
    } else {
      windowManager.hide();
    }
  }

  @override
  void onTrayIconMouseDown() {
    // windowManager.focus();
    windowManager.show();
  }

  @override
  void onTrayIconRightMouseDown() {
    super.onTrayIconRightMouseDown();
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'exit':
        windowManager.close().then((value) async {
          await Get.find<ClashService>().closeClashDaemon();
          exit(0);
        });
        break;
      case 'show':
        windowManager.focus();
        windowManager.show();
    }
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    trayManager.addListener(this);
    changeTheme();
    // ignore
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isDesktop ? _buildDesktop() : _buildMobile();
  }

  _buildMobile() {
    return SafeArea(
      child: Scaffold(
          appBar: BrnAppBar(
            title: "fclash",
          ),
          body: Column(
            children: [buildMobileOptions(), Expanded(child: buildFrame())],
          )),
    );
  }

  _buildDesktop() {
    return DragToResizeArea(
      child: Scaffold(
          body: Column(
        children: [buildDesktopOptions(), Expanded(child: buildFrame())],
      )),
    );
  }

  Widget buildDesktopOptions() {
    return GestureDetector(
      onPanStart: (_) {
        windowManager.startDragging();
      },
      child: SizedBox(
        height: 75,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const AppIcon().marginOnly(top: Platform.isMacOS ? 12.0 : 0.0),
            _buildOptions(0, 'Proxy'.tr),
            _buildOptions(1, 'Profile'.tr),
            _buildOptions(2, 'Setting'.tr),
            _buildOptions(3, 'Connections'.tr),
            _buildOptions(4, 'Log'.tr),
            _buildOptions(5, 'About'.tr),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: const SpeedWidget()),
            ),
            const WindowPanel()
          ],
        ),
      ),
    );
  }

  Widget buildMobileOptions() {
    return SizedBox(
      height: 75,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children: [
            _buildOptions(0, 'Proxy'.tr),
            _buildOptions(1, 'Profile'.tr),
            _buildOptions(2, 'Setting'.tr),
            _buildOptions(3, 'Connections'.tr),
            _buildOptions(4, 'Log'.tr),
            _buildOptions(5, 'About'.tr),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(int index, String title) {
    return InkWell(
      onTap: () {
        this.index.value = index;
      },
      child: Obx(
        () => Opacity(
          opacity: index == this.index.value ? 1.0 : 0.5,
          child: Container(
            // decoration: BoxDecoration(
            //     color: index == this.index.value ? Colors.white : Colors.white12),
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFrame() {
    return Obx(
      () => pages[index.value],
    );
  }

  void changeTheme() {
    Future.delayed(Duration.zero, () {
      final isDark = SpUtil.getData<bool>('dark_theme', defValue: false);
      Get.find<ThemeController>()
          .changeTheme(isDark ? ThemeType.dark : ThemeType.light);
    });
  }
}

class WindowPanel extends StatelessWidget {
  const WindowPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Ink(
            child: InkWell(
                onTap: () {
                  windowManager.minimize();
                },
                child: const Icon(Icons.minimize).paddingAll(8.0))),
        Ink(
            child: InkWell(
                onTap: () async {
                  if (await windowManager.isMaximized()) {
                    windowManager.unmaximize();
                  } else {
                    windowManager.maximize();
                  }
                },
                child: const Icon(Icons.rectangle_outlined).paddingAll(8.0))),
        Ink(
            child: InkWell(
                onTap: () {
                  windowManager.close();
                },
                child: const Icon(Icons.close).paddingAll(8.0))),
      ],
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: const CircleAvatar(
        foregroundImage: AssetImage("assets/images/app_tray.png"),
        radius: 20,
      ),
    );
  }
}
