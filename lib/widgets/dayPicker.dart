import 'package:flutter/material.dart';


class DayPickerForPeriodic extends StatefulWidget {

  List<bool> days;

  @override
  _DayPickerForPeriodicState createState() => _DayPickerForPeriodicState();
}

class _DayPickerForPeriodicState extends State<DayPickerForPeriodic> {

  bool _pazartesi = false;
  bool _sali = false;
  bool _carsamba = false;
  bool _persembe = false;
  bool _cuma = false;
  bool _cumartesi = false;
  bool _pazar = false;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Günler",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
      children: <Widget>[
        CheckboxListTile(
          title: Text("Pazartesi"),
          value: _pazartesi,
          onChanged: (v) => setState((){_pazartesi=v;}) ,
        ),
        CheckboxListTile(
          title: Text("Salı"),
          value: _sali,
          onChanged: (v) => setState((){_sali=v;}),
        ),
        CheckboxListTile(
          title: Text("Çarşamba"),
          value: _carsamba,
          onChanged: (v) => setState((){_carsamba=v;}),
        ),
        CheckboxListTile(
          title: Text("Perşembe"),
          value: _persembe,
          onChanged: (v) => setState((){_persembe=v;}),
        ),
        CheckboxListTile(
          title: Text("Cuma"),
          value: _cuma,
          onChanged: (v) => setState((){_cuma=v;}),
        ),
        CheckboxListTile(
          title: Text("Cumartesi"),
          value: _cumartesi,
          onChanged: (v) => setState((){_cumartesi=v;}),
        ),
        CheckboxListTile(
          title: Text("Pazar"),
          value: _pazar,
          onChanged: (v) => setState((){_pazar=v;}),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: Text("Geri",style: TextStyle(color: Colors.blueAccent,),),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Tamam",style: TextStyle(color: Colors.blueAccent,),),
              onPressed: (){
                setState(() {
                  widget.days = [_pazartesi,_sali,_carsamba,_persembe,_cuma,_cumartesi,_pazar];
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
