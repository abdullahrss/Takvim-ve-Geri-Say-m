import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../databasemodels/events.dart';
import '../events/eventEditting.dart';

class Details extends StatefulWidget {
  final Event event;

  const Details({Key key, this.event}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map<int, String> _periodicTexts = {
    0: "",
    1: "Günlük tekrarlı",
    2: "Haftalık tekrarlı",
    3: "Aylık tekrarlı",
  };

  String calcDays(String frequency) {
    Map<int, String> weekdayToDay = {
      0: "Pazartesi",
      1: "Salı",
      2: "Çarşamba",
      3: "Perşembe",
      4: "Cuma",
      5: "Cumartesi",
      6: "Pazar"
    };

    String result="";

    for (int i = 0; i < frequency.length; i++) {
      if(frequency[i]=="1"){
        result+="${weekdayToDay[i]} ";
      }
    }
    result +="günleri tekrar eder.";
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detaylar"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Card(
                  elevation: 25,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.event.title,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 35.0),
                                ),
                              ),
                            ]),
                      ),
                      if (widget.event.recipient != "" || widget.event.recipient.length != 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "   Mail atılacak kişi: " + widget.event.recipient+"\n",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      if (widget.event.periodic != 0)
                        Container(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.event.periodic != 4
                                  ? _periodicTexts[widget.event.periodic]
                                  : calcDays(widget.event.frequency),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Text(
                            widget.event.date +
                                "${widget.event.startTime != "null" ? ("  " + widget.event.startTime + "-" + widget.event.finishTime) : " - Tüm gün"}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 25,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.event.desc,),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (EventEdit(
                                        event: Event(
                                            id: widget.event.id,
                                            title: widget.event.title,
                                            date: widget.event.date,
                                            startTime: widget.event.startTime,
                                            finishTime: widget.event.finishTime,
                                            desc: widget.event.desc,
                                            isActive: widget.event.isActive,
                                            choice: widget.event.choice,
                                            countDownIsActive: widget.event.countDownIsActive,
                                            attachments: widget.event.attachments,
                                            cc: widget.event.cc,
                                            bb: widget.event.bb,
                                            recipient: widget.event.recipient,
                                            subject: widget.event.subject,
                                            body: widget.event.body,
                                            periodic: widget.event.periodic,
                                            frequency: widget.event.frequency),
                                      ))));
                        },
                        elevation: 18,
                        child: Text("Düzenle"),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        splashColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
