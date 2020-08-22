import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../databasehelper/dataBaseHelper.dart';

class Notifications {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  Color notificationColor = const Color.fromRGBO(255, 0, 245, 1.0);
  Color ledColor = const Color.fromRGBO(45, 150, 255, 1.0);

  Notifications(this.localNotificationsPlugin);

  var _db = DbHelper();

  void initalizeNotifications() async {
    var initalizeAndroid = AndroidInitializationSettings("app_icon");
    var initalizeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initalizeAndroid, initalizeIOS);
    await localNotificationsPlugin.initialize(initSettings,onSelectNotification: selectNotification);
  }

  Future countDownNotification(
      FlutterLocalNotificationsPlugin plugin, String message, String subtext, int id) async {
    var androidChannel = AndroidNotificationDetails(
      'your channel id',
      "CHANNEL-NAME",
      "CHANNEL-DESC",
      largeIcon: DrawableResourceAndroidBitmap('screen'),
      importance: Importance.Max,
      priority: Priority.Max,
      autoCancel: false,
      ongoing: false,
      // notifications
      onlyAlertOnce: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    initalizeNotifications();
    subtext = "<b>" + subtext + "<//b>";
    await plugin.show(id, message, subtext, platformChannel);
  }

  Future singleNotification(FlutterLocalNotificationsPlugin plugin, DateTime datetime,
      String message, String subtext, int id) async {
    var androidChannel = AndroidNotificationDetails(
      'your channel id',
      "CHANNEL-NAME",
      "CHANNEL-DESC",
      largeIcon: DrawableResourceAndroidBitmap('screen'),
      importance: Importance.Max,
      priority: Priority.Max,
      autoCancel: false,
      ongoing: false,
      // notifications
      onlyAlertOnce: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    initalizeNotifications();
    await localNotificationsPlugin.schedule(id, message, subtext, datetime, platformChannel,
        payload: id.toString());
  }
  Future selectNotification(String payload) async {
    if (payload != null) {
      print('[Notifications] Notification payload: ' + payload);
    }
//    await Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => {});
  }

        Future cancelNotification(FlutterLocalNotificationsPlugin plugin, int eventId) async {
    await plugin.cancel(eventId);
  }

  Future cancelAllNotifications(FlutterLocalNotificationsPlugin plugin) async {
    await plugin.cancelAll();
  }

  String calcSingleNotificationBodyText(String index) {
    var provisionMap = {
      "1": "Etkinliğiniz zamanı geldi.",
      "2": "Etkinliğinize 5 dakika kaldı.",
      "3": "Etkinliğinize 15 dakika kaldı.",
      "4": "Etkinliğinize 30 dakika kaldı.",
      "5": "Etkinliğinize 1 saat kaldı.",
      "6": "Etkinliğinize 12 saat kaldı.",
      "7": "Etkinliğinize 1 gün kaldı.",
      "8": "Etkinliğinize 3 gün kaldı.",
      "9": "Etkinliğinize 1 hafta kaldı."
    };
    return provisionMap.containsKey(index) ? provisionMap[index] : "[ERROR] [NOTIFICATIONS] [calcSingleNotificationBodyText] Unvalid index!";
  }

  DateTime calcNotificationDate(DateTime date, int index) {
    switch (index) {
      case 1:
        {
          return date;
        }
        break;
      case 2:
        {
          return date.subtract(Duration(minutes: 5));
        }
        break;
      case 3:
        {
          return date.subtract(Duration(minutes: 15));
        }
        break;
      case 4:
        {
          return date.subtract(Duration(minutes: 30));
        }
        break;
      case 5:
        {
          return date.subtract(Duration(minutes: 60));
        }
        break;
      case 6:
        {
          return date.subtract(Duration(hours: 12));
        }
        break;
      case 7:
        {
          return date.subtract(Duration(days: 1));
        }
        break;
      case 8:
        {
          return date.subtract(Duration(days: 3));
        }
        break;
      case 9:
        {
          return date.subtract(Duration(days: 7));
        }
        break;
      default:
        {
          print("[ERROR] [NOTIFICATIONS] Invalid index");
          return date;
        }
    }
  }

  Future getEventForNot() async {
    var events = await _db.getEventList();
    var element = events[0];

    DateTime now = DateTime.now().add(Duration(seconds: 5));
    await singleNotification(
      localNotificationsPlugin,
      now,
      element.title,
      element.desc,
      element.id,
    );
  }
}
