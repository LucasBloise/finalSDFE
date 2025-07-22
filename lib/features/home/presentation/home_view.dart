import 'package:auto_route/auto_route.dart';
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
                            return _CharacterCard(
                              character: character,
                              onFavoritePressed: () {
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

class _CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onFavoritePressed;

  const _CharacterCard(
      {required this.character, required this.onFavoritePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: inverseAlternativeColor,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: portalGreen.withOpacity(0.7), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  character.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: portalGreen),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child:
                          Icon(Icons.error_outline, color: dangerRed, size: 40),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      character.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: baseColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: switch (character.status) {
                            'Alive' => portalGreen,
                            'Dead' => dangerRed,
                            _ => Colors.grey,
                          },
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '${character.status} - ${character.species}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: baseColor,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.favorite_outline, color: baseColor),
              onPressed: onFavoritePressed,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.4),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
