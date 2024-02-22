import 'dart:ui';
import 'package:first_flutter_app/repositories/movies/models/genre_dto.dart';
import 'package:first_flutter_app/repositories/movies/movies_repo_constants.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_dto.dart';
import 'package:first_flutter_app/resources/common/constants_common.dart';
import 'package:first_flutter_app/resources/common/extensions.dart';
import 'package:first_flutter_app/views/main.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
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
        buildBlurBackGround(MovieDetailsView(movie: movie), 6, Colors.black.withOpacity(0.3)),
      ],
    ));
  }
}

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({
    super.key,
    required this.movie,
  });

  final MovieDTO movie;

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = LocalStorage(Constants.storageKey);
    final Iterable<GenreDTO> genres = storage.getItem(Constants.storageGenresKey) ?? [];
    return Column(children: [
      buildBlurBackGround(buildNavBar(context), 6, Colors.black.withOpacity(0.5)),
      buildHeader(),
      buildBody(genres),

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
            icon: const Icon(Icons.bookmark_border),
            color: Colors.white,
            onPressed: () {}),
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

  Expanded buildBody(Iterable<GenreDTO> genres) {
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
                buildCategoryCells(genres, movie.genreIds),
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
      if(index == 0 || index == genreNames.length) {
        res += "${genreNames.toList()[index]}";
      } else {
        res += "  -  ${genreNames.toList()[index]}";
      }
    }
    return Text(res,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
  }
}

ClipRRect buildBlurBackGround(Widget foregroundView, double blur, Color backgroundColor) {
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
