import 'package:final_sd_front/integrations/navigation/i_navigation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class Navigation implements INavigation {
  final Map<String, PageRouteInfo Function(Object? arguments)> _routeBuilders;

  Navigation(this._routeBuilders);

  @override
  Future<dynamic>? push(NavigationRoute route, BuildContext context) {
    final pageRouteInfo = _getPageRouteInfo(route);
    return context.router.push(pageRouteInfo);
  }

  @override
  Future<dynamic>? pushReplacement(
    NavigationRoute route,
    BuildContext context,
  ) {
    final pageRouteInfo = _getPageRouteInfo(route);
    return context.router.replace(pageRouteInfo);
  }

  @override
  Future<dynamic>? navigate(NavigationRoute route, BuildContext context) {
    final pageRouteInfo = _getPageRouteInfo(route);
    return context.router.navigate(pageRouteInfo);
  }

  @override
  bool canPop(BuildContext context) {
    return context.router.canPop();
  }

  @override
  void pop(BuildContext context) {
    context.router.pop();
  }

  PageRouteInfo _getPageRouteInfo(NavigationRoute route) {
    final builder = _routeBuilders[route.routeName];
    if (builder != null) {
      return builder(route.arguments);
    }
    throw Exception('Route not found: ${route.routeName}');
  }
}
