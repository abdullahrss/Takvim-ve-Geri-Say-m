import 'package:ajanda/databasemodels/events.dart';

String calcRemaining(String date, String startTime) {
  var result;
  if (startTime == "null") {
    result = (DateTime.parse(date).difference(DateTime.now()).inDays < 0)
        ? "${-1 * DateTime.parse(date).difference(DateTime.now()).inDays}\nGün Geçti"
        : "${DateTime.parse(date).difference(DateTime.now()).inDays}\nGün Kaldı";
  } else {
    result = (DateTime.parse("$date $startTime").difference(DateTime.now()).inDays < 0)
        ? "${-1 * DateTime.parse("$date $startTime").difference(DateTime.now()).inDays}\nGün Geçti"
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
  return d1.compareTo(d2);
//  /// Once olma durumu
//  if (d1.isBefore(d2))
//    return 1;
//
//  /// Sonra olma durumu
//  else if (d1.isAfter(d2)) return 0;
//  /// Esit olma durumu
//  return 1;
}

void printEvent(Event e) {
  print("id : ${e.id} type : ${e.id.runtimeType}\n"
      "title : ${e.title} type : ${e.title.runtimeType}\n"
      "recipient : ${e.recipient} type : ${e.recipient.runtimeType}\n"
      "cc : ${e.cc} type : ${e.cc.runtimeType}\n"
      "bb : ${e.bb} type : ${e.bb.runtimeType}\n"
      "subject : ${e.subject.runtimeType} type : ${e.subject.runtimeType}\n"
      "attachments : ${e.attachments} type : ${e.attachments.runtimeType}\n");
}
