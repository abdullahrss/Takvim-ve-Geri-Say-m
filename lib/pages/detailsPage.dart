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
            child: Column(
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
                      if (widget.event.recipient != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "   Mail atılacak kişi: " + widget.event.recipient,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Text(
                            widget.event.date +
                                "${widget.event.startTime != "null" ? ("  " + widget.event.startTime + "-" + widget.event.finishTime) : " - Tüm gün"}",
                            style: TextStyle(fontSize: 15),
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
                            child: Text(widget.event.desc, maxLines: 1000),
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
                                        ),
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
