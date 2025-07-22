import 'package:final_sd_front/integrations/navigation/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

class Routes {
  static const String home = '/';
  static const String favorites = '/favorites';
}

final Map<String, PageRouteInfo Function(Object? arguments)> routeBuilders = {
  Routes.home: (arguments) => HomeRoute(),
  Routes.favorites: (arguments) => FavoritesRoute(),
};
