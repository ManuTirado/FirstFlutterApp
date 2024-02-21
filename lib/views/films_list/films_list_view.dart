import 'package:first_flutter_app/config/theme/app_theme.dart';
import 'package:first_flutter_app/repositories/movies/MoviesRepoConstants.dart';
import 'package:first_flutter_app/repositories/movies/MoviesRepository.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_dto.dart';
import 'package:first_flutter_app/repositories/movies/models/movie_list_dto.dart';
import 'package:first_flutter_app/views/film_detail/film_detail_view.dart';
import 'package:first_flutter_app/views/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class FilmsListView extends StatefulWidget {
  const FilmsListView({super.key});

  @override
  State<FilmsListView> createState() => _FilmsListView();
}

class _FilmsListView extends State<FilmsListView> {
  final ScrollController _scrollController = ScrollController();
  List<MovieDTO> moviesList = [];
  int page = 1;
  bool isLoading = false;
  bool reachedEnd = false;
  bool error = false;

  @override
  void initState() {
    super.initState();

    fetchData(false);
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

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!reachedEnd && !isLoading) {
          page++;
          fetchData(false);
        }
      }
    });

    if (error) {
      return Text("Ha ocurrido un error, vuelva a intentarla más tarde");
    } else {
      if (moviesList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Column(
          children: [
            Flexible(
                child: RefreshIndicator(
                    onRefresh: () async {
                      page = 1;
                      reachedEnd = false;
                      await fetchData(true);
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 3 / 5),
                            delegate: SliverChildBuilderDelegate(
                                childCount: moviesList.length,
                                (context, index) {
                              return MovieCellView(movie: moviesList[index]);
                            })),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(childCount: 1,
                                (context, index) {
                          if (isLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return null;
                        }))
                      ],
                    )))
          ],
        );
      }
    }
  }

  fetchData(bool isReload) async {
    setState(() {
      isLoading = true;
    });
    try {
      MovieListDTO result =
          await MoviesRepository.getFeaturedMovies(page, SortBy.popularity);

      if (result.totalPages == page) {
        reachedEnd = true;
      }

      setState(() {
        if (isReload) {
          moviesList = result.results.toList();
        } else {
          moviesList.addAll(result.results);
        }
      });
    } catch (identifier) {
      print("Error: ${identifier} ");
      setState(() {
        error = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class MovieCellView extends StatelessWidget {
  const MovieCellView({
    super.key,
    required this.movie,
  });

  final MovieDTO movie;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Padding(
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            appState.setAppbarVisibility(false);
            Navigator.of(context).push(_createRoute(movie));
          },
          child: Container(
            color: AppColors.backgroundDark.color.withOpacity(0.2),
            child: Column(
              children: [
                FadeInImage.memoryNetwork(
                  width: MediaQuery.of(context).size.width / 2 - 5,
                  height: (MediaQuery.of(context).size.width / 2 - 5) * 1.4,
                  fit: BoxFit.fill,
                  placeholder: kTransparentImage,
                  image:
                      "${MoviesRepoConstants.imageBaseUrl}${movie.posterPath}",
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(movie.title,
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
        ));
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
