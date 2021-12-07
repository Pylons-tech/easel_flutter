import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/home_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/utils.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/message_dialog.dart';
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
    Future.delayed(const Duration(seconds: 1), () {
      PylonsWallet.instance.exists().then((walletExists) async {
        if (walletExists) {
          navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (_) => HomeScreen(currentPag: 0))); 

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final isExist = await PylonsWallet.instance.exists();
      if (isExist) {
        final response = await PylonsWallet.instance.getProfile();
        if (response.success) {
          username.value = response.data["username"] ?? "";
 
          MessageDialog()
              .show("$kWelcomeToEaselText, ${response.data["username"]}",
                  button: TextButton(
                      onPressed: () {
                        navigatorKey.currentState!.push(
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Text(kOkText)));
        } else {
          MessageDialog().show("$kProfileErrorOccurredText: ${response.error}");
        }
      } else {
        MessageDialog().show(kPylonsAppNotInstalledText,
            button: TextButton(
                onPressed: () {
                  launchAppStore();
                },
                child: const Text(
                  kClickToInstallText,
                  style: TextStyle(color: EaselAppTheme.kBlue),
                )));
      } 
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      return Text("$kWelcomeToEaselText, $name");
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
