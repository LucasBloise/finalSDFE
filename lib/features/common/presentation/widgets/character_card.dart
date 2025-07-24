import 'package:final_sd_front/features/common/presentation/theme.dart';
import 'package:final_sd_front/features/home/data/character.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onFavoritePressed;

  const CharacterCard(
      {super.key, required this.character, required this.onFavoritePressed});

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
