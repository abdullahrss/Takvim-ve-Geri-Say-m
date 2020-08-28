import 'dart:async';
import 'dart:io' show Directory;

import 'package:ajanda/databasemodels/settingsModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/constants.dart';

class SettingsDbHelper {
  static SettingsDbHelper _databaseHelper; // Database'in tekil olmasi icin
  static Database _database;
  static final String _tablename = SettingsConstants.TABLE_NAME;
  static final String _columnTheme = SettingsConstants.COLUMN_THEME;
  static final String _columnFontName = SettingsConstants.COLUMN_FONTNAME;
  static final String _columnWarning = SettingsConstants.COLUMN_WARNING;

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

  /// Database initialize ediliyor
  static Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'dbsettings.db';

    /// Database yoksa olusturuyor varsa aciyor
    var eventsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return eventsDatabase;
  }

  /// Database olusturuluyor
  static void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $_tablename($_columnTheme TEXT, $_columnFontName TEXT,$_columnWarning INTEGER)');
  }

  /// Yeni gelen theme bilgisiyle database guncelleniyor
  Future<void> updateTheme(Setting setting) async {
    var db = await this.database;
    await db.rawQuery("UPDATE $_tablename SET $_columnTheme = '${setting.theme}';");
  }

  /// Font settings'i guncelleniyor
  Future<void> updateFont(Setting setting) async {
    var db = await this.database;
    await db.rawQuery("UPDATE $_tablename SET $_columnFontName = '${setting.fontName}';");
  }

  /// Warning Settings'i guncelleniyor
  Future<void> updateWarning(int e) async {
    var db = await this.database;
    await db.rawQuery("UPDATE $_tablename SET $_columnWarning = $e;");
  }

  Future<List<Setting>> getSettings() async {
    Database db = await this.database;
    var settingsMapList = await db.rawQuery("SELECT * FROM $_tablename");
    if (settingsMapList.length == 0 || settingsMapList == []) {
      await db.rawQuery(
          "INSERT INTO $_tablename ($_columnTheme,$_columnFontName,$_columnWarning) VALUES('light','DoppioOne',0);");
      settingsMapList = await db.rawQuery("SELECT * FROM $_tablename");
    }
    List<Setting> settingList = List<Setting>();
    for (int i = 0; i < settingsMapList.length; i++) {
      settingList.add(Setting.fromMap(settingsMapList[i]));
    }
    return settingList;
  }
}
