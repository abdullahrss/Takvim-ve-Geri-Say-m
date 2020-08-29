import 'package:flutter/material.dart';

class NotificationPicker extends StatefulWidget {

  var radioValue;

  @override
  _NotificationPickerState createState() => _NotificationPickerState();
}

class _NotificationPickerState extends State<NotificationPicker> {

  var radioGroupValue;

  @override
  void initState() {
    super.initState();
    radioGroupValue = "Zaman geldiğinde";
  }

  List<String> _choices = [
    "Hiçbir zaman",
    "Zaman geldiğinde",
    "5 dakika öncesinde",
    "15 dakika öncesinde",
    "30 dakika öncesinde",
    "1 saat öncesinde",
    "12 saat öncesinde",
    "1 gün öncesinde",
    "3 gün öncesinde",
    "1 hafta öncesinde"
  ];

  Widget notificationTimePicker() {
    return Container(
        height: 200,
        width: 75,
        padding: EdgeInsets.only(top: 8.0),
        child: ListView.builder(
            itemCount: _choices.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: RadioListTile(
                title: Text(_choices[index]),
                value: index,
                groupValue: radioGroupValue,
                onChanged: (currentRadio) {
                  setState(() {
                    radioGroupValue = currentRadio;
                    widget.radioValue = currentRadio;
                  });
                },
              ));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Bildirim zamanı",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
      children: <Widget>[
        Container(padding: EdgeInsets.only(left: 25.0), child: Text("Bildirim ne zaman çıksın ?",style: TextStyle(fontSize: 18),)),
        notificationTimePicker(),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Geri",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Ayarla",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
