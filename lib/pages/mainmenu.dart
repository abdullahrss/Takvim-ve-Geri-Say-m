import 'dart:async';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Local importlar
import '../helpers/backgroundProcesses.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../events/addevent.dart';
import 'countdownpage.dart';
import 'calendar.dart';
import '../events/closesEvent.dart';
import '../helpers/ads.dart';
import 'settings.dart';

class MainMenu extends StatelessWidget {
  MainMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              brightness: brightness,
              fontFamily: "DoppioOne",
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: MainMenuBody(),
          );
        });
  }
}

class MainMenuBody extends StatefulWidget {
  @override
  _MainMenuBodyState createState() => _MainMenuBodyState();
}

class _MainMenuBodyState extends State<MainMenuBody> {
  // Admob
  final Advert _advert = Advert();

  // Notification
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Database
  var _db = DbHelper();

  // Background services
  BackGroundProcesses _backGroundProcesses;

  // Locals
  int _selectedIndex = 0;
  static int _selectedOrder = 0;
  int radioValue;
  Timer timer;

  @override
  void initState() {
    super.initState();
    // Background processes
    _backGroundProcesses = BackGroundProcesses();
    _backGroundProcesses.startBgServicesManually();
    // Ads
    _advert.showBannerAd();
    // Active processes
    _db.openNotificationBar();
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _db.openNotificationBar();
    });
  }

  @override
  void dispose() {
    _advert.closeBannerAd();
    timer.cancel();
    super.dispose();
  }

  List<Widget> _widgetOptions = <Widget>[
    Soclose.byorder(_selectedOrder),
    Calendar(),
    CountDownPage(),
  ];

  set selecetedIndex(int newIndex) {
    _selectedIndex = newIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEvent()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
      appBar: AppBar(
        title: Text('Takvim Uygulaması'),
        //centerTitle: true,
        actions: <Widget>[
          if (_selectedIndex == 0)
            Container(
              child: IconButton(
                onPressed: () {
                  showMySortDialog(context);
                },
                icon: Icon(
                  Icons.sort,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          SizedBox(
            width: 15,
          ),
          IconButton(
              icon: Icon(
                Icons.settings,
                size: 30,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (Settings())),
                );
              })
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            title: Text(
              'Yakındakiler',
              style: TextStyle(fontSize: 18),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text(
              'Takvim',
              style: TextStyle(fontSize: 18),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            title: Text(
              'Geri Sayım',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void changeRadios(int e) {
    setState(() {
      radioValue = e;
      _widgetOptions[0] = Soclose.byorder(e);
    });
    Navigator.pop(context);
  }

  Future<void> showMySortDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sıralama'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: radioValue,
                      onChanged: changeRadios,
                    ),
                    Text("A-Z a-z"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: radioValue,
                      onChanged: changeRadios,
                    ),
                    Text("Z-A z-a"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 2,
                      groupValue: radioValue,
                      onChanged: changeRadios,
                    ),
                    Text("Yakın tarihler başta"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 3,
                      groupValue: radioValue,
                      onChanged: changeRadios,
                    ),
                    Text("Uzak tarihler başta"),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Geri",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
