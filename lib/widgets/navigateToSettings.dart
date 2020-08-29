import 'package:flutter/material.dart';

void navigateToSettingsDialog(context) {
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
                      child:Text("okay brah"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Checkbox(
                      value: val,
                      onChanged: (v) => setState((){val=v;}),
                    ),

                  ],
                ),
              ],
            );
          },
        );
      });
}
