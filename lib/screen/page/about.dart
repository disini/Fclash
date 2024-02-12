import 'package:fclash/service/clash_service.dart';
import 'package:flutter/material.dart';
import 'package:kommon/kommon.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: CircleAvatar(
              foregroundImage: AssetImage("assets/images/app_tray.png"),
              radius: 100,
            ),
          ),
          TextButton(
            onPressed: () {
              LaunchUtils.openUrl("https://github.com/Kingtous/Fclash");
            },
            child: Text(
              "Fclash - a clash proxy fronted by Flutter".tr,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Text(
            "version:".trParams({
              "version": '1.4.4 (${Get.find<ClashService>().getCoreVersion()})'
            }),
            style: const TextStyle(fontFamily: 'nssc'),
          ),
          TextButton(
              onPressed: () {
                LaunchUtils.openUrl(
                    "https://github.com/Kingtous/Fclash/actions");
              },
              child: Text("check for update".tr)),
          const Divider(
            thickness: 1.0,
          ),
          Text("Author:".trParams({"name": "Kingtous"})),
          TextButton(
              onPressed: () {
                LaunchUtils.openUrl("https://github.com/Kingtous");
              },
              child: Text("View me at Github".tr))
        ],
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
