import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Local importlar
import '../databasehelper/dataBaseHelper.dart';
import '../databasemodels/events.dart';
import '../helpers/validateEmpty.dart';
import '../pages/mainmenu.dart';
import '../widgets/notificationtimepicker.dart';
import '../helpers/ads.dart';
import '../widgets/showDialog.dart';
import '../events/mailSender.dart';

class AddEvent extends StatefulWidget {
  var date;

  AddEvent({inputDate}) {
    date = inputDate;
  }

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Advert _advert = Advert();

  var _db = DbHelper();

  String _selectedDate = DateTime.now().toString().split(" ")[0];
  String _selectedStartHour = DateTime.now().toString().split(" ")[1].split(":")[0] +
      ":" +
      DateTime.now().toString().split(" ")[1].split(":")[1];
  String _selectedFinishHour = DateTime.now()
          .add(Duration(
            hours: 1,
          ))
          .toString()
          .split(" ")[1]
          .split(":")[0] +
      ":" +
      DateTime.now().add(Duration(hours: 1)).toString().split(" ")[1].split(":")[1];
  String errmsg = "";

  bool _iscorrect = true;
  bool _isfullday = false;
  bool _duplicite = false;
  bool _iscountdownchecked = false;
  bool _timeisok = true;

  var _radioValue;
  bool _switchValue = false;

  final _titlecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();

  List<String> _attachments = [];
  bool _isHTML = false;

  var _cc = "";

  var _bb = "";

  var _recipient = "";

  var _subject = "";

  var _body = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.date != null ? _selectedDate = widget.date : print("[ADDEVENT] widget.date null");
    });
  }

  @override
  void dispose() {
    // selectNotificationSubject.close();
    _titlecontroller.dispose();
    _descriptioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Etkinlik Ekle"),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                  width: MediaQuery.of(context).size.width - 126,
                  child: TextFormField(
                    controller: _titlecontroller,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: "Etkinlik ismi",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return value.isEmpty ? "Etkinlik ismi boş bırakılamaz" : null;
                    },
                  )),
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
                        if (_isfullday != true)
                          Row(
                            children: <Widget>[
                              Icon(Icons.timer),
                              Text(
                                "$_selectedStartHour",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              )
                            ],
                          ),
                        if (_isfullday != true)
                          Row(
                            children: <Widget>[
                              Icon(Icons.timer_off),
                              Text(
                                "$_selectedFinishHour",
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
                        if (_isfullday != true) {
                          showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                          ).then((value) {
                            setState(() {
                              _selectedFinishHour = ((value.hour.toString().length == 1)
                                      ? ("0" + value.hour.toString())
                                      : value.hour.toString()) +
                                  ":" +
                                  ((value.minute.toString().length == 1)
                                      ? ("0" + value.minute.toString())
                                      : value.minute.toString());
                            });
                          });
                          showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                          ).then((value) {
                            setState(() {
                              _selectedStartHour = ((value.hour.toString().length == 1)
                                      ? ("0" + value.hour.toString())
                                      : value.hour.toString()) +
                                  ":" +
                                  ((value.minute.toString().length == 1)
                                      ? ("0" + value.minute.toString())
                                      : value.minute.toString());
                            });
                          });
                        }
                        if (widget.date == null)
                          showDatePicker(
                            cancelText: "Geri",
                            confirmText: "Tamam",
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025),
                          ).then((value) {
                            setState(() {
                              _selectedDate = value.year.toString() +
                                  "-" +
                                  ((value.month.toString().length == 1)
                                      ? ("0" + value.month.toString())
                                      : value.month.toString()) +
                                  "-" +
                                  (value.day.toString().length == 1
                                      ? "0" + value.day.toString()
                                      : value.day.toString());
                            });
                          });
                      },
                      icon: Icon(Icons.add_circle),
                    ),
                    // Notification ayarlari
                    Container(
                      // padding: EdgeInsets.only(right: 40.0),
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
                        onPressed: () async {
                          await Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => EmailSender()))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                _attachments = value[0];
                                _isHTML = value[1];
                                _cc = value[2];
                                _bb = value[3];
                                _recipient = value[4];
                                _subject = value[5];
                                _body = value[6];
                              });
                            }
                          });
                        },
                      ),
                    ),
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
              // Hata mesaji alani
              if (!_iscorrect || _duplicite || !_timeisok)
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
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isfullday = !_isfullday;
                          });
                        },
                        child: Row(
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
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      // Geri sayim aktiflestirmesi
                      InkWell(
                        onTap: () {
                          setState(() {
                            _iscountdownchecked = !_iscountdownchecked;
                          });
                        },
                        child: Container(
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
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              // Sabit bildirim
              InkWell(
                onTap: () {
                  setState(() {
                    _switchValue = !_switchValue;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22.0, 4.0, 20.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          onPressed: () {
                            showWarningDialog(context,
                                "Sabit bildirim uygulama açıksa 1 dakikada bir güncellenir uygulama kapalı ise belirli aralıklarla güncellenir!");
                          })
                    ],
                  ),
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

    await _db.isFullDay(_selectedDate).then((value) {
      setState(() {
        _duplicite = value;
      });
    });
    if (!_duplicite) {
      await _db.isTimeOk(_selectedDate).then((value) {
        setState(() {
          _timeisok = validateDayIsEmpty(value, _selectedStartHour, _selectedFinishHour);
        });
      });
    }

    setState(() {
      // Eger istenilen gunde tum gun etkinlik varsa hata mesaji yaziliyor
      errmsg = _duplicite == false ? "" : "Bu gün başka bir etkinliğiniz var";
      // Zaman degistirilmek istenilen zaman baska etkinler ile zamani cakisiyorsa hata mesaji yaziliyor
      errmsg += _timeisok == false ? "\nBu saatlerde başka bir etkinlik var" : "";
      // Eger tum gun degilse baslangic ve bitis zamanlari kontrol ediliyor olumsuzluk varsa hata mesaji yaziliyor
      if (!_isfullday) {
        _iscorrect = parseHours(_selectedFinishHour)[0] < parseHours(_selectedStartHour)[0] ||
                (parseHours(_selectedFinishHour)[0] == parseHours(_selectedStartHour)[0] &&
                    parseHours(_selectedFinishHour)[1] < parseHours(_selectedStartHour)[1])
            ? false
            : true;
        errmsg += _iscorrect == false ? "\nBitiş zamanı başlangıç zamanından önce olamaz" : "";
      }
    });
    String imagePaths = "";
    for (int i = 0; i < _attachments.length; i++) {
      imagePaths += "${_attachments[i]}-";
    }
    if (state.validate() && _iscorrect && (!_duplicite) && _timeisok) {
      var newEvent = (_isfullday)
          ? Event(
              title: _titlecontroller.text,
              date: _selectedDate,
              desc: _descriptioncontroller.text,
              isActive: _iscountdownchecked ? 1 : 0,
              choice: _radioValue.toString(),
              countDownIsActive: _switchValue ? 1 : 0,
              attachments: imagePaths,
              isHTML: _isHTML.toString(),
              cc: _cc,
              bb: _bb,
              recipient: _recipient,
              subject: _subject,
              body: _body,
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
              attachments: imagePaths,
              isHTML: _isHTML.toString(),
              cc: _cc,
              bb: _bb,
              recipient: _recipient,
              subject: _subject,
              body: _body,
            );

      await _db.insertEvent(newEvent);
      await _db.createNotifications();
      _advert.showIntersitial();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
      print("[ADDUNKNOWNEVENT] Form Uygun");
    } else {
      print("[ADDUNKNOWNEVENT] Form uygun değil");
    }
  }
}
