import 'package:flutter/material.dart';

class NavigateToSettings extends StatefulWidget {

  @override
  _NavigateToSettingsState createState() => _NavigateToSettingsState();
}

class _NavigateToSettingsState extends State<NavigateToSettings> {


  @override
  Widget build(BuildContext context) {
    bool checkboxvalue = false;
    return Dialog(
      child: Column(
        children: <Widget>[
          Text("DİKKKAKAWT"),
          Text("DİKKAT ETZSENE OLM"),
          Row(
            children: <Widget>[
              Checkbox(
                value: checkboxvalue,
                onChanged: (v) => setState((){checkboxvalue=v;}),
              ),
              Text("GET OUT"),
            ],
          ),
        ],
      ),
    );
  }
}