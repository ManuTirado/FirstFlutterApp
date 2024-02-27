import 'package:first_flutter_app/repositories/movies/models/movie_dto.dart';

class MovieListDTO {
  final int page;
  final Iterable<MovieDTO> results;
  final int totalPages;
  final int totalResults;


  const MovieListDTO({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListDTO.fromJson(Map<String, dynamic> json) {
    return MovieListDTO(
      page: json['page'],
      results: List<MovieDTO>.from(json['results'].map((result) => MovieDTO.fromJson(result))),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}