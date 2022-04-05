import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/home_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/src/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:pylons_sdk/src/features/models/sdk_ipc_response.dart';

class RoutingScreen extends StatefulWidget {
  const RoutingScreen({Key? key}) : super(key: key);

  @override
  _RoutingScreenState createState() {
    return _RoutingScreenState();
  }
}

class _RoutingScreenState extends State<RoutingScreen> {
  ValueNotifier<String> username = ValueNotifier("");

  RoutingScreenState routingScreenState = RoutingScreenState.initial;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        checkConfigurations();
      },
      onFocusLost: () {
        if (!(ModalRoute.of(context)?.isCurrent ?? false) && routingScreenState != RoutingScreenState.userNameShown) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
                        return Text("$kWelcomeToEaselText $name");
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAppNotInstalledDialog() {
    MessageDialog().show(kPylonsAppNotInstalledText,
        button: TextButton(
            onPressed: () {
              PylonsWallet.instance.goToInstall();
            },
            child: const Text(
              kClickToInstallText,
              style: TextStyle(color: EaselAppTheme.kBlue),
            )));
  }

  void showCreateAnAccountDialog(SDKIPCResponse<dynamic> response) {
    MessageDialog().show(response.error,
        button: TextButton(
            onPressed: () {
              PylonsWallet.instance.goToPylons();
            },
            child: const Text(
              kClickToLogInText,
              style: TextStyle(color: EaselAppTheme.kBlue),
            )));
  }

  void showUserNameDialog() {
    MessageDialog().show("$kWelcomeToEaselText ${username.value}",
        button: TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            },
            child: const Text(kOkText)));
  }

  void checkConfigurations() async {
    switch (routingScreenState) {
      case RoutingScreenState.initial:

        final isExist = await PylonsWallet.instance.exists();

        if (isExist) {
          checkConfigurations();
          routingScreenState = RoutingScreenState.appInstalled;
          return;
        }

        showAppNotInstalledDialog();

        break;
      case RoutingScreenState.appInstalled:
        final response = await context.read<EaselProvider>().getProfile();

        if (response.success) {
          username.value = response.data.username ;
          routingScreenState = RoutingScreenState.userNameShown;
          checkConfigurations();
          return;
        } else if (response.errorCode == kErrProfileNotExist) {
          showCreateAnAccountDialog(response);
        } else {
          MessageDialog().show("$kErrProfileFetch: ${response.error}");
        }
        break;
      case RoutingScreenState.userNameShown:
        showUserNameDialog();
        break;
    }
  }
}

enum RoutingScreenState { initial, appInstalled, userNameShown }
