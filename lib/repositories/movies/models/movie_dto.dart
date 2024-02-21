
class MovieDTO {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final List<int> genreIds;
  final double popularity;
  final double voteAverage;
  final int voteCount;

  const MovieDTO({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.genreIds,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieDTO.fromJson(Map<String, dynamic> json) {
    return MovieDTO(
        id: json['id'],
        title: json['title'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        releaseDate: json['release_date'],
        genreIds: List<int>.from(json['genre_ids']),
        popularity: json['popularity'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count']
    );
  }
}