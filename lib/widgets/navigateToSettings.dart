import 'package:ajanda/databasehelper/settingsHelper.dart';
import 'package:ajanda/helpers/TURKISHtoEnglish.dart';
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
              title: Text(protranslate["Dikkat!"][31]),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    protranslate["Sabit bildirim bazen düzgün çalışmayabilir. Düzgün çalışması için bildirimlerin açık olduğuna emin olun\n\nNot: Xiaomi telefonlarda uygulama ayarlarında Otomatik başlatma seçeneğinin açık olduğuna emin olun."][31],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(protranslate["Bir daha gösterme"][31]),
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
                      child: Text(protranslate["Tamam"][31]),
                      onPressed: () async {
                        await sdb.updateWarning(val ? 1 : 0);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(protranslate["Ayarlara Git"][31]),
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
