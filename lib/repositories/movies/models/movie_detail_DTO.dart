
import 'package:first_flutter_app/repositories/movies/models/genre_dto.dart';

class MovieDetailDTO {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final List<GenreDTO> genres;
  final double popularity;
  final double voteAverage;
  final int voteCount;

  const MovieDetailDTO({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.genres,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieDetailDTO.fromJson(Map<String, dynamic> json) {
    return MovieDetailDTO(
        id: json['id'],
        title: json['title'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        releaseDate: json['release_date'],
        genres: List<GenreDTO>.from(json['genres'].map((result) => GenreDTO.fromJson(result))),
        popularity: json['popularity'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count']
    );
  }
}