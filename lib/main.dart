import 'package:final_sd_front/infrastructure/environments_config.dart';
import 'package:final_sd_front/infrastructure/ioc_manager.dart';
import 'package:final_sd_front/integrations/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// Create an instance of the AppRouter
final _appRouter = AppRouter();

void main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentConfig.init();
  IocManager.register();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Final Sistemas Distribuidos',
      routerConfig: _appRouter.config(),
    );
  }
}
