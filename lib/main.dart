import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/routing_screen.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart' as di;
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flutter/pylons_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PylonsWallet.setup(mode: PylonsMode.prod, host: 'easel');
  di.init();

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
      child: MaterialApp(
        title: 'Easel',
        navigatorKey: navigatorKey,
        theme: EaselAppTheme.theme(context),
        home: const RoutingScreen(),
      ),
    );
  }
}

