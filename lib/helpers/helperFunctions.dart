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