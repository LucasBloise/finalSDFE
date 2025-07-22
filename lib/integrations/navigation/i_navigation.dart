import 'package:flutter/material.dart';

class NavigationRoute {
  final String routeName;
  final Object? arguments;

  NavigationRoute(this.routeName, {this.arguments});
}

abstract class INavigation {
  Future<dynamic>? push(NavigationRoute route, BuildContext context);

  Future<dynamic>? pushReplacement(NavigationRoute route, BuildContext context);

  Future<dynamic>? navigate(NavigationRoute route, BuildContext context);

  bool canPop(BuildContext context);

  void pop(BuildContext context);
}
