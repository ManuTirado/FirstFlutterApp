import 'package:first_flutter_app/repositories/movies/models/genre_dto.dart';

class GenreListDTO {
  final Iterable<GenreDTO> genres;

  const GenreListDTO({
    required this.genres
  });

  factory GenreListDTO.fromJson(Map<String, dynamic> json) {
    return GenreListDTO(
        genres: json['genres']
    );
  }
}
