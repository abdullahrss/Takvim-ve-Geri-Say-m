import 'dart:io';

import 'package:ajanda/widgets/showDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EmailSender extends StatefulWidget {
  final List<String> attacs;
  final cctext;
  final bbtext;
  final recipienttext;
  final subjecttext;
  final bodytext;

  EmailSender({
    Key key,
    this.attacs,
    this.cctext,
    this.bbtext,
    this.recipienttext,
    this.subjecttext,
    this.bodytext,
  }) : super(key: key);

  @override
  _EmailSender createState() => _EmailSender();
}

class _EmailSender extends State<EmailSender> {
  List<String> attachments = [];

  final _ccController = TextEditingController();

  final _bbcController = TextEditingController();

  final _recipientController = TextEditingController();

  final _subjectController = TextEditingController();

  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recipienttext != null) {
      setState(() {
        attachments = widget.attacs;
        _ccController.text = widget.cctext;
        _bbcController.text = widget.bbtext;
        _recipientController.text = widget.recipienttext;
        _subjectController.text = widget.subjecttext;
        _bodyController.text = widget.bodytext;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mail gönderme'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.help,
                size: 36,
              ),
              onPressed: () {
                showWarningDialog(
                    context: context,
                    explanation:
                        "Eğer birden fazla alıcı, cc veya bbc değeri girecekseniz her mail arasına virgül koymalısınız.\n\n(örnek: ornek@gmail.com , ornek2@gmail.com)");
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _recipientController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alıcı adresi ',
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
                  decoration: InputDecoration(labelText: 'Mail', border: OutlineInputBorder()),
                ),
              ),
              ...attachments.map(
                (item) => Text(
                  item,
                  overflow: TextOverflow.fade,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3 + 16,
                      child: RaisedButton(
                        color: Colors.blue,
                        elevation: 18,
                        onPressed: _picker,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            Text(
                              "  Resim ekle",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        splashColor: Colors.blue,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3 + 16,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: save,
                        elevation: 18,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.insert_drive_file,
                              color: Colors.white,
                            ),
                            Text(
                              "  Dosya Ekle",
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        splashColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: save,
                    elevation: 18,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        Text("  Kaydet", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    splashColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save() {
    if (_recipientController.text == "") {
      showWarningDialog(context: context, explanation: 'Alıcı mail boş bırakılmaz!');
    } else if (_subjectController.text == "") {
      showWarningDialog(context: context, explanation: 'Konu boş bırakılamaz!');
    } else {
      List<dynamic> sendBack = [];
      sendBack.add(attachments);
      sendBack.add(_ccController.text);
      sendBack.add(_bbcController.text);
      sendBack.add(_recipientController.text);
      sendBack.add(_subjectController.text);
      sendBack.add(_bodyController.text);
      Navigator.pop(context, sendBack);
    }
  }

  void _picker() async {
    ImagePicker imagePicker = ImagePicker();
    final File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    // final PickedFile pick = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      attachments.add(pick.path);
    });
  }
}
