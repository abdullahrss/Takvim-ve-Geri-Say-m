import 'package:ajanda/pages/mainmenu.dart';
import 'package:flutter/material.dart';

Future<void> showMyDialog(context, {String title, String message, Function function}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Hayır', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Evet', style: TextStyle(fontSize: 16)),
            onPressed: () async {
              Navigator.of(context).pop();
              await function();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showWarningDialog(
  context,
  String explanation,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Dikkat!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(explanation),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Tamam'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
