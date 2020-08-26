import 'package:ajanda/databasehelper/dataBaseHelper.dart';
import 'package:ajanda/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:rxdart/subjects.dart';
import 'pages/mainmenu.dart';
import 'helpers/ads.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        var db = DbHelper();
        var event = await db.getEventById(int.parse(payload));
        final MailOptions mailOptions = MailOptions(
          body: event.body,
          subject: event.subject,
          recipients: [event.recipient],
          isHTML: event.isHTML=="false"?false:true,
          ccRecipients: [event.cc],
          bccRecipients: [event.bb],
          attachments: [event.attachments],
        );

        await FlutterMailer.send(mailOptions);
        //selectNotificationSubject.add(payload);
      });
  Advert advert = Advert();
  advert.showIntersitial();
  runApp(MainMenu());
}
