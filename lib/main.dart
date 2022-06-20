import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_screen.dart';
import 'package:easel_flutter/screens/home_screen.dart';
import 'package:easel_flutter/screens/splash_screen.dart';
import 'package:easel_flutter/screens/tutorial_screen.dart';
import 'package:easel_flutter/screens/welcome_screen/welcome_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart' as di;
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

bool isTablet = false;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  PylonsWallet.setup(mode: PylonsMode.prod, host: 'easel');
  di.init();

  isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide >= TABLET_MIN_WIDTH;

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'i18n',
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      useOnlyLangCode: true,
      child:const MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetIt.I.get<EaselProvider>()),
      ],
      child: ScreenUtilInit(
          minTextAdapt: true,
          builder: (BuildContext context, child) => MaterialApp(
                builder: (context, widget) {
                  ScreenUtil.init(context);
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            title: 'Easel',
                navigatorKey: navigatorKey,
                theme: EaselAppTheme.theme(context),
                initialRoute: '/',
                routes: {
                  '/': (context) => const SplashScreen(),
                  RouteUtil.ROUTE_TUTORIAL: (context) => const TutorialScreen(),
                  RouteUtil.ROUTE_WELCOME: (context) => const WelcomeScreen(),
                  RouteUtil.ROUTE_CREATOR_HUB: (context) => const CreatorHubScreen(),

                  RouteUtil.ROUTE_HOME: (context) => const HomeScreen(),
                },
              )),
    );
  }
}
