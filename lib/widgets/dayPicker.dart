import 'package:flutter/material.dart';


class DayPickerForPeriodic extends StatefulWidget {

  List<bool> days;

  DayPickerForPeriodic({Key key, this.days}) : super(key: key);

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
    if(widget.days!=null){
      _pazartesi = widget.days[0];
      _sali = widget.days[1];
      _carsamba = widget.days[2];
      _persembe = widget.days[3];
      _cuma = widget.days[4];
      _cumartesi = widget.days[5];
      _pazar = widget.days[6];
    }
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
        Container(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: Divider(height: 0.5,)),
        CheckboxListTile(
          title: Text("Salı"),
          value: _sali,
          onChanged: (v) => setState((){_sali=v;}),
        ),
        Container(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: Divider(height: 0.5,)),
        CheckboxListTile(
          title: Text("Çarşamba"),
          value: _carsamba,
          onChanged: (v) => setState((){_carsamba=v;}),
        ),
        Container(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: Divider(height: 0.5,)),
        CheckboxListTile(
          title: Text("Perşembe"),
          value: _persembe,
          onChanged: (v) => setState((){_persembe=v;}),
        ),
        Container(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: Divider(height: 0.5,)),
        CheckboxListTile(
          title: Text("Cuma"),
          value: _cuma,
          onChanged: (v) => setState((){_cuma=v;}),
        ),
        Container(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: Divider(height: 0.5,)),
        CheckboxListTile(
          title: Text("Cumartesi"),
          value: _cumartesi,
          onChanged: (v) => setState((){_cumartesi=v;}),
        ),
        Container(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: Divider(height: 0.5,)),
        CheckboxListTile(
          title: Text("Pazar"),
          value: _pazar,
          onChanged: (v) => setState((){_pazar=v;}),
        ),
        Container(padding: const EdgeInsets.only(left: 8.0,right: 8.0),child: Divider(height: 0.5,)),
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
