import 'package:ajanda/helpers/TURKISHtoEnglish.dart';
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
    radioGroupValue = protranslate["Zaman geldiğinde"][31];
  }

  List<String> _choices = [
    protranslate["Hiçbir zaman"][31],
    protranslate["Zaman geldiğinde"][31],
    protranslate["5 dakika öncesinde"][31],
    protranslate["15 dakika öncesinde"][31],
    protranslate["30 dakika öncesinde"][31],
    protranslate["1 saat öncesinde"][31],
    protranslate["12 saat öncesinde"][31],
    protranslate["1 gün öncesinde"][31],
    protranslate["3 gün öncesinde"][31],
    protranslate["1 hafta öncesinde"][31],
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
      title: Text(protranslate["Bildirim zamanı"][31],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
      children: <Widget>[
        Container(padding: EdgeInsets.only(left: 25.0), child: Text(protranslate["Bildirim ne zaman çıksın ?"][31],style: TextStyle(fontSize: 18),)),
        notificationTimePicker(),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  protranslate["Geri"][31],
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  protranslate["Ayarla"][31],
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
