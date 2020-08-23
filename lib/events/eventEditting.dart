import 'dart:io';

import 'package:ajanda/helpers/ads.dart';
import 'package:ajanda/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/mainmenu.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../databasemodels/events.dart';
import '../helpers/validateEmpty.dart';
import '../widgets/notificationtimepicker.dart';

class EventEdit extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();

  int id;
  String title;
  String date;
  String startTime;
  String finishTime;
  String desc;
  int isActive;
  String choice;
  int countDownIsActive;
  String attachments;
  String isHTML;
  String ccController;
  String bbcController;
  String recipientController;
  String subjectController;
  String bodyController;

  EventEdit({int inputId, String inputTitle, String inputDate, String inputStartTime, String inputFinishTime, String inputDesc, int inputIsActive, String inputChoice, int inputCountDownIsActive,String attachments,
    String isHTML,
    String ccController,
    String bbcController,
    String recipientController,
    String subjectController,
    String bodyController}){

    this.id = inputId;
    this.title = inputTitle;
    this.date = inputDate;
    this.startTime = inputStartTime;
    this.finishTime = inputFinishTime;
    this.desc = inputDesc;
    this.isActive = inputIsActive;
    this.choice = inputChoice;
    this.countDownIsActive = inputCountDownIsActive;
    this.attachments = attachments;
    this.isHTML = isHTML;
    this.ccController = ccController;
    this.bbcController = bbcController;
    this.recipientController = recipientController;
    this.subjectController = subjectController;
    this.bodyController = bodyController;
  }
}

class _AddEventState extends State<EventEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Advert _advert = Advert();

  var _db = DbHelper();

  String _selectedDate;
  String _selectedStartHour;
  String _selectedFinishHour;
  String errmsg = "";

  bool _iscorrect = true;
  bool _isfullday = false;
  bool _duplicite = false;
  bool _iscountdownchecked = false;
  bool _timeisok = true;
  var _radioValue;
  bool _switchValue;

  final _titlecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();

  List<String> _attachments = [];
  bool _isHTML = false;

  final _ccController = TextEditingController(

  );

  final _bbcController = TextEditingController(

  );

  final _recipientController = TextEditingController(

  );

  final _subjectController = TextEditingController();

  final _bodyController = TextEditingController(

  );
  void _picker() async {
    final File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _attachments.add(pick.path);
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.attachments != null){
    var deneme = widget.attachments.split("-");
    for(int i=0;i<deneme.length;i++){
      _attachments.add(deneme[i]);
    }}

    _isHTML = widget.isHTML == "false" ? false : true;
    _ccController.text = widget.ccController == "null" ? "" : widget.ccController;
    _bbcController.text = widget.bbcController == "null" ? "" : widget.bbcController;
    _recipientController.text = widget.recipientController;
    _subjectController.text = widget.subjectController;
    _bodyController.text = widget.bodyController == "null" ? "" : widget.bodyController;
    


    _titlecontroller.text = widget.title;
    _descriptioncontroller.text = widget.desc;
    _selectedFinishHour = widget.finishTime;
    _selectedStartHour = widget.startTime;
    _selectedDate = widget.date;
    _iscountdownchecked = widget.isActive == 1 ? true : false;
    setState(() {

      _switchValue = widget.countDownIsActive==1?true:false;
      _isfullday = _selectedStartHour == "null" ? true : false;
    });
  }

  @override
  void dispose() {
    _ccController.dispose();
    _bbcController.dispose();
    _recipientController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    _titlecontroller.dispose();
    _descriptioncontroller.dispose();
    //_advert.showBannerAd();
    super.dispose();
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dikkat!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Alıcı mail boş bırakılmaz!'),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog3() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dikkat!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Konu boş bırakılamaz!')
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showMyDialog2() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Mail Gönder"),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _recipientController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Alıcı adresi',

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _ccController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CC',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _bbcController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'BBC',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Konu',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _bodyController,
                          maxLines: 10,
                          decoration: InputDecoration(
                              labelText: 'Mail', border: OutlineInputBorder()),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text('HTML'),
                        onChanged: (bool value) {
                          setState(() {
                            _isHTML = value;
                          });
                        },
                        value: _isHTML,
                      ),
                      ..._attachments.map(
                            (item) => Text(
                          item,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        elevation: 18,
                        onPressed: _picker,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            Text("  Resim ekle",style: TextStyle(color: Colors.white),)
                          ],
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        splashColor: Colors.blue,
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed:()  {
                          if(_recipientController.text == ""){
                            _showMyDialog();
                          }else if(_subjectController.text == ""){
                            _showMyDialog3();
                          }else{Navigator.of(context).pop();}},
                        elevation: 18,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            Text("  Kaydet",style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        splashColor: Colors.blue,
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed:()  {

                          Navigator.of(context).pop();},
                        elevation: 18,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            Text("  Kapat",style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        splashColor: Colors.blue,
                      ),
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etkinliği Düzenle"),
      ),

      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                  width: MediaQuery.of(context).size.width - 126,
                  child: TextFormField(
                    maxLength: 50,
                    controller: _titlecontroller,
                    decoration: InputDecoration(
                      //hintText: widget.title,
                      labelText: "Etkinliği Düzenle",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return value.isEmpty ? "Etkinlik ismi boş bırakılamaz" : null;
                    },

                  )),
//              IconButton(icon: Icon(Icons.add,),onPressed: (){
//                _db.getEventList().then((value) {
//                  for(int i =0;i<value.length;i++) {
//                    print(value[i].recipientController);
//                  }});}),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 3,
                  thickness: 3,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(22.0, 4.0, 22.0, 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.date_range),
                            Text(
                              "$_selectedDate",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            )
                          ],
                        ),
                        if (!_isfullday)
                          Row(
                            children: <Widget>[
                              Icon(Icons.timer),
                              Text(
                                "${_selectedStartHour == "null" ? "Tüm gün" : _selectedStartHour}",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              )
                            ],
                          ),
                        if (!_isfullday)
                          Row(
                            children: <Widget>[
                              Icon(Icons.timer_off),
                              Text(
                                "${_selectedFinishHour == "null" ? "Tüm gün" : _selectedFinishHour}",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                    IconButton(
                      iconSize: 25,
                      onPressed: () {
                        if (!_isfullday) {
                          showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                          ).then((value) {
                            setState(() {
                              _selectedFinishHour = (value.hour.toString().length == 1
                                      ? "0" + value.hour.toString()
                                      : value.hour.toString()) +
                                  ":" +
                                  (value.minute.toString().length == 1
                                      ? "0" + value.minute.toString()
                                      : value.minute.toString());
                            });
                          });
                          showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                          ).then((value) {
                            setState(() {
                              _selectedStartHour = (value.hour.toString().length == 1
                                      ? "0" + value.hour.toString()
                                      : value.hour.toString()) +
                                  ":" +
                                  (value.minute.toString().length == 1
                                      ? "0" + value.minute.toString()
                                      : value.minute.toString());
                            });
                          });
                        }
                        showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              var month = value.month.toString().length == 1
                                  ? "0" + value.month.toString()
                                  : value.month.toString();
                              var day = value.day.toString().length == 1
                                  ? "0" + value.day.toString()
                                  : value.day.toString();
                              _selectedDate = value.year.toString() + "-" + month + "-" + day;
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.add_circle),
                    ),
                    // Notification ayarlari
                    Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: IconButton(
                        icon: Icon(Icons.notifications_active),
                        onPressed: () async {
                          var dialog = NotificationPicker();
                          await showDialog(context: context, child: dialog);
                          setState(() {
                            _radioValue = dialog.radioValue;
                          });
                        },
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.mail),
                        onPressed: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => EmailSender()));
                          showMyDialog2();
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 3,
                  thickness: 3,
                ),
              ),
              if (!_iscorrect || _duplicite || !_timeisok || errmsg != "")
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 4.0),
                  child: Text(
                    errmsg,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              // Butun gun secenegi
              Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _isfullday,
                            onChanged: (value) => {
                              setState(() {
                                _isfullday = value;
                              })
                            },
                          ),
                          Text(
                            "Bütün gün",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      // Geri sayim aktiflestirmesi
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Checkbox(
                              value: _iscountdownchecked,
                              onChanged: (bool value) {
                                setState(() {
                                  _iscountdownchecked = value;
                                });
                              },
                            ),
                            Text(
                              "Geri sayım etkinleştir",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(22.0, 4.0, 20.0, 0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _switchValue,
                      onChanged: (val) {
                        setState(() {
                          _switchValue = val;
                        });
                      },
                    ),
                    Text(
                      "Sabit bildirim",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                        icon: Icon(Icons.info),
                        onPressed: (){
                          showMyDialog(
                            context,
                            title: "Uyarı!",
                            message: "Sabit bildirim uyglama açıksa 1 dakikada bir güncellenir uygulama kapalı ise 15 dakikada bir güncellenir!",
                            function: () =>  Navigator.of(context).pop(),
                          );
                        }
                    )
                  ],
                ),
              ),
              // Etkinlik aciklamasi
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
                height: 200.0,
                child: TextField(
                  controller: _descriptioncontroller,
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelText: "Etkinlik açıklaması ...",
                    hintText: "Etkinlik detaylarının girileceği alan...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              // Temizle ve kaydet butonlari
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      elevation: 18,
                      onPressed: () => {clearAreas()},
                      child: Text("Temizle"),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.blue,
                    ),
                    RaisedButton(
                      onPressed: () => {validateandsave()},
                      elevation: 18,
                      child: Text("Kaydet"),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  List<int> parseHours(String value) {
    List<String> strHours = value.split(":");
    List<int> intHours = [];
    intHours.add(int.parse(strHours[0]));
    intHours.add(int.parse(strHours[1]));
    return intHours;
  }

  void clearAreas() {
    _titlecontroller.clear();
    _descriptioncontroller.clear();
    _iscountdownchecked = false;
    _isfullday = false;
  }

  void validateandsave() async {
    final FormState state = _formKey.currentState;
    // Duzenlecenek event'in oldugu gun tum gun suren etkinlik var mi diye bakiyor
    await _db.isFullDay(widget.date, id:widget.id).then((value) {
      setState(() {
        _duplicite = value;
      });
    });
    // Eger tum gun suren etkinlik yoksa istenilen etkinlik saatlerinin uygunluguna bakıyor
    if (!_duplicite) {
      await _db.isTimeOk(widget.date).then((value) {
        setState(() {
          _timeisok =
              validateDayIsEmpty(value, _selectedStartHour, _selectedFinishHour, id: widget.id);
        });
      });
    }
    // Olasi hatalarin mesajlari olusturuluyor
    setState(() {
      // Eger istenilen gunde tum gun etkinlik varsa hata mesaji yaziliyor
      errmsg = _duplicite == false ? "" : "Bu gün başka bir etkinliğiniz var\n";
      // Zaman degistirilmek istenilen zaman baska etkinler ile zamani cakisiyorsa hata mesaji yaziliyor
      errmsg += _timeisok == false ? "Bu saatlerde başka bir etkinlik var\n" : "";
      // Eger tum gun degilse baslangic ve bitis zamanlari kontrol ediliyor olumsuzluk varsa hata mesaji yaziliyor
      try {
        if (!_isfullday) {
          _iscorrect = parseHours(_selectedFinishHour)[0] < parseHours(_selectedStartHour)[0] ||
                  (parseHours(_selectedFinishHour)[0] == parseHours(_selectedStartHour)[0] &&
                      parseHours(_selectedFinishHour)[1] < parseHours(_selectedStartHour)[1])
              ? false
              : true;
          errmsg += _iscorrect == false ? "Bitiş zamanı başlangıç zamanından önce olamaz\n" : "";
        }
      } catch (e) {
        print("[ERROR] [EVENTEDITTING] $e");
        // Tüm gün olan eventi tüm günden cikartip saat secilmezse 
        errmsg += "Tüm gün işaretli değilse saat girmelisiniz\n";
      }
    });
    if (state.validate() && (_iscorrect) && (_timeisok) && (errmsg == "")) {
      String resimler = "";
      for(int i=0;i<_attachments.length;i++){
        resimler+= "-${_attachments[i]}";
      }

      var newEvent = _isfullday
          ? Event(
              title: _titlecontroller.text,
              date: _selectedDate,
              desc: _descriptioncontroller.text,
              isActive: _iscountdownchecked ? 1 : 0,
              choice: _radioValue.toString(),
              countDownIsActive: _switchValue ? 1 : 0,
              attachments: resimler,
              isHTML: _isHTML.toString(),
              ccController: _ccController.text,
              bbcController: _bbcController.text,
              recipientController: _recipientController.text,
              subjectController: _subjectController.text,
              bodyController: _bodyController.text,
            )
          : Event(
              title: _titlecontroller.text,
              date: _selectedDate,
              startTime: _selectedStartHour,
              finishTime: _selectedFinishHour,
              desc: _descriptioncontroller.text,
              isActive: _iscountdownchecked ? 1 : 0,
              choice: _radioValue == null ? "0" : _radioValue.toString(),
              countDownIsActive: _switchValue ? 1 : 0,
              attachments: _attachments.toString(),
              isHTML: _isHTML.toString(),
              ccController: _ccController.text,
              bbcController: _bbcController.text,
              recipientController: _recipientController.text,
              subjectController: _subjectController.text,
              bodyController: _bodyController.text,
            );
      _db.updateAllEvent(newEvent, widget.id);
      _db.createNotifications();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _advert.showIntersitial();
      print(widget.recipientController);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
      print("[EVENTEDITTING] Form Uygun");
    } else {
      print("[EVENTEDITTING] Form uygun değil");
    }
  }
}
