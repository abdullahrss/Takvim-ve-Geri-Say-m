import 'package:ajanda/databasemodels/settingsModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory;
import '../helpers/constants.dart';

class SettingsDbHelper {
  static SettingsDbHelper _databaseHelper; // Database'in tekil olmasi icin
  static Database _database;
  static final String _tablename = SettingsConstants.TABLE_NAME;
  static final String _columnFontName = SettingsConstants.COLUMN_FONTNAME;

  SettingsDbHelper._createInstance();

  factory SettingsDbHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = SettingsDbHelper._createInstance();
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
    String path = directory.path + 'dbsettings.db';

    // Database yoksa olusturuyor varsa aciyor
    var eventsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return eventsDatabase;
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $_tablename($_columnFontName TEXT)');
  }

//  // Database'e setting ekliyor
//  Future<void> insertSetting(Setting setting) async {
//    Database db = await this.database;
//    await db.rawQuery("INSERT INTO $_tablename ($_columnFontName) VALUES('${setting.fontName}');");
//  }
  // Settings guncelleniyor
  Future<void> updateEvent(Setting setting) async {
    var db = await this.database;
    await db.rawQuery("UPDATE $_tablename SET $_columnFontName = '${setting.fontName}';");
  }

  Future<List<Setting>> getSettings() async {
    Database db = await this.database;
    var settingsMapList = await db.query(_tablename);
    if (settingsMapList.length == 0) {
      await db.rawQuery("INSERT INTO $_tablename ($_columnFontName) VALUES('DoppioOne');");
    }
    List<Setting> settingList = List<Setting>();
    for (int i = 0; i < settingsMapList.length; i++) {
      settingList.add(Setting.fromMap(settingsMapList[i]));
    }
    return settingList;
  }
}
