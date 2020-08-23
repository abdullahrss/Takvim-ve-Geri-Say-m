import 'package:flutter/material.dart';
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart" show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../databasehelper/dataBaseHelper.dart';
import '../events/calenderEvent.dart';
import '../widgets/showDialog.dart';
import '../events/addevent.dart';

class FutureCalendar extends StatelessWidget {
  DbHelper _helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _helper.getEventList(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
            body: Center(child: Text("Yükleniyor...."),),
          );
        } else {
          return Calendar(eventList: snapshot.data,);
        }
      },
    );
  }

}


class Calendar extends StatefulWidget {
  final eventList;

  Calendar({Key key, this.eventList}) : super(key: key);

  @override
  _CalendarState createState() => new _CalendarState(eventList);
}

class _CalendarState extends State<Calendar> {
  final eventList;

  _CalendarState(this.eventList);

  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.deepOrangeAccent,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>();

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    super.initState();
    setState(() {
      for (var event in eventList) {
        _markedDateMap.add(
            DateTime.parse(event.date),
            Event(
            date: DateTime.parse(event.date),
            title: event.title,
            icon: _eventIcon,
        ));
      }
    });
//    var _helper = DbHelper();
//    var sorgu = _helper.getEventList();
//    sorgu.then((onValue) {
//      setState(() {
//        for (int i = 0; i < onValue.length; i++) {
//          var tarih = DateTime.parse(onValue[i].date);
//          _markedDateMap.add(
//              tarih,
//              Event(
//                date: tarih,
//                title: onValue[i].title,
//                icon: _eventIcon,
//              ));
//        }
//      });
//    });
  }

  /// Add more events to _markedDateMap EventList
//    _markedDateMap.add(
//        new DateTime(2020, 2, 25),
//        new Event(
//          date: new DateTime(2020, 2, 25),
//          title: 'Event 5',
//          icon: _eventIcon,
//        ));
//
//    _markedDateMap.addAll(new DateTime(2020, 2, 11), [
//      new Event(
//        date: new DateTime(2020, 2, 11),
//        title: 'Event 1',
//        icon: _eventIcon,
//      ),
//      new Event(
//        date: new DateTime(2020, 2, 11),
//        title: 'Event 3',
//        icon: _eventIcon,
//      ),
//    ]);

  @override
  Widget build(BuildContext context) {
    /// Example with custom icon
    _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      // weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: 'Haftalık Takvim',
      weekFormat: true,
      markedDatesMap: _markedDateMap,
      height: 200.0,
      selectedDateTime: _currentDate2,
      showIconBehindDayText: true,

      /// daysHaveCircularBorder : null for not rendering any border, true for circular border, false for rectangular border
      daysHaveCircularBorder: false,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Colors.orangeAccent,
      ),
      todayTextStyle: TextStyle(
        color: Colors.orangeAccent,
      ),
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal: true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
    );

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        print("Ondaypreesed");
        this.setState(() => _currentDate2 = date);
        setState(() {
          var newdate = date.toString().split(" ")[0];
          final _helper = DbHelper();
          Future<bool> sorgu = _helper.isEventInDb('$newdate');
          sorgu.then((onValue) {
            if (onValue == true) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CalanderEvent(newdate)));
            } else {
              showMyDialog(context,
                  title: "Boş Gün",
                  message: 'Bu tarihe etkinlik eklemek ister misiniz ?', function: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddEvent(
                                  inputDate: newdate,
                                )));
                  });
            }
          });
        });
      },
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      // firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: Colors.blue)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.blueAccent,
      selectedDayTextStyle: TextStyle(
        color: Colors.orange,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //custom icon
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: _calendarCarousel,
          ),
          Container(
            margin: EdgeInsets.only(
              top: 30.0,
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: new Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      translateMonths(_currentMonth),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )),
                FlatButton(
                  child: Text('GERİ'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                ),
                FlatButton(
                  child: Text('İLERİ'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month + 1);
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: _calendarCarouselNoHeader,
          ),
          //
        ],
      ),
    );
  }

  void refreshPage() {
    var _helper = DbHelper();
    var sorgu = _helper.getEventList();
    sorgu.then((onValue) {
      setState(() {
        for (int i = 0; i < onValue.length; i++) {
          var tarih = DateTime.parse(onValue[i].date);
          _markedDateMap.add(
              tarih,
              Event(
                date: tarih,
                title: onValue[i].title,
                icon: _eventIcon,
              ));
        }
      });
    });
  }

  String translateMonths(String monthYear) {
    var map = {
      "Jan": "Ocak",
      "Feb": "Şubat",
      "Mar": "Mart",
      "Apr": "Nisan",
      "May": "Mayıs",
      "Jun": "Haziran",
      "Jul": "Temmuz",
      "Aug": "Ağustos",
      "Sep": "Eylül",
      "Oct": "Ekim",
      "Nov": "Kasım",
      "Dec": "Aralık"
    };

    return map.keys.contains(monthYear.split(" ")[0])
        ? map[monthYear.split(" ")[0]] + " " + monthYear.split(" ")[1]
        : monthYear;
  }
}
