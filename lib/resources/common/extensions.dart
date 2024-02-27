import 'package:first_flutter_app/resources/common/constants_common.dart';
import 'package:intl/intl.dart';

extension Date on String {
  String getYear() {
    try {
      DateFormat format = DateFormat(Constants.americanDateFormat);
      DateTime dateTime = format.parse(this);
      return dateTime.year.toString();
    } catch (e) {
      print('Invalid date format: $e');
      return "";
    }
  }
}
