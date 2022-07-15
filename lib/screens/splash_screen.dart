import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/show_something_wrong_dialog.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/show_wallet_install_dialog.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenResponsive(
      mobileScreen: (context) => buildMobileScreen(context),
      tabletScreen: (BuildContext context) => buildTabletScreen(context),
    ));
  }

  Stack buildMobileScreen(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: SvgPicture.asset(kSvgSplash, fit: BoxFit.cover)),
        Positioned(
          top: 0.3.sh,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: PylonsButton(
              onPressed: onGetStartedPressed,
              btnText: kGetStarted,
            ),
          ),
        ),
      ],
    );
  }

  Stack buildTabletScreen(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(),
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: SvgPicture.asset(kSvgTabSplash, fit: BoxFit.fill)),
        Positioned(
          top: 0.26.sh,
          left: 0.2.sw,
          right: 0,
          child: SizedBox(
            height: 0.3.sh,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.centerLeft, child: SvgPicture.asset(kSplashTabEasel)),
                SizedBox(height: 10.h),
                Align(alignment: Alignment.centerLeft, child: SvgPicture.asset(kSplashNFTCreatorTab)),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.3.sh,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: PylonsButton(
              onPressed: onGetStartedPressed,
              btnText: kGetStarted,
            ),
          ),
        ),
      ],
    );
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
          onDownloadPressed: () {
            PylonsWallet.instance.goToPylons();
          },
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

  void onGetStartedPressed() {
    var onBoardingComplete = GetIt.I.get<LocalDataSource>().getOnBoardingComplete();
    if (!onBoardingComplete) {
      Navigator.of(context).pushNamed(RouteUtil.kRouteTutorial);
      return;
    }

    checkPylonsAppExistsOrNot();

  }
}
