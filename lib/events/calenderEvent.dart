import 'package:flutter/material.dart';
import '../events/addevent.dart';
import '../Widgets/dropdown.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../databasemodels/events.dart';

class CalanderEvent extends StatefulWidget {
  final tarih;

  CalanderEvent(this.tarih);

  @override
  _CalanderEventstate createState() => _CalanderEventstate();
}

class _CalanderEventstate extends State<CalanderEvent> {
  var _db = DbHelper();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Etkinlik",
          style: TextStyle(fontSize: 22),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddEvent(inputDate:widget.tarih)));
              })
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: FutureBuilder(
          future: _db.getEventCalander(widget.tarih),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Text("Loading....."),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                      child: Card(
                        elevation: 25,
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(snapshot.data[index].title,
                                          style: TextStyle(fontSize: 30.0),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Container(
                                        child: DropDown(Event(
                                            id: snapshot.data[index].id,
                                            title: snapshot.data[index].title,
                                            date: snapshot.data[index].date,
                                            startTime: snapshot.data[index].startTime,
                                            finishTime: snapshot.data[index].finishTime,
                                            desc: snapshot.data[index].desc,
                                            isActive: snapshot.data[index].isActive,
                                            choice: snapshot.data[index].choice)))
                                  ]),
                              Padding(
                                padding: const EdgeInsets.only(top: 1.0, bottom: 16.0),
                                child: Row(children: <Widget>[
                                  Text(
                                    "${snapshot.data[index].date} - ${snapshot.data[index].startTime == "null" ? " Tüm gün" : "${snapshot.data[index].startTime} - ${snapshot.data[index].finishTime}"}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Spacer()
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(snapshot.data[index].desc,
                                          maxLines: 2, overflow: TextOverflow.ellipsis),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    //Spacer()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}