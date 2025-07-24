class Favorite {
  final int id;
  final int characterId;

  Favorite({
    required this.id,
    required this.characterId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json['id'],
        characterId: json['characterId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'characterId': characterId,
      };
}
