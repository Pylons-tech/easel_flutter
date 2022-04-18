import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/routing_screen.dart';
import 'package:easel_flutter/screens/splash_screen.dart';
import 'package:easel_flutter/screens/tutorial_screen.dart';
import 'package:easel_flutter/screens/welcome_screen.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart' as di;
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_sdk/pylons_sdk.dart';


bool isTablet = false;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PylonsWallet.setup(mode: PylonsMode.prod, host: 'easel');
  di.init();


  isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.shortestSide >= 600;

  runApp(const MyApp());
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
          builder: () => MaterialApp(
                builder: (context, widget) {
                  ScreenUtil.setContext(context);
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
                title: 'Easel',
                navigatorKey: navigatorKey,
                theme: EaselAppTheme.theme(context),
                initialRoute: '/',
                routes: {
                  '/': (context) => const SplashScreen(),
                  RouteUtil.ROUTE_TUTORIAL: (context) => const TutorialScreen(),
                  RouteUtil.ROUTE_WELCOME: (context) => const WelcomeScreen(),
                  RouteUtil.ROUTE_ROUTING: (context) => const RoutingScreen(),
                },
              )),
    );
  }
}
