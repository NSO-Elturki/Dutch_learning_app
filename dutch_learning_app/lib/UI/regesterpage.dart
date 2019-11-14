import 'package:camera/camera.dart';
import 'package:dutch_learning_app/UI/loginpage.dart';
import 'package:dutch_learning_app/UI/profilepage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dutch_learning_app/UI/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegesterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegesterPageState();
  }
}

class RegesterPageState extends State<RegesterPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Regester'),
        backgroundColor: Colors.deepOrange[600],
      ),
      body: Container(
        child: Column(children: <Widget>[
          new Padding(padding: EdgeInsets.all(15.0)),
          new Container(
              width: 190.0,
              height: 190.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('images/dutch.jpeg')))),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type real email';
                    }
                  },
                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Password should be at least 6 char';
                    }
                  },
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                RaisedButton(
                  child: new Text('Regester'),
                  color: Colors.deepOrange[600],
                  onPressed: () {
                    this.saveToDb();
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> saveToDb() async {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        goToLoginPage();

      } catch (e) {
        print(e.toString());
      }
    }
  }


  Future<void> goToLoginPage() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(true)
      ),
    );
  }
}
