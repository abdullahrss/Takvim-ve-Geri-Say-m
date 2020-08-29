import 'package:ajanda/databasehelper/settingsHelper.dart';
import 'package:flutter/material.dart';

void navigateToSettingsDialog(context) {
  var sdb = SettingsDbHelper();
  bool val = false;
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                Text("ATTANTION PLS"),
                Text("STAY BEHIND THE YELLOW LINE"),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("okay brah"),
                      onPressed: () {
                        sdb.updateWarning(val?1:0);                 
                        Navigator.pop(context);
                      },
                    ),
                    Checkbox(
                      value: val,
                      onChanged: (v) => setState(() {
                        val = v;
                      }),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      });
}
