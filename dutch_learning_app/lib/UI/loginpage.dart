import 'package:camera/camera.dart';
import 'package:dutch_learning_app/UI/profilepage.dart';
import 'package:dutch_learning_app/UI/regesterpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dutch_learning_app/UI/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  bool isUserNew;
  LoginPage(this.isUserNew);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      appBar: new AppBar(
//        title: new Text('Login'),
//        backgroundColor: Colors.deepOrange[600],
//      ),
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
                  child: new Text('Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
                  color: Colors.blue,
                  onPressed: () {

                   this.login();
                   if(widget.isUserNew == true){

                     this.goToProfile();
                   }
                   if(widget.isUserNew == false){

                     this.goToCamera();
                   }

                  },
                ),
                RaisedButton(
                  child: new Text('Regester',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
                  color: Colors.blue,
                  onPressed: () {
                   this.goToRegesterPage();
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> login() async {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);


      } catch (e) {
        print(e.toString());
      }
    }
  }

  void goToRegesterPage(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegesterPage()
      ),
    );

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

  void goToProfile(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage()
      ),
    );

  }
}
