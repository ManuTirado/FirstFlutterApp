import 'dart:convert';
import 'package:first_flutter_app/repositories/movies/movies_repo_constants.dart';
import 'package:first_flutter_app/repositories/movies/models/genre_list_dto.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_list_dto.dart';
import 'package:http/http.dart' as http;

class MoviesRepository {

  static Future<MovieListDTO> getFeaturedMovies(int page, SortBy sortBy) async {

    final response = await http
        .get(
        Uri.parse(MoviesRepoConstants.discoverUrl(page, sortBy)),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer ${ MoviesRepoConstants.apiToken }",
    },);

    if (response.statusCode == 200) {
      return MovieListDTO.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load featured movies');
    }
  }

  static Future<GenreListDTO> getGenreList() async {

    final response = await http
        .get(
      Uri.parse(MoviesRepoConstants.getGenresUrl),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer ${ MoviesRepoConstants.apiToken }",
      },);

    if (response.statusCode == 200) {
      return GenreListDTO.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load featured movies');
    }
  }
}