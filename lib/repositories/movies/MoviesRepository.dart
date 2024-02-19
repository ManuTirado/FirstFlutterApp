import 'dart:convert';
import 'dart:io';

import 'package:first_flutter_app/repositories/movies/MoviesRepoConstants.dart';
import 'package:first_flutter_app/repositories/movies/models/MovieListDTO.dart';
import 'package:http/http.dart' as http;

class MoviesRepository {

  static Future<MovieListDTO> getFeaturedMovies(int page, SortBy sortBy) async {

    final response = await http
        .get(
        Uri.parse(MoviesRepoConstants.baseUrl + MoviesRepoConstants.discoverPath(page, sortBy)),
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

}