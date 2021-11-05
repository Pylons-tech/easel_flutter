import 'dart:developer';

import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:pylons_flutter/pylons_flutter.dart';

class RoutingScreen extends StatefulWidget {
  const RoutingScreen({Key? key}) : super(key: key);

  @override
  _RoutingScreenState createState() {
    return _RoutingScreenState();
  }
}

class _RoutingScreenState extends State<RoutingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      PylonsWallet.instance.exists().then((walletExists) {

        if(walletExists){

          navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => HomeScreen()));

        }else{
          showBottomSheet(
              context: context,
              builder: (ctx) => const AlertDialog(
                content: Text("Wallet does not exist. Please download Pylons wallet app to continue"),
          ));
        }
      });

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      body: Center(
        child: Text("Welcome to Easel"),
      ),
    );
  }
}