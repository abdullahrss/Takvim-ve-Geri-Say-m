import 'package:ajanda/databasemodels/events.dart';

String calcRemaining(String date, String startTime) {
  String result;
  if (startTime == "null") {
    result = (DateTime.parse(date).difference(DateTime.now()).inDays == 0 &&
            DateTime.parse(date).isBefore(DateTime.now()))
        ? "Bugün"
        : (DateTime.parse(date).difference(DateTime.now()).inDays < 0)
            ? "${-1 * DateTime.parse(date).difference(DateTime.now()).inDays}\nGün Geçti"
            : DateTime.parse(date).difference(DateTime.now()).inDays == 0
                ? "Geçti"
                : "${DateTime.parse(date).difference(DateTime.now()).inDays}\nGün Kaldı";
  } else {
    result = (DateTime.parse("$date $startTime").difference(DateTime.now()).inDays == 0 &&
            DateTime.now().isBefore(DateTime.parse("$date $startTime")))
        ? "Bugün"
        : (DateTime.parse("$date $startTime").difference(DateTime.now()).inDays < 0)
            ? "${-1 * DateTime.parse("$date $startTime").difference(DateTime.now()).inDays}\nGün Geçti"
            : DateTime.parse("$date $startTime").difference(DateTime.now()).inDays == 0
                ? "Geçti"
                : "${DateTime.parse("$date $startTime").difference(DateTime.now()).inDays}\nGün Kaldı";
  }

  return result;
}

List<String> stringPathsToList(String attachmentsStr) {
  var result = attachmentsStr.split("-");
  result.removeLast();
  return result;
}

// once ise 1 sonra ise 0
int sortByDate(Event e1, Event e2) {
  DateTime d1 = e1.startTime != "null"
      ? DateTime.parse("${e1.date} ${e1.startTime}")
      : DateTime.parse(e1.date);
  DateTime d2 = e2.startTime != "null"
      ? DateTime.parse("${e2.date} ${e2.startTime}")
      : DateTime.parse(e2.date);
  return d2.compareTo(d1);
}
