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
        style: TextStyle(color: Colors.black, fontSize: 18),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            if (newValue == 'Detaylar') {
              Event event = Event(
                id: widget.event.id,
                title: widget.event.title,
                date: widget.event.date,
                startTime: widget.event.startTime,
                finishTime: widget.event.finishTime,
                desc: widget.event.desc,
                isActive: widget.event.isActive,
                choice: widget.event.choice,
                countDownIsActive: widget.event.countDownIsActive,
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                            event: event,
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
            child: Text(
              value,
              style: TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
      ),
    );
  }
}
