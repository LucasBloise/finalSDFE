import 'package:auto_route/auto_route.dart';
import 'package:final_sd_front/features/common/presentation/theme.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        backgroundColor: spaceDark,
        foregroundColor: baseColor,
      ),
      backgroundColor: spaceDark,
      body: const Center(
        child: Text(
          'Aquí se mostrarán tus personajes favoritos.',
          style: TextStyle(color: baseColor, fontSize: 18),
        ),
      ),
    );
  }
}
