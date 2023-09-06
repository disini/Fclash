import 'dart:async';
import 'dart:convert';

import 'package:fclash/service/clash_service.dart';
import 'package:flutter/material.dart';
import 'package:kommon/kommon.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ClashLog extends StatefulWidget {
  const ClashLog({Key? key}) : super(key: key);

  @override
  State<ClashLog> createState() => _ClashLogState();
}

class _ClashLogState extends State<ClashLog>
    with AutomaticKeepAliveClientMixin {
  final logs = RxList<String>();
  final buffer = List<String>.empty(growable: true);
  late Timer? _timer;
  final connected = false.obs;
  static const logMaxLen = 100;
  StreamSubscription<dynamic>? streamSubscription;

  @override
  void initState() {
    super.initState();
    startService();
  }

  void tryConnect() {
    debugPrint('try connect');
    Get.find<ClashService>().startLogging();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (buffer.isNotEmpty) {
        logs.addAll(buffer);
        if (logs.length > logMaxLen) {
          logs.value = logs.sublist(logs.length - logMaxLen, logs.length);
        }
      }
    });
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (streamSubscription == null) {
        if (Get.find<ClashService>().logStream == null) {
          printInfo(info: 'clash log stream not opened');
        }
        streamSubscription =
            Get.find<ClashService>().logStream?.listen((event) {
          String logStr = event;
          buffer.add(logStr);
          Get.printInfo(info: 'Log widget: $logStr');
        });
        if (streamSubscription == null) {
          printInfo(info: 'log service retry');
        } else {
          printInfo(info: 'log service connected'.tr);
          connected.value = true;
        }
      } else {
        connected.value = true;
        timer.cancel();
      }
    });
  }

  void startService() {
    tryConnect();
  }

  void stopService() {
    Get.find<ClashService>().stopLog();
    streamSubscription?.cancel();
    _timer?.cancel();
  }

  @override
  void dispose() {
    Get.printInfo(info: 'log dispose');
    stopService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          // Obx(
          //   () => BrnNoticeBar(
          //     content: connected.value
          //         ? 'Log is running. Any logs will show below.'.tr
          //         : "No Logs currently / Connecting to clash log daemon...".tr,
          //     showLeftIcon: true,
          //     showRightIcon: true,
          //     noticeStyle: connected.value
          //         ? NoticeStyles.succeedWithArrow
          //         : NoticeStyles.runningWithArrow,
          //   ),
          // ),
          // Text(logs.length.toString()),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemBuilder: (cxt, index) {
                    return Padding(
                      key: ValueKey(logs[logs.length - index - 1]),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: buildLogItem(logs[logs.length - index - 1]),
                    );
                  },
                  itemCount: logs.length,
                  itemExtent: 35.0,
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Clear all logs'.tr,
        onPressed: () {
          logs.clear();
        },
        child: const Icon(Icons.cleaning_services_rounded),
      ),
    );
  }

  Widget buildLogItem(String log) {
    final json = jsonDecode(log) ?? {};
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey.shade200),
      child: Stack(
        children: [
          Text(
            json['Payload'] ?? "",
            style: const TextStyle(fontFamily: 'nssc'),
          ),
          Align(
            alignment: Alignment.topRight,
            child: BrnStateTag(tagText: '${json['LogLevel']}'),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
