import 'package:fclash/service/clash_service.dart';
import 'package:flutter/material.dart';
import 'package:kommon/kommon.dart';

class SpeedWidget extends StatelessWidget {
  const SpeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.upload),
            const SizedBox(
              width: 2.0,
            ),
            Obx(
              () => Text(
                  '${Get.find<ClashService>().uploadRate.value.toStringAsFixed(1)}KB/s'),
            ),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.download),
            const SizedBox(
              width: 2.0,
            ),
            Obx(() => Text(
                '${Get.find<ClashService>().downRate.value.toStringAsFixed(1)}KB/s')),
          ],
        ),
      ],
    ).paddingOnly(top: 12.0, right: 16.0);
  }
}
