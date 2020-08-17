import 'package:workmanager/workmanager.dart';
import '../databasehelper/dataBaseHelper.dart';

class BackGroundProcesses{

  static final BackGroundProcesses _backGroundProcesses = BackGroundProcesses._initializeTasks();

  factory BackGroundProcesses() => _backGroundProcesses;

  BackGroundProcesses._initializeTasks(){
    // Eskiyen tasklar varsa diye tüm tasklar iptal ediliyor
    Workmanager.cancelAll();
    // Yeni tasklar ve suregelen tasklar tekrardan ekleniyor
    // Arka planda calisacak fonksiyon initialize ediliyor
    Workmanager.initialize(
      callbackDispatcher,
    );
    // 15 dakikada bir periyodik olarak cagirilmasi icin ekleniyor
    Workmanager.registerPeriodicTask(
      "1", // id
      "bgnotification", // task name
      existingWorkPolicy: ExistingWorkPolicy.append,
      frequency: Duration(minutes: 15),
    );
  }
  // Arka planda calisacak task
  void callbackDispatcher() async{
    Workmanager.executeTask((task, inputData) async{
      var db = DbHelper();
      await db.openNotificationBar();
      return Future.value(true);
    });
  }
}