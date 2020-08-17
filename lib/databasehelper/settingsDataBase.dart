import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory;

class SettingsHelper {
  static SettingsHelper _databaseHelper; // Database'in tekil olmasi icin
  static Database _database;

  static final String _tableName = "tblsettings";

  // 0 ==> Light mode
  // 1 ==> Dark mode
  static final String _columnAppMode = "mode";

  SettingsHelper._createInstance();

  factory SettingsHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = SettingsHelper._createInstance();
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
    String path = directory.path + 'tblsettings.db';

    // Database yoksa olusturuyor varsa aciyor
    var eventsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return eventsDatabase;
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $_tableName ($_columnAppMode INTEGER);");
  }

  int fromMap(Map input) {
    return input[_columnAppMode];
  }
  Map toMap(int input){
    var map = Map<String, dynamic>();
    map[_columnAppMode] = input;
  }

  // Databaseden app'in mode'unu alma
  Future<List<Map<String, dynamic>>> getAllStatus() async {
    Database db = await this.database;
    var result = await db.query(
      _tableName,
    );
    return result;
  }
  Future<List<int>> getStatusList() async {
    var eventMapList = await getAllStatus();
    int count = eventMapList.length;
    List eventList = List();
    for (int i = 0; i < count; i++) {
      eventList.add(fromMap(eventMapList[i]));
    }
    return eventList;
  }
  updateMode(int newStatus)async{
    Database db = await this.database;
    db.rawQuery("UPDATE $_tableName SET $_columnAppMode=$newStatus");
  }
}
