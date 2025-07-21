import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:final_sd_front/features/common/presentation/theme.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Map<String, String>> _allCharacters = [
    {
      'id': '1',
      'name': 'Rick Sanchez',
      'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    },
    {
      'id': '2',
      'name': 'Morty Smith',
      'image': 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    },
    {
      'id': '3',
      'name': 'Summer Smith',
      'image': 'https://rickandmortyapi.com/api/character/avatar/3.jpeg',
    },
    {
      'id': '4',
      'name': 'Beth Smith',
      'image': 'https://rickandmortyapi.com/api/character/avatar/4.jpeg',
    },
    {
      'id': '5',
      'name': 'Jerry Smith',
      'image': 'https://rickandmortyapi.com/api/character/avatar/5.jpeg',
    },
    {
      'id': '6',
      'name': 'Abadango Cluster Princess',
      'image': 'https://rickandmortyapi.com/api/character/avatar/6.jpeg',
    },
    {
      'id': '7',
      'name': 'Abradolf Lincler',
      'image': 'https://rickandmortyapi.com/api/character/avatar/7.jpeg',
    },
    {
      'id': '8',
      'name': 'Adjudicator Rick',
      'image': 'https://rickandmortyapi.com/api/character/avatar/8.jpeg',
    },
    {
      'id': '9',
      'name': 'Agency Director',
      'image': 'https://rickandmortyapi.com/api/character/avatar/9.jpeg',
    },
    {
      'id': '10',
      'name': 'Alan Rails',
      'image': 'https://rickandmortyapi.com/api/character/avatar/10.jpeg',
    },
    {
      'id': '11',
      'name': 'Albert Einstein',
      'image': 'https://rickandmortyapi.com/api/character/avatar/11.jpeg',
    },
    {
      'id': '12',
      'name': 'Alexander',
      'image': 'https://rickandmortyapi.com/api/character/avatar/12.jpeg',
    },
  ];

  List<Map<String, String>> _foundCharacters = [];

  @override
  void initState() {
    _foundCharacters = _allCharacters;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCharacters;
    } else {
      results =
          _allCharacters
              .where(
                (character) => character['name']!.toLowerCase().contains(
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
              // TODO: Implement login functionality
            },
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(color: baseColor),
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
              child:
                  _foundCharacters.isNotEmpty
                      ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: _foundCharacters.length,
                        itemBuilder:
                            (context, index) => _CharacterCard(
                              character: _foundCharacters[index],
                            ),
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
  final Map<String, String> character;

  const _CharacterCard({required this.character});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              character['image']!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: portalGreen),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error_outline, color: dangerRed, size: 40),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              character['name']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: baseColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
