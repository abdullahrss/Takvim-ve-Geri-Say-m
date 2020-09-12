import 'package:ajanda/databasemodels/settingsModel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../databasehelper/dataBaseHelper.dart';
import '../databasehelper/settingsHelper.dart';
import '../widgets/showDialog.dart';
import '../helpers/TURKISHtoEnglish.dart';
import 'mainmenu.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  /// Tema icin gerekli switch valuesi
  bool _switchValue = false;

  /// Font dropdownmenusu icin gerekli olanlar
  String _dropDownValue = "Bangers";
  List<String> _fontNamesList = [
    "Bangers",
    "DancingScript",
    "IndieFlower",
    "Dosis",
    "Inconsolata",
    "LibreBaskerville",
    "Lora",
    "Merriweather",
    "Pangolin",
    "Playfair",
    "Raleway",
    "RussoOne",
    "Titillium",
    "Quicksand"
  ];

  /// Dil dropdownmenusu icin gerekli olanlar
  String _dropdownLanguageValue = 'Türkçe';
  List<String> _languageDropdownList = [
    "English",
    "Türkçe",
  ];
  List<Image> _imageList = [
    Image(
      image: AssetImage("assets/images/united-kingdom-flag-icon-128.png"),
      height: 30,
      width: 30,
    ),
    Image(
      image: AssetImage("assets/images/turkey-flag-icon-128.png"),
      height: 30,
      width: 30,
    ),
  ];

  var _db = DbHelper();
  var _sdb = SettingsDbHelper();

  @override
  void initState() {
    super.initState();
    _switchValue = DynamicTheme.of(context).brightness == Brightness.dark ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(protranslate['Ayarlar'][31])),
      body: Container(
        padding: const EdgeInsets.fromLTRB(22.0, 4.0, 20.0, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Dil (language)",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButton<String>(
                  value: _dropdownLanguageValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String newValue) async {
                    setState(() {
                      _dropdownLanguageValue = newValue;
                    });
                    var temp = Setting();
                    temp.language = _languageDropdownList.indexOf(_dropdownLanguageValue);
                    await _sdb.updateLanguage(temp);
                  },
                  items: _languageDropdownList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _imageList[_languageDropdownList.indexOf(value)],
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    protranslate["Karanlık Tema"][31],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Switch(
                  value: _switchValue,
                  onChanged: (val) async {
                    setState(() {
                      _switchValue = val;
                    });

                    /// theme'i update etme
                    var sett = Setting();
                    sett.theme = _switchValue ? 'dark' : 'light';
                    await _sdb.updateTheme(sett);
                    DynamicTheme.of(context)
                        .setBrightness(_switchValue ? Brightness.dark : Brightness.light);
                    await _sdb.getSettings().then((settings) {
                      DynamicTheme.of(context).setThemeData(ThemeData(
                        brightness: _switchValue ? Brightness.dark : Brightness.light,
                        fontFamily: settings[0].fontName,
                        floatingActionButtonTheme: FloatingActionButtonThemeData(
                          foregroundColor: Colors.green,
                        ),
                      ));
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  protranslate["Bütün etkinlikeri sil!"][31],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await showMyDialog(context,
                        title: protranslate["Bütün etkinlikeri sil!"][31],
                        message: protranslate['Bütün etkinlikleri silmek istediğinize emin misiniz.'][31],
                        function: () async {
                      await _db.clearDb();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainMenu()),
                      );
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  protranslate["Vakiti geçmiş etkinlikleri sil!"][31],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await showMyDialog(context,
                        title: protranslate["Dikkat"][31],
                        message:
                            protranslate['Bütün tarihi geçmiş etkinlikleri silmek istediğinize emin misiniz.'][31],
                        function: () async {
                      await _db.clearOldEvents();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainMenu()),
                      );
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  protranslate["Yazı fontları"][31],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: DropdownButtonFormField(
                    items: _fontNamesList.map((String font) {
                      return DropdownMenuItem(
                        value: font,
                        child: Text(
                          font,
                          style: TextStyle(fontFamily: font, fontSize: 18, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    value: _dropDownValue,
                    onChanged: (newValue) async {
                      setState(() => _dropDownValue = newValue);
                      var temp = Setting();
                      temp.fontName = _dropDownValue;
                      await _sdb.updateFont(temp);
                      await _sdb.getSettings().then((settings) {
                        DynamicTheme.of(context).setThemeData(ThemeData(
                          brightness:
                              settings[0].theme == "dark" ? Brightness.dark : Brightness.light,
                          fontFamily: _dropDownValue,
                          floatingActionButtonTheme: FloatingActionButtonThemeData(
                            foregroundColor: Colors.green,
                          ),
                        ));
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
