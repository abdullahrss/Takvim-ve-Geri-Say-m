import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory;
import '../events/notifications.dart';

// Local importlar
import '../helpers/constants.dart';
import '../databasemodels/events.dart';

class DbHelper {
  static DbHelper _databaseHelper; // Database'in tekil olmasi icin
  static Database _database;

  static final String _tablename = EventConstants.TABLE_NAME;
  static final String _columnId = EventConstants.COLUMN_ID;
  static final String _columnTitle = EventConstants.COLUMN_TITLE;
  static final String _columnDate = EventConstants.COLUMN_DATE;
  static final String _columnStartTime = EventConstants.COLUMN_STARTTIME;
  static final String _columnFinishTime = EventConstants.COLUMUN_FINISHTIME;
  static final String _columnDesc = EventConstants.COLUMN_DESCRIPTION;
  static final String _columnIsActive = EventConstants.COLUMN_ISACTIVE;
  static final String _columnNotification = EventConstants.COLUMN_NOTIFICATION;
  static final String _columnCountdownIsActive =
      EventConstants.COLUMN_COUNTDOWNISACTIVE;

  DbHelper._createInstance();

  factory DbHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DbHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  static Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'dbtakvim.db';

    // Database yoksa olusturuyor varsa aciyor
    var eventsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return eventsDatabase;
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $_tablename ( $_columnId INTEGER PRIMARY KEY NOT NULL,$_columnTitle TEXT ,$_columnDate TEXT,$_columnStartTime TEXT,$_columnFinishTime TEXT,$_columnDesc TEXT,$_columnIsActive INTEGER, $_columnNotification TEXT, $_columnCountdownIsActive INTEGER);');
  }

  // Databaseden tüm eventleri alma
  Future<List<Map<String, dynamic>>> getEventMapList() async {
    Database db = await this.database;
    var result = await db.query(_tablename, orderBy: '$_columnTitle ASC');
    return result;
  }

  // Insert Operation: Insert a Event object to database
  Future<int> insertEvent(Event event) async {
    Database db = await this.database;
    var result = await db.insert(_tablename, event.toMap());
    return result;
  }

  // Update Operation: Update a Event object and save it to database
  Future<int> updateEvent(Event event) async {
    var db = await this.database;
    var result = await db.update(_tablename, event.toMap(),
        where: '$_columnId = ?', whereArgs: [event.id]);
    return result;
  }

  Future updateSingleColumn(int id, String columnName, String newValue) async {
    var db = await this.database;
    await db.rawQuery(
        "UPDATE $_tablename SET $columnName='$newValue' WHERE $_columnId=$id");
  }

  // Tum degerleri gunceller
  Future updateAllEvent(Event event, int id) async {
    var db = await this.database;
    if (event.finishTime == Null) {
      await db.rawQuery(
          'UPDATE $_tablename SET $_columnTitle="${event.title}",$_columnDate="${event.date}",$_columnStartTime=$Null,$_columnFinishTime=$Null,$_columnDesc="${event.desc}",$_columnIsActive="${event.isActive}", $_columnNotification="${event.choice}", $_columnCountdownIsActive="${event.countDownIsActive}" WHERE $_columnId=$id');
    } else {
      await db.rawQuery(
          'UPDATE $_tablename SET $_columnTitle="${event.title}",$_columnDate="${event.date}",$_columnStartTime="${event.startTime}",$_columnFinishTime="${event.finishTime}",$_columnDesc="${event.desc}",$_columnIsActive="${event.isActive}", $_columnNotification="${event.choice}", $_columnCountdownIsActive="${event.countDownIsActive}" WHERE $_columnId=$id');
    }
  }

  // Delete Operation: Delete a Event object from database
  Future<int> deleteEvent(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $_tablename WHERE $_columnId = $id');
    return result;
  }

  Future<void> deleteOldEventDay(String date) async {
    var db = await this.database;
    await db.rawQuery('DELETE FROM $_tablename WHERE $_columnDate = "$date" ');
  }

  Future<void> deleteOldEventHour(String date, String hour) async {
    var db = await this.database;
    await db.rawQuery(
        'DELETE FROM $_tablename WHERE $_columnStartTime = "$hour" AND $_columnDate = "$date" ');
  }

  // Database deki eleman sayisini donduruyor
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $_tablename');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Databaseden alinan eventleri list seklinde alma
  Future<List<Event>> getEventList() async {
    var eventMapList = await getEventMapList();
    int count = eventMapList.length;
    List<Event> eventList = List<Event>();
    for (int i = 0; i < count; i++) {
      eventList.add(Event.fromMap(eventMapList[i]));
    }
    return eventList;
  }

  // Istenilen sekilde eventleri alma
  Future<List<Event>> getEventsByOrder(sortStyle) async {
    var eventMapList = await getEventMapList();
    int count = eventMapList.length;

    List<Event> eventList = List<Event>();
    for (int i = 0; i < count; i++) {
      eventList.add(Event.fromMap(eventMapList[i]));
    }
    // Listeyi istenilen sirada siralayip return edilmesi
    switch (sortStyle) {
      case 0:
        {
          return eventList; // A-Z a-z normal siralama
        }
        break;

      case 1:
        {
          return eventList.reversed.toList(); // Z-A z-a ters alfabetik siralama
        }
        break;
      case 2:
        {
          // Yakin tarihlerin basta oldugu siralama
          eventList.sort((a, b) =>
              DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
        }
        break;
      case 3:
        {
          // Uzak tarihlerin basta oldugu siralama
          eventList.sort((a, b) =>
              DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
          eventList = eventList.reversed.toList();
        }
        break;
      default:
        {
          // Default olarak A-Z a-z ayarli herhangi bir acik olmasin diye
          return eventList;
        }
        break;
    }
    return eventList;
  }

  Future<bool> isEventInDb(String date) async {
    var eventList = await getEventList();
    int count = eventList.length;

    for (var i = 0; i < count; i++) {
      if (eventList[i].date == date) {
        return true;
      }
    }
    return false;
  }

  Future<bool> isFullDay(String date) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT $_columnStartTime FROM $_tablename WHERE $_columnDate='$date'");
    if (result.length == 0) {
      return false;
    }
    if (result[0]["startTime"] == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Event>> getActiveEvents() async {
    Database db = await this.database;
    var result = await db
        .rawQuery("SELECT * FROM $_tablename WHERE $_columnIsActive='1'");
    List<Event> resultList = List<Event>();
    for (var i = 0; i < result.length; i++) {
      resultList.add(Event.fromMap(result[i]));
    }
    return resultList;
  }

  Future<List<Event>> getEventsForCalender(String date) async {
    // soruguyu guncelle
    var eventList = await getEventList();
    int count = eventList.length;

    List<Event> resultList = List<Event>();

    for (var i = 0; i < count; i++) {
      if (eventList[i].date == date) {
        resultList.add(eventList[i]);
      }
    }
    return resultList;
  }

  Future<List<Event>> getEventCalander(String date) async {
    // ????
    var eventList = await getEventList();
    int count = eventList.length;

    List<Event> resultList = List<Event>();

    for (var i = 0; i < count; i++) {
      if (eventList[i].date == date) {
        resultList.add(eventList[i]);
      }
    }
    return resultList;
  }

  Future<bool> openNotificationBar() async {
    Database db = await this.database;
    FlutterLocalNotificationsPlugin localNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var not = Notifications(localNotificationsPlugin);
    var result = await db.rawQuery(
        "SELECT * FROM $_tablename WHERE $_columnCountdownIsActive=1");
    List<Event> eventList = List<Event>();
    for (var i = 0; i < result.length; i++) {
      eventList.add(Event.fromMap(result[i]));
    }
    if (eventList.length == 0) {
      return false;
    }
    for (var i = 0; i < eventList.length; i++) {
      var targetTime = eventList[i].startTime == "null"
          ? DateTime.parse("${eventList[i].date}")
          : DateTime.parse("${eventList[i].date} ${eventList[i].startTime}");
      if (targetTime.isBefore(DateTime.now()) ||
          (targetTime == DateTime.now())) {
        not.cancelNotification(localNotificationsPlugin, eventList[i].id);
        await updateSingleColumn(
            eventList[i].id, _columnCountdownIsActive, "0");
        continue;
      }
      var remainingTime = targetTime.difference(DateTime.now());
      await not.countDownNotification(
          localNotificationsPlugin,
          eventList[i].title,
          "ETKİNLİĞE ${remainingTime.inDays} GÜN ${remainingTime.inHours - remainingTime.inDays * 24} SAAT ${remainingTime.inMinutes - remainingTime.inHours * 60} DAKİKA KALDI",
          eventList[i].id);
    }
    return true;
  }

  Future<void> createNotifications() async {
    Database db = await this.database;
    FlutterLocalNotificationsPlugin localNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var not = Notifications(localNotificationsPlugin);
    var events = await db.rawQuery(
        "SELECT * FROM $_tablename WHERE $_columnNotification!='0'"); // WHERE $_ColumnNotification!='0'
    List<Event> eventList = List<Event>();

    for (var i = 0; i < events.length; i++) {
      eventList.add(Event.fromMap(events[i]));
    }
    for (var event in eventList) {
      if (event.choice == "null") {
        continue;
      }
      var datetime = event.startTime != "null"
          ? DateTime.parse("${event.date} ${event.startTime}")
          : DateTime.parse(event.date);
      if (DateTime.now().compareTo(datetime) == 1) {
        print("Out of time event title : ${event.title}");
        localNotificationsPlugin.cancel(event.id);
        continue;
      }
      datetime = not.calcNotificationDate(datetime, int.parse(event.choice));
      await not.singleNotification(localNotificationsPlugin, datetime,
          event.title, event.desc, event.id);
    }
  }

  // Istenilen bir sql sorgusunu calistiriyor
  Future<dynamic> query(String query) async {
    Database db = await this.database;
    var result = await db.rawQuery(query);
    print(result);
    return result;
  }

  // Zamanı check ediyor
  Future<List<Event>> isTimeOk(String date) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT $_columnId,$_columnStartTime,$_columnFinishTime FROM $_tablename WHERE $_columnDate='$date' ");
    int count = result.length;

    List<Event> resultList = List<Event>();

    for (var i = 0; i < count; i++) {
      resultList.add(Event.fromMap(result[i]));
    }
    return resultList;
  }

  Future<int> clearoldevent() async {
    getEventList().then((value) {
      for (int i = 0; i < value.length; i++) {
        var targetTime = value[i].startTime == "null"
            ? DateTime.parse("${value[i].date}")
            : DateTime.parse("${value[i].date} ${value[i].startTime}");
        if (targetTime.isBefore(DateTime.now()) ||
            (targetTime == DateTime.now())) {
          if (value[i].startTime == "null") {
            deleteOldEventDay(value[i].date);

            return 0;
          } else {
            deleteOldEventHour(value[i].date, value[i].startTime);
            print("ikinci if");
            return 0;
          }
        }
      }
      return 0;
    });
  }

  Future clearDb() async {
    Database db = await this.database;
    db.rawQuery('DELETE FROM $_tablename');
  }

  Future closeDb() => _database.close();
}
