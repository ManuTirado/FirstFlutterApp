import 'package:first_flutter_app/config/theme/app_theme.dart';
import 'package:first_flutter_app/repositories/local_movies/models/watchlist_movie_dto.dart';
import 'package:first_flutter_app/repositories/local_movies/repos/watchlist_movies_repository.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_detail_DTO.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_dto.dart';
import 'package:first_flutter_app/repositories/movies/movies_repo_constants.dart';
import 'package:first_flutter_app/repositories/movies/movies_repository.dart';
import 'package:first_flutter_app/views/explore/film_detail/film_detail_view.dart';
import 'package:first_flutter_app/views/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({super.key});

  @override
  State<WatchListView> createState() => _WatchListState();
}

class _WatchListState extends State<WatchListView> {
  final ScrollController _scrollController = ScrollController();
  List<IdMovie> moviesWatchlist = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        appState.setAppbarVisibility(true);
      } else {
        appState.setAppbarVisibility(false);
      }
    });

    if (moviesWatchlist.isEmpty) {
      return const Text("No has agregado ninguna película a tu watchlist aún");
    } else {
      return Column(
        children: [
          Flexible(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: moviesWatchlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WatchlistMovieCellView(movie: moviesWatchlist[index]);
                  })),
        ],
      );
    }
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    List<IdMovie> result = await WatchlistMoviesRepository.getFavoriteMovies();

    setState(() {
      moviesWatchlist = result;
      isLoading = false;
    });
  }
}

class WatchlistMovieCellView extends StatelessWidget {
  const WatchlistMovieCellView({
    super.key,
    required this.movie,
  });

  final IdMovie movie;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              appState.setAppbarVisibility(false);
              getDetail(context);
              //Navigator.of(context).push(_createRoute(movie));
            },
            child: Container(
              color: AppColors.backgroundDark.color.withOpacity(0.2),
              child: Column(
                children: [
                  FadeInImage.memoryNetwork(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3 - 60,
                    fit: BoxFit.fitWidth,
                    placeholder: kTransparentImage,
                    image:
                        "${MoviesRepoConstants.imageBaseUrl}${movie.imageUrl ?? ""}",
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(movie.title ?? "",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            height: 1,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary.color)),
                  ),
                  const Spacer()
                ],
              ),
            ),
          )),
    );
  }

  void getDetail(BuildContext context) async {
    final res = await MoviesRepository.getMoviesDetail(movie.id);
    Navigator.of(context).push(_createRoute(MovieDTO(id: res.id, title: res.title, overview: res.overview, posterPath: res.posterPath, backdropPath: res.backdropPath, releaseDate: res.releaseDate, genreIds: res.genres.map((e) => e.id).toList(), popularity: res.popularity, voteAverage: res.voteAverage, voteCount: res.voteCount)));
  }
  
  Route _createRoute(MovieDTO movie) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          FilmDetailView(movie: movie),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
