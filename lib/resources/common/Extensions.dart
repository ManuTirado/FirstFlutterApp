import 'package:first_flutter_app/repositories/movies/MoviesRepoConstants.dart';
import 'package:intl/intl.dart';

extension Date on String {
  String getYear() {
    try {
      DateFormat format = DateFormat(MoviesRepoConstants.dateFormat);
      DateTime dateTime = format.parse(this);
      return dateTime.year.toString();
    } catch (e) {
      print('Invalid date format: $e');
      return "";
    }
  }
}
