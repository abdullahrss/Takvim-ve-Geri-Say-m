import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/TURKISHtoEnglish.dart';
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
    1: protranslate["Günlük tekrarlı"][31],
    2: protranslate["Haftalık tekrarlı"][31],
    3: protranslate["Aylık tekrarlı"][31],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(protranslate["Detaylar"][31]),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                    child: Row(children: <Widget>[
                      Text(
                        widget.event.date +
                            "${widget.event.startTime != "null" ? ("  " + widget.event.startTime + "-" + widget.event.finishTime) : " - ${protranslate["Tüm gün"][31]}"}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ]),
                  ),
                  if((widget.event.recipient != "" || widget.event.recipient.length != 0)||(widget.event.periodic != 0))
                  Container(
                    padding: const EdgeInsets.only(right: 64.0),
                    child: Divider(
                      thickness: 1,
                      color: Colors.black38,
                    ),
                  ),
                  if (widget.event.recipient != "" || widget.event.recipient.length != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          protranslate["Mail atılacak "][31] + printMails(widget.event.recipient),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  if (widget.event.periodic != 0)
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.event.periodic != 4
                              ? _periodicTexts[widget.event.periodic]
                              : calcDays(widget.event.frequency),
                          maxLines: 9,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
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
                        child: Text(
                          widget.event.desc,
                        ),
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
                    color: Colors.blue,
                    child: Text(
                      protranslate["Düzenle"][31],
                      style: TextStyle(fontSize: 18),
                    ),
                    splashColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calcDays(String frequency) {
    Map<int, String> weekdayToDay = {
      0: protranslate["Pazartesi"][31],
      1: protranslate["Salı"][31],
      2: protranslate["Çarşamba"][31],
      3: protranslate["Perşembe"][31],
      4: protranslate["Cuma"][31],
      5: protranslate["Cumartesi"][31],
      6: protranslate["Pazar"][31]
    };

    String result = "${protranslate["Tekrar günleri"][31]} :\n";

    for (int i = 0; i < frequency.length; i++) {
      if (frequency[i] == "1") {
        result += "- ${weekdayToDay[i]}\n";
      }
    }

    /// Sondaki fazla virgulden kurtulmak icin
    result = result.substring(0, result.length - 1);
    return result;
  }

  String printMails(String recipients) {
    String result = recipients.split(",").length > 1 ? "${protranslate["kişiler"][31]} :\n" : "${protranslate["kişi"][31]} :\n";
    recipients.split(",").forEach((element) {
      result += element.trim() + "\n";
    });
    return result;
  }
}
