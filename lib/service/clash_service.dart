import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:dio/dio.dart';
import 'package:fclash/bean/clash_config_entity.dart';
import 'package:fclash/generated_bindings.dart';
import 'package:fclash/main.dart';
import 'package:fclash/service/notification_service.dart';
import 'package:flutter/services.dart';
import 'package:kommon/kommon.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:ffi/ffi.dart';

late NativeLibrary clashFFI;

class ClashService extends GetxService with TrayListener {
  // 需要一起改端口
  static const clashBaseUrl = "http://127.0.0.1:$clashExtPort";
  static const clashExtPort = 22345;

  // 运行时
  late Directory _clashDirectory;

  // 流量
  final uploadRate = 0.0.obs;
  final downRate = 0.0.obs;
  final yamlConfigs = RxList<FileSystemEntity>.empty(growable: true);
  final currentYaml = 'config.yaml'.obs;

  // action
  static const ACTION_SET_SYSTEM_PROXY = "assr";
  static const ACTION_UNSET_SYSTEM_PROXY = "ausr";
  static const MAX_ENTRIES = 5;

  // default port
  static var initializedHttpPort = 0;
  static var initializedSockPort = 0;
  static var initializedMixedPort = 0;

  // config
  Rx<ClashConfigEntity?> configEntity = Rx(null);

  // log
  Stream<List<int>>? logStream;
  RxMap<String, dynamic> proxies = RxMap();
  RxBool isSystemProxyObs = RxBool(false);

  Future<bool> isRunning() async {
    try {
      final resp = await Request.get(clashBaseUrl,
          options: Options(sendTimeout: 1000, receiveTimeout: 1000));
      if ('clash' == resp['hello']) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  ClashService() {
    // load lib
    final lib = ffi.DynamicLibrary.open(
        "/opt/apps/cn.kingtous.fclash/files/lib/libclash.so");
    clashFFI = NativeLibrary(lib);
  }

  Future<ClashService> init() async {
    // init config yaml
    final _ = SpUtil.getData('yaml', defValue: currentYaml.value);
    initializedHttpPort = SpUtil.getData('http-port', defValue: 12346);
    initializedSockPort = SpUtil.getData('socks-port', defValue: 12347);
    initializedMixedPort = SpUtil.getData('mixed-port', defValue: 12348);
    currentYaml.value = _;
    Request.setBaseUrl(clashBaseUrl);
    // init clash
    // kill all other clash clients
    _clashDirectory = await getApplicationSupportDirectory();
    _clashDirectory =
        Directory.fromUri(Uri.parse(p.join(_clashDirectory.path, "clash")));
    print("fclash work directory: ${_clashDirectory.path}");
    final clashBin = p.join(_clashDirectory.path, 'clash');
    final clashConf = p.join(_clashDirectory.path, currentYaml.value);
    final countryMMdb = p.join(_clashDirectory.path, 'Country.mmdb');
    if (!await _clashDirectory.exists()) {
      await _clashDirectory.create(recursive: true);
    }
    // copy executable to directory
    final mmdb = await rootBundle.load('assets/tp/clash/Country.mmdb');
    // write to clash dir
    final mmdbF = File(countryMMdb);
    if (!mmdbF.existsSync()) {
      await mmdbF.writeAsBytes(mmdb.buffer.asInt8List());
    }
    // ffi
    clashFFI.set_home_dir(_clashDirectory.path.toNativeUtf8().cast());
    clashFFI.clash_init(_clashDirectory.path.toNativeUtf8().cast());
    clashFFI.set_config(clashConf.toNativeUtf8().cast());
    clashFFI.set_ext_controller(clashExtPort);
    if (clashFFI.parse_options() == 0) {
      Get.printInfo(info: "parse ok");
    }
    Future.delayed(const Duration(seconds: 1), () {
      initDaemon();
    });
    // tray show issue
    trayManager.addListener(this);
    return this;
  }

  void getConfigs() {
    yamlConfigs.clear();
    _clashDirectory.list().listen((entity) {
      if (entity.path.toLowerCase().endsWith('.yaml')) {
        yamlConfigs.add(entity);
        Get.printInfo(info: 'detected: ${entity.path}');
      }
    });
  }

  Future<void> getCurrentClashConfig() async {
    configEntity.value =
        ClashConfigEntity.fromJson(await Request.get('/configs'));
  }

  Future<void> reload() async {
    // get configs
    getConfigs();
    await getCurrentClashConfig();
    // proxies
    await getProxies();
    updateTray();
  }

  void initDaemon() async {
    printInfo(info: 'init clash service');
    // get traffic
    getTraffic().then((value) {
      if (value != null) {
        Get.printInfo(info: 'connected to traffic');
        value.listen((event) {
          final msg = String.fromCharCodes(event);
          try {
            final trafficJson = jsonDecode(msg);
            Get.printInfo(info: '[traffic]: $msg');
            uploadRate.value = trafficJson['up'].toDouble() / 1024; // KB
            downRate.value = trafficJson['down'].toDouble() / 1024; // KB
            // fix: 只有KDE不会导致Tray自动消失
            // final desktop = Platform.environment['XDG_CURRENT_DESKTOP'];
            // updateTray();
          } catch (e) {
            Get.printError(info: '$e');
          }
        });
      }
    });
    _getLog().then((stream) {
      logStream = stream?.asBroadcastStream();
      if (logStream == null) {
        printError(info: 'log stream opened failed!');
      } else {
        print("log stream opened success");
      }
      logStream?.listen((event) {
        Get.printInfo(info: '[LOG]: ${utf8.decode(event)}');
      });
    });
    // daemon
    Timer.periodic(const Duration(seconds: 1), (timer) {
      isRunning().then((value) {
        if (!value) {
          timer.cancel();
          // try to start clash backend again
          init();
        }
      });
      isSystemProxyObs.value = isSystemProxy();
    });
    // system proxy
    // listen port
    await reload();
    await checkPort();
    if (isSystemProxy()) {
      setSystemProxy();
    }
    // listener
    trayManager.addListener(this);
  }

  @override
  void onClose() {
    closeClashDaemon();
    super.onClose();
  }

  void closeClashDaemon() {
    Get.printInfo(info: 'fclash: closing daemon');
    // double check
    // stopClashSubP();
    if (isSystemProxy()) {
      clearSystemProxy();
    }
  }

  Future<void> getProxies() async {
    final proxies = await Request.get('/proxies');
    this.proxies.value = proxies;
  }

  Future<Stream<Uint8List>?> getTraffic() async {
    Response<ResponseBody> resp = await Request.dioClient
        .get('/traffic', options: Options(responseType: ResponseType.stream));
    return resp.data?.stream;
  }

  /// TODO blocking
  Future<Stream<Uint8List>?> _getLog({String type = "info"}) async {
    Response<ResponseBody> resp = await Request.dioClient.get('/logs',
        options: Options(responseType: ResponseType.stream),
        queryParameters: {"level": type});
    return resp.data?.stream;
  }

  Future<bool> _changeConfig(FileSystemEntity config) async {
    // judge valid
    if (clashFFI.is_config_valid(config.path.toNativeUtf8().cast()) == 0) {
      final resp = await Request.dioClient.put('/configs',
          queryParameters: {"force": false}, data: {"path": config.path});
      Get.printInfo(info: 'config changed ret: ${resp.statusCode}');
      currentYaml.value = basename(config.path);
      SpUtil.setData('yaml', currentYaml.value);
      return resp.statusCode == 204;
    } else {
      Future.delayed(Duration.zero, () {
        Get.defaultDialog(
            middleText: 'not a valid config file'.tr,
            onConfirm: () {
              Get.back();
            });
      });
      config.delete();
      return false;
    }
  }

  Future<bool> changeYaml(FileSystemEntity config) async {
    try {
      if (await config.exists()) {
        return await _changeConfig(config);
      } else {
        return false;
      }
    } finally {
      reload();
    }
  }

  Future<bool> changeProxy(selectName, String proxyName) async {
    final resp = await Request.dioClient
        .put('/proxies/$selectName', data: {"name": proxyName});
    if (resp.statusCode == 204) {
      reload();
    }
    return resp.statusCode == 204;
  }

  Future<bool> changeConfigField(String field, dynamic value) async {
    try {
      final resp =
          await Request.dioClient.patch('/configs', data: {field: value});
      SpUtil.setData(field, value);
      return resp.statusCode == 204;
    } finally {
      await getCurrentClashConfig();
      if (field.endsWith("port") && isSystemProxy()) {
        setSystemProxy();
      }
      updateTray();
    }
  }

  bool isSystemProxy() {
    return SpUtil.getData('system_proxy', defValue: false);
  }

  Future<bool> setIsSystemProxy(bool proxy) {
    return SpUtil.setData('system_proxy', proxy);
  }

  void setSystemProxy() {
    if (configEntity.value != null) {
      final entity = configEntity.value!;
      if (entity.port != 0) {
        ProxyHelper.setAsSystemProxy(
            ProxyTypes.http, '127.0.0.1', entity.port!);
        ProxyHelper.setAsSystemProxy(
            ProxyTypes.https, '127.0.0.1', entity.port!);
      }
      if (entity.socksPort != 0) {
        ProxyHelper.setAsSystemProxy(
            ProxyTypes.socks, '127.0.0.1', entity.socksPort!);
      }
      Tips.info("Configure Success!");
      setIsSystemProxy(true);
    }
  }

  void clearSystemProxy() {
    ProxyHelper.cleanSystemProxy();
    setIsSystemProxy(false);
  }

  void updateTray() {
    final stringList = List<MenuItem>.empty(growable: true);
    // yaml
    stringList
        .add(MenuItem(label: "profile: ${currentYaml.value}", disabled: true));
    // FIX: DDE menu issue
    // stringList.add(MenuItem(
    //     title: "Download speed"
    //         .trParams({"speed": " ${downRate.value.toStringAsFixed(1)}KB/s"}),
    //     disabled: true));
    // stringList.add(MenuItem(
    //     title: "Upload speed"
    //         .trParams({"speed": "${uploadRate.value.toStringAsFixed(1)}KB/s"}),
    //     disabled: true));
    // status
    if (proxies['proxies'] != null) {
      Map<String, dynamic> m = proxies['proxies'];
      m.removeWhere((key, value) => value['type'] != "Selector");
      var cnt = 0;
      for (final k in m.keys) {
        if (cnt >= ClashService.MAX_ENTRIES) {
          stringList.add(MenuItem(label: "...", disabled: true));
          break;
        }
        stringList.add(
            MenuItem(label: "${m[k]['name']}: ${m[k]['now']}", disabled: true));
        cnt += 1;
      }
    }
    // port
    if (configEntity.value != null) {
      stringList.add(
          MenuItem(label: 'http: ${configEntity.value?.port}', disabled: true));
      stringList.add(MenuItem(
          label: 'socks: ${configEntity.value?.socksPort}', disabled: true));
    }
    // system proxy
    stringList.add(MenuItem.separator());
    if (!isSystemProxy()) {
      stringList
          .add(MenuItem(label: "Not system proxy yet.".tr, disabled: true));
      stringList.add(MenuItem(
          label: "Set as system proxy".tr,
          toolTip: "click to set fclash as system proxy".tr,
          key: ACTION_SET_SYSTEM_PROXY));
    } else {
      stringList.add(MenuItem(label: "System proxy now.".tr, disabled: true));
      stringList.add(MenuItem(
          label: "Unset system proxy".tr,
          toolTip: "click to reset system proxy",
          key: ACTION_UNSET_SYSTEM_PROXY));
      stringList.add(MenuItem.separator());
    }
    initAppTray(details: stringList, isUpdate: true);
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case ACTION_SET_SYSTEM_PROXY:
        setSystemProxy();
        reload();
        break;
      case ACTION_UNSET_SYSTEM_PROXY:
        clearSystemProxy();
        reload();
        break;
    }
  }

  Future<bool> addProfile(String name, String url) async {
    final configName = '$name.yaml';
    final newProfilePath = join(_clashDirectory.path, configName);
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        return false;
      }
      final resp =
          await Dio(BaseOptions(sendTimeout: 15000, receiveTimeout: 15000))
              .downloadUri(uri, newProfilePath, onReceiveProgress: (i, t) {
        Get.printInfo(info: "$i/$t");
      });
      return resp.statusCode == 200;
    } catch (e) {
      BrnToast.show("Error: ${e}", Get.context!);
    } finally {
      final f = File(newProfilePath);
      if (f.existsSync() && await changeYaml(f)) {
        // set subscription
        await SpUtil.setData('profile_$name', url);
        return true;
      }
      return false;
    }
  }

  Future<bool> deleteProfile(FileSystemEntity config) async {
    if (config.existsSync()) {
      config.deleteSync();
      await SpUtil.remove('profile_${basename(config.path)}');
      reload();
      return true;
    } else {
      return false;
    }
  }

  Future<void> checkPort() async {
    if (configEntity.value != null) {
      if (configEntity.value!.port == 0) {
        await changeConfigField('port', initializedHttpPort);
      }
      if (configEntity.value!.mixedPort == 0) {
        await changeConfigField('mixed-port', initializedMixedPort);
      }
      if (configEntity.value!.socksPort == 0) {
        await changeConfigField('socks-port', initializedSockPort);
      }
    }
  }

  Future<dynamic> delay(String proxyName,
      {int timeout = 5000, String url = "https://www.google.com"}) async {
    final resp = await Request.dioClient.get('/proxies/$proxyName/delay',
        queryParameters: {"timeout": timeout, "url": url});
    final data = jsonDecode(resp.data);
    if (data['message'] != null) {
      return data['message'];
    }
    return data['delay'] ?? -1;
  }

  /// yaml: test
  String getSubscriptionLinkByYaml(String yaml) {
    final url = SpUtil.getData('profile_$yaml', defValue: "");
    Get.printInfo(info: 'subs link for $yaml: $url');
    return url;
  }

  /// stop clash by ps -A
  /// ps -A | grep '[^f]clash' | awk '{print $1}' | xargs
  ///
  /// notice: is a double check in client mode
  // void stopClashSubP() {
  //   final res = Process.runSync("ps", [
  //     "-A",
  //     "|",
  //     "grep",
  //     "'[^f]clash'",
  //     "|",
  //     "awk",
  //     "'print \$1'",
  //     "|",
  //     "xrgs",
  //   ]);
  //   final clashPids = res.stdout.toString().split(" ");
  //   for (final pid in clashPids) {
  //     final pidInt = int.tryParse(pid);
  //     if (pidInt != null) {
  //       Process.killPid(int.parse(pid));
  //     }
  //   }
  // }

  Future<bool> updateSubscription(String name) async {
    final configName = '$name.yaml';
    final newProfilePath = join(_clashDirectory.path, configName);
    final url = SpUtil.getData('profile_$name');
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        return false;
      }
      // delete exists
      final f = File(newProfilePath);
      final tmpF = File('$newProfilePath.tmp');

      final resp =
          await Dio(BaseOptions(sendTimeout: 15000, receiveTimeout: 15000))
              .downloadUri(uri, tmpF.path, onReceiveProgress: (i, t) {
        Get.printInfo(info: "$i/$t");
      }).catchError((e) {
        if (tmpF.existsSync()) {
          tmpF.deleteSync();
        }
      });
      if (resp.statusCode == 200) {
        if (f.existsSync()) {
          f.deleteSync();
        }
        tmpF.renameSync(f.path);
      }
      // set subscription
      await SpUtil.setData('profile_$name', url);
      return resp.statusCode == 200;
    } finally {
      final f = File(newProfilePath);
      if (f.existsSync()) {
        await changeYaml(f);
      }
    }
  }

  bool isHideWindowWhenStart() {
    return SpUtil.getData('boot_window_hide', defValue: false);
  }

  Future<bool> setHideWindowWhenStart(bool hide) {
    return SpUtil.setData('boot_window_hide', hide);
  }

  void handleSignal() {
    StreamSubscription? subTerm;
    subTerm = ProcessSignal.sigterm.watch().listen((event) {
      subTerm?.cancel();
      // _clashProcess?.kill();
    });
  }
}
