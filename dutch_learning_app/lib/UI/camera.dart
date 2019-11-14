import 'dart:async';
import 'package:dutch_learning_app/UI/loginpage.dart';
import 'package:dutch_learning_app/UI/ranking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:dutch_learning_app/UI/getlabel.dart';
import 'package:dutch_learning_app/UI/wordtypepage.dart';
import 'package:dutch_learning_app/UI/videocall.dart';



class Camera extends StatefulWidget {
  final CameraDescription camera;

  const Camera({Key key, this.camera}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CameraState();
  }
}

class CameraState extends State<Camera> {
  //_controller variable will store camera controller
  CameraController _controller;
  // future variable will return what is store on the cameracontroller
  Future<void> _initializeControllerFuture;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userId;

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser().then((user) {
      this.userId = user.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // here I get the view of camera when the camera is open
    _controller = CameraController(
      //here told system which camera to use which is pass from the main class as parameter which will be
      //back camera
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  takePictureAndStore() async {
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetLabel(path),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Camera'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: new FloatingActionButton(

        child: Icon(Icons.camera_alt),
        onPressed: takePictureAndStore,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            ListTile(
              title: new Text(
                'Dutch learning app',
                style: new TextStyle(fontSize: 30.0, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: new Text('Words'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WordTypesPage(this.userId, 'showWords'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.access_alarms),
              title: new Text('Quiz'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WordTypesPage(this.userId, 'showQuiz'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: new Text('Ranking'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ranking(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: new Text('Video chat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCall(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: new Text('Sign out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(false),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
