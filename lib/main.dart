import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'databasehelper/dataBaseHelper.dart';
import 'pages/mainmenu.dart';

 void callbackDispatcher() async{
  Workmanager.executeTask((task, inputData) async{
    var db = DbHelper();
    await db.openNotificationBar();
    return Future.value(true);
  });
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
      callbackDispatcher,
  );
  Workmanager.registerPeriodicTask(
    "1", // tag / id
    "bgnotification", // task name
    existingWorkPolicy: ExistingWorkPolicy.append,
    frequency: Duration(minutes: 15),
  );
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, title: "Takvim", home: MainMenu()));
}