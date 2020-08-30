import 'package:ajanda/databasehelper/settingsHelper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void navigateToSettingsDialog(context) async {
  var sdb = SettingsDbHelper();
  bool val = false;
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Dikkat!"),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Sabit bildirim bazen düzgün çalışmayabilir. Düzgün çalışması için bilidirimleri açık olduğuna emin olun\n\nNot: Xiaomi telefonlarda uygulama ayarlarında Otomatik başlatma seçeneğinin açık olduğuna emin olun.",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Bir daha gösterme"),
                      ),
                      onPressed: () async {
                        await sdb.updateWarning(val ? 1 : 0);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        value: val,
                        onChanged: (v) => setState(() {
                          val = v;
                        }),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Tamam"),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Ayarlara Git"),
                      onPressed: () async {
                        openAppSettings();
                      },
                    )
                  ],
                )
              ],
            );
          },
        );
      });
}
