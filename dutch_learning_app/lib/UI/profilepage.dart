import 'dart:io';
import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:dutch_learning_app/UI/camera.dart';



class ProfilePage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
//  File _image = File('images/profile.png');
  var _image;

  TextEditingController insertName = new TextEditingController();
  TextEditingController insertCity = new TextEditingController();
  DatabaseHelper db;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

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
    this.goToCamera();
  }

  Future<void> goToCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Camera(
          camera: firstCamera,
        ),
      ),
    );
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
            image(),
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

  Widget image() {
    if (this._image == null) {
      setState(() {
        this._image = getImageFileFromAssets('images/profile.png');
      });

      return Image.asset('images/profile.png', height: 100.0);
    } else {
      return Image.file(_image, height: 100.0);
    }
  }

  getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
