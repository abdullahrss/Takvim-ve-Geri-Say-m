import 'package:ajanda/helpers/TURKISHtoEnglish.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;

  Notifications(this.localNotificationsPlugin);

  Future countDownNotification(
      FlutterLocalNotificationsPlugin plugin, String message, String subtext, int id) async {
    var androidChannel = AndroidNotificationDetails(
      'your channel id',
      "CHANNEL-NAME",
      "CHANNEL-DESC",
      largeIcon: DrawableResourceAndroidBitmap('screen'),
      importance: Importance.Low,
      priority: Priority.High,
      autoCancel: false,
      ongoing: true,
      enableVibration: false,
      onlyAlertOnce: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
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
    await localNotificationsPlugin.schedule(
      id+5000,
      message,
      subtext,
      datetime,
      platformChannel,
    );
  }

  Future singleNotificationWithMail(FlutterLocalNotificationsPlugin plugin, DateTime datetime,
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
      onlyAlertOnce: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    print("[NOTIFICATIONS] [onSelectNotification] creating notification ");
    await localNotificationsPlugin.schedule(
      id+5000,
      message,
      subtext,
      datetime,
      platformChannel,
      payload: id.toString(),
    );
  }

  Future cancelNotification(FlutterLocalNotificationsPlugin plugin, int eventId) async {
    await plugin.cancel(eventId);
  }

  Future cancelAllNotifications(FlutterLocalNotificationsPlugin plugin) async {
    await plugin.cancelAll();
  }

  String calcSingleNotificationBodyText(String index) {
    var provisionMap = {
      "1": protranslate["Etkinliğiniz zamanı geldi."][31],
      "2": protranslate["Etkinliğinize 5 dakika kaldı."][31],
      "3": protranslate["Etkinliğinize 15 dakika kaldı."][31],
      "4": protranslate["Etkinliğinize 30 dakika kaldı."][31],
      "5": protranslate["Etkinliğinize 12 saat kaldı."][31],
      "6": protranslate["Etkinliğinize 12 saat kaldı."][31],
      "7": protranslate["Etkinliğinize 1 gün kaldı."][31],
      "8": protranslate["Etkinliğinize 3 gün kaldı."][31],
      "9": protranslate["Etkinliğinize 1 hafta kaldı."][31]
    };
    return provisionMap.containsKey(index)
        ? provisionMap[index]
        : "[ERROR] [NOTIFICATIONS] [calcSingleNotificationBodyText] Unvalid index!";
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
}
