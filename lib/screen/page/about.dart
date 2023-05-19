import 'package:flutter/material.dart';
import 'package:kommon/kommon.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              LaunchUtils.openUrl("https://github.com/fclash/fclash");
            },
            child: Text(
              "Fclash - a clash proxy fronted by Flutter".tr,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Text(
            "version:".trParams({"version": '1.4.0'}),
            style: const TextStyle(fontFamily: 'nssc'),
          ),
        ],
      ),
    );
  }
}
