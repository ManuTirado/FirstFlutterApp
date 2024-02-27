
class GenreDTO {
  final int id;
  final String name;

  const GenreDTO({
    required this.id,
    required this.name,
  });

  factory GenreDTO.fromJson(Map<String, dynamic> json) {
    return GenreDTO(
        id: json['id'],
        name: json['name']
    );
  }
}
