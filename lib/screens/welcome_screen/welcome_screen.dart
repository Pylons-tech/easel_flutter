import 'dart:developer';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/show_something_wrong_dialog.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/show_wallet_install_dialog.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../../utils/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              kWelcomeToEaselText,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: EaselAppTheme.kDarkText, fontSize: 24.sp, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(height: 50.h),
          Text(
            kEaselDescriptionText,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: EaselAppTheme.kDarkText, fontSize: 16.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 50.h),
          Container(
            alignment: Alignment.topLeft,
            child: PylonsButton(
              onPressed: () {
                checkPylonsAppExistsOrNot();
              },
              btnText: kGetStarted,
              isBlue: false,
            ),
          ),
        ],
      ),
    ));
  }

  void checkPylonsAppExistsOrNot() async {
    final isExist = await PylonsWallet.instance.exists();

    if (isExist) {
      getProfile();
      return;
    }

    context.read<EaselProvider>().populateCoinsIfPylonsNotExists();

    navigatorKey.currentState!.pushReplacementNamed(RouteUtil.kRouteCreatorHub);
  }

  Future<void> getProfile() async {
    final response = await context.read<EaselProvider>().getProfile();

    if (response.success) {
      await Future.delayed(const Duration(
        milliseconds: 500,
      ));

      navigatorKey.currentState!.pushReplacementNamed(RouteUtil.kRouteCreatorHub);

      return;
    }


    if (response.errorCode == kErrProfileNotExist) {
      ShowWalletInstallDialog showWalletInstallDialog = ShowWalletInstallDialog(
          context: context,
          errorMessage: 'create_username_description'.tr(),
          buttonMessage: 'open_pylons_app'.tr(),
          onClose: () {
            Navigator.of(context).pop();
          });
      showWalletInstallDialog.show();
    } else {
      ShowSomethingWentWrongDialog somethingWentWrongDialog = ShowSomethingWentWrongDialog(
          context: context,
          errorMessage: kPleaseTryAgain,
          onClose: () {
            Navigator.of(context).pop();
          });
      somethingWentWrongDialog.show();
    }
  }
}

enum RoutingScreenState { initial, appNotInstalled, accountNotCreated, somethingWentWrong, showUsername }
