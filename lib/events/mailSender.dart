import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class EmailSender extends StatefulWidget {
  @override
  _EmailSender createState() => _EmailSender();
}

class _EmailSender extends State<EmailSender> {
  List<String> attachments = [];
  bool isHTML = false;

  final _ccController = TextEditingController(
    text: '',
  );

  final _bbcController = TextEditingController(
    text: '',
  );

  final _recipientController = TextEditingController(
    text: '',
  );

  final _subjectController = TextEditingController(text: '');

  final _bodyController = TextEditingController(
    text: '',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      cc: [_ccController.text],
      bcc: [_bbcController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Mail Gönderildi.';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gmail gönderme'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _recipientController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alıcı adresi',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _ccController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CC',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bbcController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'BBC',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Konu',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
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
                    isHTML = value;
                  });
                },
                value: isHTML,
              ),
              ...attachments.map(
                (item) => Text(
                  item,
                  overflow: TextOverflow.fade,
                ),
              ),
//              Container(
//                width: (MediaQuery.of(context).size.width / 3) - 30,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(45.0),
//                    color: Colors.blue),
//                child: FlatButton(
//                  child: Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.save,
//                      ),
//                      Text(" Kaydet"),
//                    ],
//                  ),
//                  onPressed: _picker,
//                ),
//              )
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
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
                      onPressed: _picker,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
//      floatingActionButton: Padding(
//        padding: const EdgeInsets.only(left: 25),
//        child: Align(
//          alignment: Alignment.bottomLeft,
//          child: FloatingActionButton.extended(
//            icon: Icon(Icons.camera),
//            label: Text('Resim ekle'),
//            onPressed: _picker,
//          ),
//        ),
//      ),
    );
  }

  void _picker() async {
    final File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      attachments.add(pick.path);
    });
  }
}
