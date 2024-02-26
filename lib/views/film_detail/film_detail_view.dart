import 'dart:ui';
import 'package:first_flutter_app/repositories/favorite_movies/favorite_movies_constants.dart';
import 'package:first_flutter_app/repositories/favorite_movies/models/favorite_movie_dto.dart';
import 'package:first_flutter_app/repositories/movies/models/genre_dto.dart';
import 'package:first_flutter_app/repositories/movies/movies_repo_constants.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_dto.dart';
import 'package:first_flutter_app/resources/common/constants_common.dart';
import 'package:first_flutter_app/resources/common/extensions.dart';
import 'package:first_flutter_app/views/main.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transparent_image/transparent_image.dart';

class FilmDetailView extends StatelessWidget {
  const FilmDetailView({Key? key, required this.movie}) : super(key: key);
  final MovieDTO movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            FadeInImage.memoryNetwork(
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: "${MoviesRepoConstants.imageBaseUrl}${movie.backdropPath}",
            ),
            buildBlurBackGround(
                MovieDetailsView(movie: movie), 6, Colors.black.withOpacity(0.3)),
          ],
        ));
  }
}

class MovieDetailsView extends StatefulWidget {
  const MovieDetailsView({super.key, required this.movie});
  final MovieDTO movie;

  @override
  State<MovieDetailsView> createState() => _MovieDetailsView(movie: movie);
}

class _MovieDetailsView extends State<MovieDetailsView> {
  _MovieDetailsView({required this.movie});
  final MovieDTO movie;

  LocalStorage? storage;
  Iterable<GenreDTO>? genres;
  List<FavoriteMovie> favoriteMovies = [];
  bool isFavorite () {
    return favoriteMovies.contains(FavoriteMovie(id: movie.id)) ? true : false;
  }

  @override
  void initState() {
    _setInitialState();
    _getGenres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildBlurBackGround(
          buildNavBar(context), 6, Colors.black.withOpacity(0.5)),
      buildHeader(),
      buildBody(),
    ]);
  }

  Padding buildNavBar(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, kToolbarHeight * 0.5, 10, 10),
      child: Row(children: [
        IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              appState.setAppbarVisibility(true);
              Navigator.pop(context);
            }),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1),
                ),
              ],
            ))
          ],
        )),
        IconButton(
            icon: Icon(
                isFavorite() ? Icons.bookmark_added : Icons.bookmark_border),
            color: Colors.white,
            onPressed: () {
              _changeFavorites();
            }),
      ]),
    );
  }

  Padding buildHeader() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: FadeInImage.memoryNetwork(
                width: 200,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: "${MoviesRepoConstants.imageBaseUrl}${movie.posterPath}",
              ),
            ),
            const SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 15),
              Text("Año: ${movie.releaseDate.getYear()}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 15),
              Text("Calificación: ${movie.voteAverage.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              // 7.218
            ])
          ],
        ));
  }

  Expanded buildBody() {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                const Text("Sinopsis:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Text(
                  movie.overview,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text("Categorías:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                buildCategoryCells(genres ?? [], movie.genreIds),
                const SizedBox(height: 20),
              ],
            )));
  }

  Text buildCategoryCells(Iterable<GenreDTO> genres, Iterable<int> genreIds) {
    String res = "";
    Iterable<String> genreNames = [];
    genreNames = genres
        .where((element) => genreIds.contains(element.id))
        .map((e) => e.name);

    for (int index = 0; index < genreNames.length; index++) {
      if (index == 0 || index == genreNames.length) {
        res += "${genreNames.toList()[index]}";
      } else {
        res += "  -  ${genreNames.toList()[index]}";
      }
    }
    return Text(res,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
  }

  void _getGenres() {
    storage = LocalStorage(Constants.storageKey);
    setState(() {
      genres = storage?.getItem(Constants.storageGenresKey);
    });
  }

  void _changeFavorites() async {
    if (favoriteMovies.contains(FavoriteMovie(id: movie.id))) {
      await _deleteFavoriteMovie();
    } else {
      await _insertFavoriteMovie();
    }
    final res = await _getFavoriteMovies();
    setState(() {
      favoriteMovies = res;
    });
  }

  void _setInitialState() async {
    final favorites = await _getFavoriteMovies();

    setState(() {
      favoriteMovies = favorites;
    });
  }

  Future<List<FavoriteMovie>> _getFavoriteMovies() async {
    final List<Map<String, Object?>> favoritesMaps = await MyAppState.db.query(FavoriteMoviesConstants.favoriteMoviesTable);
    final res = [
      for (final {
      'id': id as int
      } in favoritesMaps)
        FavoriteMovie(id: id),
    ];
    return res;
  }

  Future<void> _insertFavoriteMovie() async {
    await MyAppState.db.insert(
      FavoriteMoviesConstants.favoriteMoviesTable,
      FavoriteMovie(id: movie.id).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deleteFavoriteMovie() async {
    await MyAppState.db.delete(
      FavoriteMoviesConstants.favoriteMoviesTable,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }
}

ClipRRect buildBlurBackGround(
    Widget foregroundView, double blur, Color backgroundColor) {
  return ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
          color: backgroundColor,
          alignment: Alignment.center,
          child: foregroundView),
    ),
  );
}
