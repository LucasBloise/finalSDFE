import 'package:auto_route/auto_route.dart';
import 'package:final_sd_front/features/common/presentation/theme.dart';
import 'package:final_sd_front/features/common/presentation/widgets/character_card.dart';
import 'package:final_sd_front/features/favorites/presentation/favorites_view_model.dart';
import 'package:final_sd_front/infrastructure/ioc_manager.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late final FavoritesViewModel _viewModel;

  @override
  void initState() {
    _viewModel = IocManager.resolve<FavoritesViewModel>();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.getFavoriteCharacters();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        backgroundColor: spaceDark,
        foregroundColor: baseColor,
      ),
      backgroundColor: spaceDark,
      body: _viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(portalGreen),
              ),
            )
          : _viewModel.favoriteCharacters.isNotEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _viewModel.favoriteCharacters.length,
                  itemBuilder: (context, index) {
                    final character = _viewModel.favoriteCharacters[index];
                    return CharacterCard(
                      character: character,
                      onFavoritePressed: () {
                        // TODO: Implement remove favorite functionality
                      },
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No tienes personajes favoritos todavía.',
                    style: TextStyle(color: baseColor, fontSize: 18),
                  ),
                ),
    );
  }
}
