import 'package:fclash/screen/controller/theme_controller.dart';
import 'package:fclash/service/clash_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kommon/kommon.dart';

class Proxy extends StatefulWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  State<Proxy> createState() => _ProxyState();
}

class _ProxyState extends State<Proxy> {
  ClashService get service => Get.find<ClashService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Get.find<ClashService>();
    return Container(
      child: Stack(
        children: [
          Opacity(
              opacity: 0.4,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    "assets/images/network.png",
                    width: 300,
                  ))),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => BrnNoticeBar(
                  content: 'Current using'
                      .trParams({"name": cs.currentYaml.value}))),
              Obx(() => BrnNoticeBar(
                    noticeStyle: cs.isSystemProxyObs.value
                        ? NoticeStyles.succeedWithArrow
                        : NoticeStyles.warningWithArrow,
                    content: cs.isSystemProxyObs.value
                        ? "Fclash is running as system proxy now. Enjoy.".tr
                        : 'Fclash is not set as system proxy. Software may not automatically use Fclash proxy.'
                            .tr,
                    rightWidget: cs.isSystemProxyObs.value
                        ? Offstage()
                        : TextButton(
                            onPressed: () {
                              cs.setSystemProxy();
                            },
                            child: Text("set Fclash as system proxy".tr)),
                  )),
              Expanded(child: Obx(() => buildTiles()))
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTiles() {
    final c = Get.find<ClashService>().proxies;
    if (c.value == null) {
      return BrnAbnormalStateWidget(
        title: 'No Proxies'.tr,
        content: 'Select a profile to show proxies.',
      );
    }
    Map<String, dynamic> maps = c.value['proxies'] ?? {};
    printInfo(info: 'proxies: ${maps.toString()}');

    final selectors = maps.keys.where((proxy) {
      return maps[proxy]['type'] == 'Selector';
    }).toList(growable: false);

    return ListView.builder(
      itemBuilder: (context, index) {
        final selectorName = selectors[index];
        return buildSelector(maps[selectorName]);
      },
      itemCount: selectors.length,
    );
  }

  Widget buildSelector(Map<String, dynamic> selector) {
    final proxyName = selector['name'];
    return Stack(
      children: [
        Obx(
          () => BrnExpandableGroup(
            title: proxyName ?? "",
            subtitle: selector['now'],
            themeData: BrnFormItemConfig(
              headTitleTextStyle: BrnTextStyle(
                  color: Get.find<ThemeController>().isDarkMode.value
                      ? Colors.white70
                      : Colors.black87),
              titleTextStyle: BrnTextStyle(fontSize: 20),
              subTitleTextStyle: BrnTextStyle(fontSize: 18),
              // backgroundColor: Get.find<ThemeController>().isDarkMode.value
              //     ? Colors.black12
              //     : Colors.white
            ),
            backgroundColor: Get.find<ThemeController>().isDarkMode.value
                ? Colors.black12
                : Colors.white,
            children: [
              Row(
                children: [
                  Expanded(child: buildSelectItem(selector)),
                ],
              ).paddingSymmetric(horizontal: 4.0),
              // for debug
              // kDebugMode ? BrnExpandableText(text: selector.toString(),maxLines: 1,textStyle: TextStyle(fontSize: 20,
              // color: Colors.black),) : Offstage(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
              onPressed: () async {
                List<dynamic> allItem = selector['all'];
                Future.delayed(Duration.zero, () {
                  BrnToast.show('Start test, please wait.'.tr, context);
                });
                await Get.find<ClashService>().testAllProxies(allItem);
                Future.delayed(Duration.zero, () {
                  BrnToast.show('Test complete.'.tr, context);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Test Delay".tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
        )
      ],
    );
  }

  Widget buildSelectItem(Map<String, dynamic> selector) {
    final selectName = selector['name'];
    final now = selector['now'];
    List<dynamic> allItems = selector['all'];
    var index = 0;
    return Obx(
      () => Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: allItems.map((itemName) {
          final delayInMs = service.proxyStatus[itemName.toString()] ?? 0;
          return SizedBox(
            width: 300,
            child: Card(
              // padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Container(
                      width: 12,
                      height: 50,
                      decoration: BoxDecoration(
                          color: delayInMs < 0
                              ? Colors.red
                              : delayInMs == 0
                                  ? Colors.grey
                                  : delayInMs <= 100
                                      ? Colors.green
                                      : delayInMs <= 500
                                          ? Colors.lightBlue
                                          : delayInMs <= 1000
                                              ? Colors.blue
                                              : Colors.red,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)))),
                  Expanded(
                    child: BrnRadioButton(
                        radioIndex: index++,
                        behavior: HitTestBehavior.opaque,
                        mainAxisSize: MainAxisSize.max,
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Tooltip(
                                  message: itemName.toString(),
                                  child: Text(
                                    itemName,
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // ping
                              Text(
                                "${delayInMs == 0 ? '' : '${delayInMs}ms'}",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ).marginOnly(right: 4.0)
                            ],
                          ),
                        ),
                        onValueChangedAtIndex: (newIndex, value) {
                          Get.find<ClashService>()
                              .changeProxy(selectName, allItems[newIndex])
                              .then((res) {
                            if (res) {
                              BrnToast.show(
                                  'switch to name success.'.trParams(
                                      {"name": "${allItems[newIndex]}"}),
                                  context);
                            } else {
                              BrnToast.show(
                                  'switch to name failed.'.trParams(
                                      {"name": "${allItems[newIndex]}"}),
                                  context);
                            }
                          });
                        },
                        isSelected: itemName == now),
                  ),
                ],
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}
