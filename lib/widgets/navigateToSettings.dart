import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../databasehelper/settingsHelper.dart';
import '../helpers/constants.dart';
import '../helpers/languageDictionary.dart';

void navigateToSettingsDialog(context) async {
  var sdb = SettingsDbHelper();
  bool val = false;
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(proTranslate["Dikkat!"][Language.languageIndex]),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    proTranslate["Sabit bildirim bazen düzgün çalışmayabilir. Düzgün çalışması için bildirimlerin açık olduğuna emin olun\n\nNot: Xiaomi telefonlarda uygulama ayarlarında Otomatik başlatma seçeneğinin açık olduğuna emin olun."][Language.languageIndex],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(proTranslate["Bir daha gösterme"][Language.languageIndex]),
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
                      child: Text(proTranslate["Tamam"][Language.languageIndex]),
                      onPressed: () async {
                        await sdb.updateWarning(val ? 1 : 0);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(proTranslate["Ayarlara Git"][Language.languageIndex]),
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
