import 'package:first_flutter_app/repositories/local_movies/local_movies_constants.dart';
import 'package:first_flutter_app/repositories/local_movies/models/watchlist_movie_dto.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_dto.dart';
import 'package:first_flutter_app/views/main.dart';
import 'package:sqflite/sqflite.dart';

class WatchlistMoviesRepository {

  static Future<List<IdMovie>> getFavoriteMovies() async {
    final List<Map<String, Object?>> favoritesMaps = await MyAppState.db.query(LocalMoviesConstants.watchlistMoviesTable);
    final res = [
      for (final {
      'id': id as int,
      'title': title as String,
      'imageUrl': imageUrl as String
      } in favoritesMaps)
        IdMovie(id: id, title: title, imageUrl: imageUrl),
    ];
    return res;
  }

  static Future<void> insertFavoriteMovie(MovieDTO movie) async {
    await MyAppState.db.insert(
      LocalMoviesConstants.watchlistMoviesTable,
      IdMovie(id: movie.id, title: movie.title, imageUrl: movie.backdropPath).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteFavoriteMovie(int id) async {
    await MyAppState.db.delete(
      LocalMoviesConstants.watchlistMoviesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}