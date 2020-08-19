import 'package:ajanda/databasemodels/settingsModel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../databasehelper/settingsHelper.dart';
import '../widgets/showDialog.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../pages/mainmenu.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Tema icin gerekli switch valuesi
  bool _switchValue = false;

  // Dropdownmenu icin gerekli item degeri
  String _dropDownValue = "Bangers";
  List<String> _fontNamesList = [
    "Bangers",
    "DancingScript",
    "DoppioOne",
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
      appBar: AppBar(title: Text('Ayarlar')),
      body: Container(
        padding: const EdgeInsets.fromLTRB(22.0, 4.0, 20.0, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Dark Tema",
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
                    var _sdb = SettingsDbHelper();
                    var setting;
                    await _sdb.getSettings().then((value) async {
                      setting = value[0];
                    });
                    _switchValue
                        ? DynamicTheme.of(context).setThemeData(
                            ThemeData(
                              brightness: Brightness.dark,
                              fontFamily: setting.fontName,
                            ),
                          )
                        : DynamicTheme.of(context).setThemeData(
                            ThemeData(
                              brightness: Brightness.light,
                              fontFamily: setting.fontName,
                            ),
                          );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Bütün etkinlikeri sil!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showMyDialog(context,
                        title: "Dikkat",
                        message: 'Bütün etkinlikleri silmek istediğinize emin misiniz.',
                        function: () {
                      _db.clearDb();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Vakiti geçmiş eventleri sil!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    //_db.clearDb();
                    showMyDialog(context,
                        title: "Dikkat",
                        message:
                            'Bütün tarihi geçmiş etkinlikleri silmek istediğinize emin misiniz.',
                        function: () {
                      // _db.clearoldevent();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Yazı fontları",
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
                      DynamicTheme.of(context).setThemeData(
                        ThemeData(
                          brightness: DynamicTheme.of(context).brightness,
                          fontFamily: _dropDownValue,
                        ),
                      );
                      var temp = Setting();
                      temp.fontName = _dropDownValue;
                      _sdb.updateEvent(temp);
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
