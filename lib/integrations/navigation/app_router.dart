import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/home', initial: true),
        AutoRoute(page: FavoritesRoute.page, path: '/favorites'),
      ];
}
