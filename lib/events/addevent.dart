import 'package:ajanda/widgets/navigateToSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../databasehelper/dataBaseHelper.dart';
import '../databasemodels/events.dart';
import '../events/mailSender.dart';
import '../helpers/ads.dart';
import '../pages/mainmenu.dart';
import '../widgets/notificationtimepicker.dart';
import '../widgets/showDialog.dart';

class AddEvent extends StatefulWidget {
  final int warningstatus;
  var date;

  AddEvent({inputDate, this.warningstatus}) {
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
  bool _options = false;
  bool _periodicCheckboxValue = false;
  bool _spelicaldate = false;
  int  _periodradio;
//  int _daily = 1;
//  int _weekly = 2;
//  int _montly = 3;

  bool _pazartesi;
  bool _sali;
  bool _carsamba;
  bool _persembe;
  bool _cuma;
  bool _cumartesi;
  bool _pazar;

  bool _special = false;

  var _radioValue;
  bool _switchValue = false;
  bool dialogValue = false;

  /// Baslik ve aciklama kontrolleri
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
  int _periodic = 0;
  String _frequency;
  IconData _iconData = Icons.arrow_drop_down;
  IconData _iconData2 = Icons.arrow_drop_down;


  @override
  void initState() {
    super.initState();
    _periodradio = 0;
    _pazartesi = false;
    _sali =false;
    _carsamba = false;
    _persembe = false;
    _cuma = false;
    _cumartesi = false;
    _pazar = false;
    setState(() {
      widget.date != null ? _selectedDate = widget.date : print("[ADDEVENT] widget.date null");
    });
  }

  setSelectedRadio(int val) {
    setState(() {
      _periodradio = val;
    });
  }

  setPazartesi(bool val){
    setState(() {
      _pazartesi = val;
    });
  }
  setSali(bool val){
    setState(() {
      _sali = val;
    });
  }
  setCarsamba(bool val){
    setState(() {
      _carsamba = val;
    });
  }
  setPersembe(bool val){
    setState(() {
      _persembe = val;
    });
  }
  setCuma(bool val){
    setState(() {
      _cuma = val;
    });
  }

  setCumartesia(bool val){
    setState(() {
      _cumartesi = val;
    });
  }
  setPazar(bool val){
    setState(() {
      _pazar = val;
    });
  }
  @override
  void dispose() {
    _titlecontroller.dispose();
    _descriptioncontroller.dispose();
    super.dispose();
  }


  Future<void> _showMyDialog33() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gün seçiniz!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(children: <Widget>[
                  Checkbox(
                    value: _pazartesi,
                    onChanged:(value) =>{
                      setPazartesi(value)
                    } ,
                  ),
                  Text("Pazartesi"),

                ],),
                Row(children: <Widget>[
                  Checkbox(
                    value: _sali,
                    onChanged:(value) =>{
                      setSali(value)
                    } ,
                  ),
                  Text("Salı"),

                ],),
                Row(children: <Widget>[
                  Checkbox(
                    value: _carsamba,
                    onChanged:(value) =>{
                      setCarsamba(value)
                    } ,
                  ),
                  Text("Çarşamba"),

                ],),
                Row(children: <Widget>[
                  Checkbox(
                    value: _persembe,
                    onChanged:(value) =>{
                      setPersembe(value)
                    } ,
                  ),
                  Text("Perşembe"),

                ],),Row(children: <Widget>[
                  Checkbox(
                    value: _cuma,
                    onChanged:(value) =>{
                      setCuma(value)
                    } ,
                  ),
                  Text("Cuma"),

                ],)
                ,Row(children: <Widget>[
                  Checkbox(
                    value: _cumartesi,
                    onChanged:(value) =>{
                      setCumartesia(value)
                    } ,
                  ),
                  Text("cumartesi"),

                ],)
                ,Row(children: <Widget>[
                  Checkbox(
                    value: _pazar,
                    onChanged:(value) =>{
                      setPazar(value)
                    } ,
                  ),
                  Text("Pazar"),

                ],)

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Geri'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Etkinlik Ekle"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help_outline,
              size: 36,
            ),
            onPressed: () => showButtonAboutDialog(context),
          ),
        ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
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
                          if (_recipient != "") {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmailSender(
                                          attacs: _attachments,
                                          cctext: _cc,
                                          bbtext: _bb,
                                          recipienttext: _recipient,
                                          subjecttext: _subject,
                                          bodytext: _body,
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
                          } else {
                            await Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => EmailSender()))
                                .then((value) {
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
                          }
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
              if (!_iscorrect || _duplicite)
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  //height: 75,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 4.0),
                  child: Text(
                    errmsg,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 4.0, 20.0, 0),
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
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
              // Butun gun secenegi
              if (_options)
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
                          padding: const EdgeInsets.only(left:6.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _periodicCheckboxValue = !_periodicCheckboxValue;
                                if (_periodicCheckboxValue) {
                                  _iconData2 = Icons.arrow_drop_up;
                                } else {
                                  _iconData2 = Icons.arrow_drop_down;
                                }
                              });
                              // TODO:Navigate to popup or something like that
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(_iconData2,size: 36,),
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
                        if(_periodicCheckboxValue)
                        Padding(
                          padding: const EdgeInsets.only(left:16.0),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    _periodradio != _periodradio;
                                  });
                                },
                                child: Radio(
                                  value: 1,
                                  groupValue: _periodradio,
                                  onChanged: (val) {
                                    setSelectedRadio(val);
                                  },
                                ),
                              ),
                              Text("Günlük",style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        if(_periodicCheckboxValue)
                        Padding(
                          padding: const EdgeInsets.only(left:16.0),
                          child: Row(
                            children: <Widget>[InkWell(
                              onTap: (){
                                setState(() {
                                  _periodradio != _periodradio;
                                });
                              },
                              child: Radio(
                                value: 2,
                                groupValue: _periodradio,
                                onChanged: (val) {
                                  setSelectedRadio(val);
                                },
                              ),
                            ),
                              Text("Haftalık",style: TextStyle(fontSize: 20)),],
                          ),
                        ),
                        if(_periodicCheckboxValue)
                        Padding(
                          padding: const EdgeInsets.only(left:16.0),
                          child: Row(
                            children: <Widget>[InkWell(
                              onTap: (){
                                setState(() {
                                  _periodradio != _periodradio;
                                });
                              },
                              child: Radio(
                                value: 3,
                                groupValue:_periodradio ,
                                onChanged: (val) {
                                  setSelectedRadio(val);
                                },
                              ),
                            ),
                              Text("Aylık",style: TextStyle(fontSize: 20)),],
                          ),
                        ),
                        if(_periodicCheckboxValue)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showMyDialog33();
                                _spelicaldate = !_spelicaldate;

                              });
                              // TODO:Navigate to popup or something like that
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:29.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.calendar_today,),
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

    setState(() {
      /// Eger istenilen gunde tum gun etkinlik varsa hata mesaji yaziliyor
      errmsg = _duplicite == false ? "" : "Bu gün başka bir etkinliğiniz var";

      /// Eger tum gun degilse baslangic ve bitis zamanlari kontrol ediliyor olumsuzluk varsa hata mesaji yaziliyor
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
    if (state.validate() && _iscorrect && (!_duplicite)) {
      var newEvent = (_isfullday)
          ? Event(
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
              periodic: _periodic,
              frequency: _frequency,
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
              cc: _cc,
              bb: _bb,
              recipient: _recipient,
              subject: _subject,
              body: _body,
              periodic: _periodic,
              frequency: _frequency,
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
