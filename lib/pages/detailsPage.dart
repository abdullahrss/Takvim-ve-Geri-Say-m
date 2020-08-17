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

  Details(this.id, this.title, this.date, this.startTime, this.finishTime,
      this.desc,this.isActive,this.choice, this.countDownIsActive);

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
              _advert.showBannerAd();
//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => MainMenu()));
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
                                  widget.title,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 40.0),
                                ),
                              ),
                              //Container(child: DropDown(index))
                            ]),
                      ),
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
