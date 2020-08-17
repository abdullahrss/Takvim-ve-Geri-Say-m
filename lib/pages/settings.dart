import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../databasehelper/settingsDataBase.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static var mode;
  var status = SettingsHelper().getStatusList().then((value) => mode = value[0]);
  bool _switchValue = mode==null ? false : (mode==0?false:true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Ayarlar')),
      body:
      Container(
        padding: const EdgeInsets.fromLTRB(22.0, 4.0, 20.0, 0),
        child: Row(
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
                  var helper = SettingsHelper();
                  helper.updateMode(val?0:1);
                  _switchValue = val;
                  _switchValue ?
                  DynamicTheme.of(context).setBrightness(Brightness.dark):
                  DynamicTheme.of(context).setBrightness(Brightness.light);
                });
              },
            ),
          ],
        ),
      ),

    );
  }
}
