import 'dart:async';
import 'dart:io';
import 'package:ajanda/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class EmailSender extends StatefulWidget {
  final attacs;
  final isHtml;
  final cctext;
  final bbtext;
  final recipienttext;
  final subjecttext;
  final bodytext;

  EmailSender({
    Key key,
    this.attacs,
    this.isHtml,
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
  bool isHTML = false;

  final _ccController = TextEditingController();

  final _bbcController = TextEditingController();

  final _recipientController = TextEditingController();

  final _subjectController = TextEditingController();

  final _bodyController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.recipienttext != null) {
      setState(() {
        attachments = widget.attacs;
        isHTML = widget.isHtml == "false" ? false : true;
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
                  decoration: InputDecoration(labelText: 'Mail', border: OutlineInputBorder()),
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
                          Text(
                            "  Resim ekle",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Colors.blue,
                    ),
                    RaisedButton(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ----------------------------------gereksiz-----------------------------
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
  //----------------------------------------------------------------------
  void save() {
    if (_recipientController.text == "") {
      showWarningDialog(context, 'Alıcı mail boş bırakılmaz!');
    } else if (_subjectController.text == "") {
      showWarningDialog(context, 'Konu boş bırakılamaz!');
    } else {
      List<dynamic> sendBack = [];
      sendBack.add(attachments);
      sendBack.add(isHTML);
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
