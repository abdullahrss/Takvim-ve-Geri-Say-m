import 'package:flutter/material.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../databasemodels/events.dart';
import '../pages/mainmenu.dart';
import '../pages/detailsPage.dart';

class DropDown extends StatefulWidget {
  final Event event;
  DropDown(this.event);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  var _db = DbHelper();
  String dropdownValue = 'Detaylar';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        style: TextStyle(color: Colors.black,fontSize: 18),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            if (newValue == 'Detaylar') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                          widget.event.id,
                          widget.event.title,
                          widget.event.date,
                          widget.event.startTime,
                          widget.event.finishTime,
                          widget.event.desc,
                          widget.event.isActive,
                          widget.event.choice,
                          widget.event.countDownIsActive,
                      )));
            } else if (newValue == 'Sil') {
              _db.deleteEvent(widget.event.id);
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
            }
          });
        },
        items: <String>[
          'Detaylar',
          'Sil',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,style: TextStyle(fontSize: 20 ),),
          );
        }).toList(),
      ),
    );
  }
}
