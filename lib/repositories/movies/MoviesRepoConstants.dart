
enum SortBy {
  popularity,
  votes,
  latest,
}

class MoviesRepoConstants {
  static const String apiKey = "089148df72900a0184a03bd499431630";
  static const String apiToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwODkxNDhkZjcyOTAwYTAxODRhMDNiZDQ5OTQzMTYzMCIsInN1YiI6IjY1YmQyMDU4Y2ZmZWVkMDI1OWFkNGMwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0hS0wKDN5vpztaJYJOBk0BZkFrsJ5AjM4kQG-HqCoMQ";

  static const String baseUrl = "https://api.themoviedb.org/3/";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
  static const String imageBaseUrlOriginal = "https://image.tmdb.org/t/p/original";

  static const String getGenresUrl = "${baseUrl}genre/movie/list?language=es";

  static const String dateFormat = "yyyy-MM-dd";

  static String discoverUrl(int page, SortBy sortBy) {
    switch (sortBy) {
      case SortBy.popularity:
        return "${baseUrl}discover/movie?include_adult=false&include_video=false&language=es-ES&page=$page&sort_by=popularity.desc";
      case SortBy.votes:
        return "${baseUrl}discover/movie?include_adult=false&include_video=false&language=es-ES&page=$page&sort_by=vote_average.desc";
      case SortBy.latest:
        return "${baseUrl}discover/movie?include_adult=false&include_video=false&language=es-ES&page=$page&sort_by=primary_release_date.desc";
    }
  }
}