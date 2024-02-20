import 'package:first_flutter_app/repositories/movies/MoviesRepoConstants.dart';
import 'package:first_flutter_app/repositories/movies/models/MovieDTO.dart';
import 'package:first_flutter_app/views/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilmDetailView extends StatelessWidget {
  const FilmDetailView({Key? key, required this.movie}) : super(key: key);

  final MovieDTO movie;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "${MoviesRepoConstants.imageBaseUrlOriginal}${movie.backdropPath}",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    appState.setAppbarVisibility(true);
                    Navigator.pop(context);
                  },
                  child: const Text("Go back"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
