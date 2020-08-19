import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../databasehelper/dataBaseHelper.dart';
import '../pages/mainmenu.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}



class _SettingsState extends State<Settings> {
  bool _switchValue = false;
  var _db = DbHelper();

  @override
  void initState() {
    super.initState();
    _switchValue = DynamicTheme
        .of(context)
        .brightness == Brightness.dark ? true : false;
  }

  Future<void> showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Takvim'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bütün etkinlikleri silmek istediğinize emin misiniz.',style: TextStyle(fontSize: 18,),textAlign: TextAlign.left,),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Hayır',style:TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Evet',style:TextStyle(fontSize: 16)),
              onPressed: () {
                _db.clearDb();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenu()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog2(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Takvim'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bütün tarihi geçmiş etkinlikleri silmek istediğinize emin misiniz.',style: TextStyle(fontSize: 18,),textAlign: TextAlign.left,),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Hayır',style:TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Evet',style:TextStyle(fontSize: 16)),
              onPressed: () {
                _db.clearoldevent();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenu()));
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
        appBar: AppBar(title: Text('Ayarlar')),
        body: Container(
          padding: const EdgeInsets.fromLTRB(22.0, 4.0, 20.0, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Dark Tema",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Switch(
                    value: _switchValue,
                    onChanged: (val) {
                      setState(() {
                        _switchValue = val;
                        _switchValue
                            ? DynamicTheme.of(context).setBrightness(Brightness
                            .dark)
                            : DynamicTheme.of(context).setBrightness(Brightness
                            .light);
                      });
                    },
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Bütün etkinlikeri sil!", style: TextStyle(
                    fontSize: 20,
                  ),),
                  IconButton(icon: Icon(Icons.delete), onPressed: () {
                    //_db.clearDb();
                    showMyDialog(context);
                  },),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Vakiti geçmiş eventleri sil!", style: TextStyle(
                    fontSize: 20,
                  ),),
                  IconButton(icon: Icon(Icons.delete), onPressed: () {
                    //_db.clearDb();
                    showMyDialog2(context);
                  },),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
