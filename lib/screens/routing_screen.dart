
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/home_screen.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

class RoutingScreen extends StatefulWidget {
  const RoutingScreen({Key? key}) : super(key: key);

  @override
  _RoutingScreenState createState() {
    return _RoutingScreenState();
  }
}

class _RoutingScreenState extends State<RoutingScreen> {

  ValueNotifier<String> username = ValueNotifier("");

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
      final isExist = await PylonsWallet.instance.exists();
      if(isExist){

        // final response = await PylonsWallet.instance.getProfile();
        // username.value = response.data["username"] ?? "";
        Future.delayed(const Duration(seconds: 5), (){
          navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => const HomeScreen()));
        });
      }else{
        showDialog(
          context: navigatorKey.currentState!.overlay!.context,
            barrierDismissible: false,
            builder: (ctx) => WillPopScope(
              onWillPop: () => Future.value(false),
              child: const AlertDialog(
                content: Text("Pylons app does not exist. Please download Pylons app to continue"),
              ),
            ));
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            bottom: 0,
            right: 0,
            child: BackgroundWidget(),
          ),
          Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: username,
                  builder: (_, String name, __) {
                    return Text("Welcome to Easel, $name");
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}