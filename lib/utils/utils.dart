import 'dart:io';

import 'package:easel_flutter/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

void launchAppStore() async {
  var _url = "";
  if (Platform.isAndroid) {
    _url = kPlayStoreUrl;
  } else {
    //TODO set apple appstore url here
  }
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}
