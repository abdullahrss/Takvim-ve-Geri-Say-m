import '../widgets/showDialog.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../pages/mainmenu.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchValue = false;
  var _db = DbHelper();

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
                  onChanged: (val) {
                    setState(() {
                      _switchValue = val;
                      _switchValue
                          ? DynamicTheme.of(context).setBrightness(Brightness.dark)
                          : DynamicTheme.of(context).setBrightness(Brightness.light);
                    });
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
                    _db.clearDb();
                    showMyDialog(context,
                        title: "Dikkat",
                        message: 'Bütün etkinlikleri silmek istediğinize emin misiniz.',
                        function: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
