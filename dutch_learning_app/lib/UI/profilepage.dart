import 'dart:io';

import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  File _image = File('images/profile.png');

  TextEditingController insertName = new TextEditingController();
  TextEditingController insertCity = new TextEditingController();
  DatabaseHelper db;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  saveProfile() {

    db = new DatabaseHelper();
    if (insertName != null && insertCity != null) {

      db.saveUserProfile(insertName.text, insertCity.text, _image);


    } else {

      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
              new Text('Please insert your name and the city you live at'),
              actions: <Widget>[
                FlatButton(
                  child: new Text('Ok'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Profile'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(30.0)),
            Image.file(
              _image,
              height: 50.0,
            ),
            RaisedButton(
              child: new Text('Select image '),
              color: Colors.blueAccent[700],
              onPressed: getImage,
            ),
            new Padding(padding: EdgeInsets.all(15.0)),
            TextField(
              controller: insertName,
            ),
            TextField(
              controller: insertCity,
            ),
            RaisedButton(
              onPressed: () {
                saveProfile();
              },
            )
          ],
        ),
      ),
    );
  }
}
