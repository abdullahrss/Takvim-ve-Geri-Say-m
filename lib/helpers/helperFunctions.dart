import 'package:ajanda/databasemodels/events.dart';

String calcRemaining(String date, String startTime) {
  String result = "";
  DateTime dateTime;
  DateTime now = DateTime.now();
  dateTime = startTime == "null" ? DateTime.parse("$date") : DateTime.parse("$date $startTime");
  if(dateTime.difference(now).inHours <= 0 && dateTime.difference(now).inDays == 0 && startTime != "null"){
    result = "Geçti";
  }else if(dateTime.difference(now).inDays < 0){
    result = "${dateTime.difference(now).inDays} Gün Geçti";
  }
  else if(dateTime.difference(now).inDays == 0 && dateTime.difference(now).inHours > 0){
    result = "${dateTime.difference(now).inHours} Saat Kaldı";
  }else if(dateTime.difference(now).inDays == 0 && startTime == "null"){
    result = "Bugün";
  }else{
    result = "${dateTime.difference(now).inDays} Gün Kaldı";
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
