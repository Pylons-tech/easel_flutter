import 'dart:async';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/background_widget.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

class RoutingScreen extends StatefulWidget {
  const RoutingScreen({Key? key}) : super(key: key);

  @override
  _RoutingScreenState createState() {
    return _RoutingScreenState();
  }
}

class _RoutingScreenState extends State<RoutingScreen> {
  RoutingScreenState state = RoutingScreenState.initial;

  String userName = '';

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      checkPylonsAppExistsOrNot();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();
    switch (state) {
      case RoutingScreenState.initial:
        child =  Text(kPleaseWait, style: TextStyle(fontSize: 18.sp),);
        break;
      case RoutingScreenState.appNotInstalled:
        child = buildWalletNotInstalled(context);
        break;
      case RoutingScreenState.accountNotCreated:
        child = buildAccountNotCreated(context);
        break;
      case RoutingScreenState.somethingWentWrong:
        child = buildSomethingWentWrong(context);
        break;
      case RoutingScreenState.showUsername:
        child = Text("$kWelcome $userName", style: TextStyle(fontSize: 18.sp),);
        break;
    }
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            bottom: 0,
            right: 0,
            child: BackgroundWidget(),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [child],
            ),
          ),
        ],
      ),
    );
  }

  Container buildWalletNotInstalled(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kDontHavePylonsWallet,
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(
            height: 50.h,
          ),
          PylonsButton(
            onPressed: () async {
              onDownloadNowPressed(context);
            },
            btnText: kInstallApp,
          ),
          const SizedBox(
            height: 20,
          ),
          PylonsButton(
            onPressed: () async {
              checkPylonsAppExistsOrNot();
            },
            btnText: kTryAgain,
          ),
        ],
      ),
    );
  }

  Container buildAccountNotCreated(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kDontHavePylonsAccount,
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(
            height: 50.h,
          ),
          PylonsButton(
            onPressed: () async {
              getProfile();
            },
            btnText: kTryAgain,
          ),
        ],
      ),
    );
  }

  Container buildSomethingWentWrong(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kSomethingWentWrong,
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(
            height: 50.h,
          ),
          PylonsButton(
            onPressed: () async {
              getProfile();
            },
            btnText: kTryAgain,
          ),
        ],
      ),
    );
  }

  void checkPylonsAppExistsOrNot() async {
    final isExist = await PylonsWallet.instance.exists();

    if (isExist) {
      getProfile();
      return;
    }

    state = RoutingScreenState.appNotInstalled;
    setState(() {});
  }

  Future<void> getProfile() async {
    final response = await context.read<EaselProvider>().getProfile();

    if (response.success) {
      state = RoutingScreenState.showUsername;
      userName = response.data.username;
      setState(() {});

      await Future.delayed(const Duration(
        seconds: 2,
      ));

      navigatorKey.currentState!.pushReplacementNamed(RouteUtil.ROUTE_HOME);

      return;
    }

    if (response.errorCode == kErrProfileNotExist) {
      state = RoutingScreenState.accountNotCreated;
    } else {
      state = RoutingScreenState.somethingWentWrong;
    }

    setState(() {});
  }

  Future<void> onDownloadNowPressed(BuildContext context) async {
    final appAlreadyInstalled = await PylonsWallet.instance.exists();
    if (!appAlreadyInstalled) {
      PylonsWallet.instance.goToInstall();
    } else {
      context.show(message: kPylonsAlreadyInstalled);
    }
  }
}

enum RoutingScreenState { initial, appNotInstalled, accountNotCreated, somethingWentWrong, showUsername }
