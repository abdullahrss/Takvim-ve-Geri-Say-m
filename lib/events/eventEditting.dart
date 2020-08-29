import 'package:ajanda/helpers/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:ajanda/widgets/dayPicker.dart';
import 'package:ajanda/widgets/navigateToSettings.dart';
import 'package:flutter/cupertino.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../databasemodels/events.dart';
import '../helpers/ads.dart';
import '../pages/mainmenu.dart';
import '../widgets/notificationtimepicker.dart';
import '../widgets/showDialog.dart';
import 'mailSender.dart';

class EventEdit extends StatefulWidget {
  final int warningstatus;
  final Event event;

  const EventEdit({Key key, this.event,this.warningstatus}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
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
  bool _options = false;
  bool _periodicCheckboxValue = false;

  var _radioValue;
  bool _switchValue;

  final _titlecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  /// Mail degiskenleri
  List<String> _attachments = [];
  var _cc = "";
  var _bb = "";
  var _recipient = "";
  var _subject = "";
  var _body = "";

  /// Periyodik etkinlik degiskenleri
  int _periodRadio = 0;
  String _frequency;
  List<bool> _periodicDays = [];
  IconData _iconData = Icons.arrow_drop_down;
  IconData _iconData2 = Icons.arrow_drop_down;


  @override
  void initState() {
    if (widget.event.attachments != null) {
      _attachments = stringPathsToList(widget.event.attachments);
    }

    super.initState();
    _titlecontroller.text = widget.event.title;
    _descriptioncontroller.text = widget.event.desc;
    _selectedFinishHour = widget.event.finishTime;
    _selectedStartHour = widget.event.startTime;
    _selectedDate = widget.event.date;
    _iscountdownchecked = widget.event.isActive == 1 ? true : false;

    widget.event.periodic = _periodRadio;

    for(int i = 0;i<widget.event.frequency.length;i++){
      if (widget.event.frequency[i] == "0" ){
        _periodicDays.add(false);
      }
      else{
        _periodicDays.add(true);
      }

    }

    setState(() {
      _switchValue = widget.event.countDownIsActive == 1 ? true : false;
      _isfullday = _selectedStartHour == "null" ? true : false;
    });
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _descriptioncontroller.dispose();
    super.dispose();
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
                      return value.isEmpty
                          ? "Etkinlik ismi boş bırakılamaz"
                          : null;
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
                            initialTime: TimeOfDay(
                                hour: DateTime.now().hour,
                                minute: DateTime.now().minute),
                          ).then((value) {
                            setState(() {
                              _selectedFinishHour =
                                  (value.hour.toString().length == 1
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
                            initialTime: TimeOfDay(
                                hour: DateTime.now().hour,
                                minute: DateTime.now().minute),
                          ).then((value) {
                            setState(() {
                              _selectedStartHour =
                                  (value.hour.toString().length == 1
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
                              _selectedDate = value.year.toString() +
                                  "-" +
                                  month +
                                  "-" +
                                  day;
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.add_circle),
                    ),
                    // Notification ayarlari
                    Container(
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
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmailSender(
                                    attacs: stringPathsToList(
                                        widget.event.attachments),
                                    cctext: widget.event.cc,
                                    bbtext: widget.event.bb,
                                    recipienttext: widget.event.recipient,
                                    subjecttext: widget.event.subject,
                                    bodytext: widget.event.body,
                                  ))).then((value) {
                            if (value != null) {
                              setState(() {
                                _attachments = value[0];
                                _cc = value[1];
                                _bb = value[2];
                                _recipient = value[3];
                                _subject = value[4];
                                _body = value[5];
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
              if (!_iscorrect || _duplicite )
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 4.0),
                  child: Text(
                    errmsg,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              // Butun gun secenegi
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 4.0, 20.0, 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _options = !_options;
                        if (_options) {
                          _iconData = Icons.arrow_drop_up;
                        } else {
                          _iconData = Icons.arrow_drop_down;
                        }
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(_iconData),
                        Text(
                          "Seçenekler",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_options)
                Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 0),
                    child: Column(
                      children: <Widget>[
                        // Butun gun secenegi
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
                                IconButton(
                                    icon: Icon(Icons.info),
                                    onPressed: () {
                                      showWarningDialog(
                                          context: context,
                                          explanation:
                                          "Geri sayım sayfasında etkinliğinize ne kadar süre kaldığını görebilirsiniz.");
                                    }),
                              ],
                            ),
                          ),
                        ),
                        // Sabit bildirim
                        InkWell(
                          onTap: () {
                            if (widget.warningstatus == 0) {
                              navigateToSettingsDialog(context);
                            }
                            setState(() {
                              _switchValue = !_switchValue;
                            });
                          },
                          child: Container(
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
                                      showWarningDialog(
                                          context: context,
                                          explanation:
                                          "Sabit bildirim uygulama açıksa 1 dakikada bir güncellenir uygulama kapalı ise belirli aralıklarla güncellenir!");
                                    })
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _periodicCheckboxValue =
                                !_periodicCheckboxValue;
                                if (_periodicCheckboxValue) {
                                  _iconData2 = Icons.arrow_drop_up;
                                } else {
                                  _iconData2 = Icons.arrow_drop_down;
                                }
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  _iconData2,
                                  size: 36,
                                ),
                                Text(
                                  "Periyodik Etkinlik",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_periodicCheckboxValue)
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: InkWell(
                                  onTap: () => setSelectedRadio(1),
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: 1,
                                        groupValue: _periodRadio,
                                        onChanged: (val) {
                                          setSelectedRadio(val);
                                        },
                                      ),
                                      Text("Günlük",
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: InkWell(
                                  onTap: () => setSelectedRadio(2),
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: 2,
                                        groupValue: _periodRadio,
                                        onChanged: (val) {
                                          setSelectedRadio(val);
                                        },
                                      ),
                                      Text("Haftalık",
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: InkWell(
                                  onTap: () => setSelectedRadio(3),
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: 3,
                                        groupValue: _periodRadio,
                                        onChanged: (val) {
                                          setSelectedRadio(val);
                                        },
                                      ),
                                      Text("Aylık",
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  DayPickerForPeriodic dayPicker =
                                  DayPickerForPeriodic(days: _periodicDays,);
                                  await showDialog(
                                      context: context, child: dayPicker);
                                  setState(() {
                                    _periodicDays = dayPicker.days;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 29.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_today,
                                      ),
                                      Text(
                                        "  Özel",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    )),
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.blue,
                    ),
                    RaisedButton(
                      onPressed: () => {validateandsave()},
                      elevation: 18,
                      child: Text("Kaydet"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  setSelectedRadio(int val) {
    setState(() {
      _periodRadio = val;
    });
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
    await _db.isFullDay(widget.event.date, id: widget.event.id).then((value) {
      setState(() {
        _duplicite = value;
      });
    });

    /// Olasi hatalarin mesajlari olusturuluyor
    setState(() {
      /// Eger istenilen gunde tum gun etkinlik varsa hata mesaji yaziliyor
      errmsg = _duplicite == false ? "" : "Bu gün başka bir etkinliğiniz var\n";

      /// Eger tum gun degilse baslangic ve bitis zamanlari kontrol ediliyor olumsuzluk varsa hata mesaji yaziliyor
      try {
        if (!_isfullday) {
          _iscorrect = parseHours(_selectedFinishHour)[0] <
              parseHours(_selectedStartHour)[0] ||
              (parseHours(_selectedFinishHour)[0] ==
                  parseHours(_selectedStartHour)[0] &&
                  parseHours(_selectedFinishHour)[1] <
                      parseHours(_selectedStartHour)[1])
              ? false
              : true;
          errmsg += _iscorrect == false
              ? "Bitiş zamanı başlangıç zamanından önce olamaz\n"
              : "";
        }
      } catch (e) {
        print("[ERROR] [EVENTEDITTING] $e");

        /// Tüm gün olan eventi tüm günden cikartip saat secilmezse
        errmsg += "Tüm gün işaretli değilse saat girmelisiniz\n";
      }
    });
    String imagePaths = "";
    for (int i = 0; i < _attachments.length; i++) {
      imagePaths += "${_attachments[i]}-";
    }
    if(_periodicDays.length != null)
      for (int i = 0; i < _periodicDays.length; i++) {
        setState(() {
          _frequency += _periodicDays[i] ? "1" : "0";
        });
      }
    if (state.validate() && (_iscorrect) && (!_duplicite)) {
      var newEvent = _isfullday
          ? Event(
        id: widget.event.id,
        title: _titlecontroller.text,
        date: _selectedDate,
        desc: _descriptioncontroller.text,
        isActive: _iscountdownchecked ? 1 : 0,
        choice: _radioValue.toString(),
        countDownIsActive: _switchValue ? 1 : 0,
        attachments: imagePaths,
        cc: _cc,
        bb: _bb,
        recipient: _recipient,
        subject: _subject,
        body: _body,
        periodic: _periodRadio,
        frequency: _frequency,
      )
          : Event(
        id: widget.event.id,
        title: _titlecontroller.text,
        date: _selectedDate,
        startTime: _selectedStartHour,
        finishTime: _selectedFinishHour,
        desc: _descriptioncontroller.text,
        isActive: _iscountdownchecked ? 1 : 0,
        choice: _radioValue == null ? "0" : _radioValue.toString(),
        countDownIsActive: _switchValue ? 1 : 0,
        attachments: imagePaths,
        cc: _cc,
        bb: _bb,
        recipient: _recipient,
        subject: _subject,
        body: _body,
        periodic: _periodRadio,
        frequency: _frequency,
      );
      _db.updateEvent(newEvent);
      _db.createNotifications();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _advert.showIntersitial();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainMenuBody()));
      print("[EVENTEDITTING] Form Uygun");
    } else {
      print("[EVENTEDITTING] Form uygun değil");
    }
  }
}
