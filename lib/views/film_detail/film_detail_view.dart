import 'dart:ui';
import 'package:first_flutter_app/repositories/movies/MoviesRepoConstants.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_dto.dart';
import 'package:first_flutter_app/resources/common/Extensions.dart';
import 'package:first_flutter_app/views/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: MovieDetailsView(movie: movie)),
          ),
        ),
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
    return Column(children: [
      buildNavBar(context),
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
            icon: const Icon(Icons.bookmark_border),
            color: Colors.white,
            onPressed: () {}),
      ]),
    );
  }

  Padding buildHeader() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                Text(
                  movie.overview,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text("Categorías:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    for (var genreId in movie.genreIds)
                      buildCategoryCell(genreId),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            )));
  }

  Container buildCategoryCell(genreId) {
    return Container(
      child: Padding(padding: EdgeInsets.only(right: 10), child: Text(genreId.toString(),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),)
    );
  }
}
