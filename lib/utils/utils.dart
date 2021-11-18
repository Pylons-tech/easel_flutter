import 'dart:io';

import 'package:easel_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showAlertDialog(String message, {Widget button = const SizedBox()}) {
  showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          content: Text(message),
          actions: [button],
        ),
      ));
}

void launchAppStore()async{
  if(Platform.isAndroid){
    const  _url = "https://play.google.com/store/apps/details?id=tech.pylons.wallet";
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

}