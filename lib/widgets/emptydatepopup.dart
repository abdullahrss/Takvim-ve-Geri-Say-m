import 'package:flutter/material.dart';
import '../events/addevent.dart';

Future<void> showMyDialog(context,date) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Boş gün'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Bu tarihe etkinlik eklemek ister misiniz ?',style: TextStyle(fontSize: 18,),textAlign: TextAlign.left,),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Hayır',style:TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Evet',style:TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEvent(inputDate: date,)));
            },
          ),
        ],
      );
    },
  );
}