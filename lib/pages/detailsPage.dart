import 'package:ajanda/helpers/ads.dart';
import 'package:flutter/material.dart';
import '../events/eventEditting.dart';

class Details extends StatefulWidget {
  final id;
  final title;
  final date;
  final startTime;
  final finishTime;
  final desc;
  final isActive;
  final choice;
  final countDownIsActive;
  final attachments;
  final isHTML;
  final ccController;
  final bbcController;
  final recipientController;
  final subjectController;
  final bodyController;

  Details(
      this.id,
      this.title,
      this.date,
      this.startTime,
      this.finishTime,
      this.desc,
      this.isActive,
      this.choice,
      this.countDownIsActive,
      this.attachments,
      this.isHTML,
      this.ccController,
      this.bbcController,
      this.recipientController,
      this.subjectController,
      this.bodyController
      );

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final Advert _advert = Advert();

  @override
  void initState() {
    super.initState();

    _advert.closeBannerAd();
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
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 25,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 35.0),
                                  ),
                                ),

                                //Container(child: DropDown(index))
                              ]),
                        ),

                      ),
                      if(widget.recipientController != null)
                        Row(children: <Widget>[
                          Expanded(
                            child: Text(
                                "   Mail atılacak kişi: "+widget.recipientController
                            ,style: TextStyle(fontSize: 15),),
                          )
                        ],),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Text(
                             widget.date +
                                "${widget.startTime != "null" ? ("  " + widget.startTime + "-" + widget.finishTime) : " - Tüm gün"}",
                            style: new TextStyle(fontSize: 15),
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
                            child: Text(widget.desc, maxLines: 1000),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        //Spacer()
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
                                        inputId: widget.id,
                                        inputTitle: widget.title,
                                        inputDate: widget.date,
                                        inputStartTime: widget.startTime,
                                        inputFinishTime: widget.finishTime,
                                        inputDesc: widget.desc,
                                        inputIsActive: widget.isActive,
                                        inputChoice: widget.choice,
                                        inputCountDownIsActive: widget.countDownIsActive,
                                        attachments: widget.attachments,
                                        isHTML: widget.isHTML,
                                        ccController: widget.ccController,
                                        bbcController: widget.bbcController,
                                        recipientController: widget.recipientController,
                                        subjectController: widget.subjectController,
                                        bodyController: widget.bodyController,
                                      ))));
                        },
                        elevation: 18,
                        child: Text("Düzenle"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
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
