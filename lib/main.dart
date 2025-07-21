import 'package:final_sd_front/infrastructure/ioc_manager.dart';
import 'package:final_sd_front/integrations/navigation/app_router.dart';
import 'package:final_sd_front/features/common/presentation/theme.dart'; // Import your theme
import 'package:flutter/material.dart';

// Create an instance of the AppRouter
final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  IocManager.register();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Final Sistemas Distribuidos',
      theme: lightTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
