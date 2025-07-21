import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:final_sd_front/features/common/presentation/theme.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: brandColor,
        foregroundColor: baseColor,
      ),
      backgroundColor: lightBackgroundPrimary,
      body: Center(child: Text("Home Page")),
    );
  }
}
