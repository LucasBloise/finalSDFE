import 'package:auto_route/auto_route.dart';
import 'package:final_sd_front/features/common/presentation/widgets/character_card.dart';
import 'package:final_sd_front/features/home/data/character.dart';
import 'package:final_sd_front/features/home/presentation/home_view_model.dart';
import 'package:final_sd_front/infrastructure/ioc_manager.dart';
import 'package:flutter/material.dart';
import 'package:final_sd_front/features/common/presentation/theme.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel;
  List<Character> _foundCharacters = [];

  @override
  void initState() {
    _viewModel = IocManager.resolve<HomeViewModel>();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.initAuth0();
    _viewModel.getCharacters();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {
      _foundCharacters = _viewModel.characters;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Character> results = [];
    if (enteredKeyword.isEmpty) {
      results = _viewModel.characters;
    } else {
      results = _viewModel.characters
          .where(
            (character) => character.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }

    setState(() {
      _foundCharacters = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        backgroundColor: spaceDark,
        foregroundColor: baseColor,
        actions: [
          if (_viewModel.isAuthenticated)
            TextButton(
              onPressed: () {
                context.router.pushNamed('/favorites');
              },
              child: const Text(
                'Mis Favoritos',
                style: TextStyle(color: baseColor),
              ),
            ),
          TextButton(
            onPressed: () {
              if (_viewModel.isAuthenticated) {
                _viewModel.signOut();
              } else {
                _viewModel.signIn();
              }
            },
            child: Text(
              _viewModel.isAuthenticated ? 'Cerrar Sesión' : 'Iniciar Sesión',
              style: const TextStyle(color: baseColor),
            ),
          ),
        ],
      ),
      backgroundColor: spaceDark,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _runFilter(value),
              style: const TextStyle(color: baseColor),
              decoration: InputDecoration(
                labelText: 'Buscar personajes...',
                labelStyle: const TextStyle(color: rickBlue),
                suffixIcon: const Icon(Icons.search, color: rickBlue),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: rickBlue),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: portalGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _viewModel.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(portalGreen),
                      ),
                    )
                  : _foundCharacters.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _foundCharacters.length,
                          itemBuilder: (context, index) {
                            final character = _foundCharacters[index];
                            return CharacterCard(
                              character: character,
                              onFavoritePressed: () {
                                _viewModel.checkPremium();
                                if (!_viewModel.isAuthenticated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Debes iniciar sesión para guardar favoritos.'),
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                  );
                                } else if (_viewModel.isPremium) {
                                  _viewModel.addFavorite(character);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${character.name} ha sido añadido a favoritos'),
                                      backgroundColor: portalGreen,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Esta es una función premium. Por favor, actualiza tu cuenta.'),
                                      backgroundColor: dangerRed,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        )
                      : const Text(
                          'No se encontraron personajes',
                          style: TextStyle(color: baseColor, fontSize: 18),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
