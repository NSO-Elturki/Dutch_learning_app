import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:dutch_learning_app/src/pages/call.dart';
import 'package:camera/camera.dart';
import 'package:dutch_learning_app/UI/camera.dart';


class VideoCall extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VideoCallState();
  }
}

class VideoCallState extends State<VideoCall> {
  var topics = [];
  DatabaseHelper db;
  var topicAvaliable;

  getVideoChatTopics() async {
    DatabaseReference _firebaseDatabase =
        FirebaseDatabase.instance.reference().child('VideoChatTopices');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {
        setState(() {
          this.topics.add(values['topic']);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    db = new DatabaseHelper();
    this.getVideoChatTopics();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      backgroundColor: Colors.blueAccent,
      body: ListView(
        children: <Widget>[
          Padding(

            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(

              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: (){

                    this.goToCamera();
                  },
                ),
                 Spacer(),
                IconButton(
                  icon: Icon(Icons.border_color),
                  onPressed:(){
                    this.addNewTopic();
                  } ,
                )

              ],


            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Topics to chats',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(

              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0 ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 45.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 300.0,
                    child: ListView.builder(

                        itemCount: topics.length,
                        itemBuilder: (context, index){

                          return ListTile(
                            title: new Text(topics[index],
                              style: TextStyle(

                                  fontFamily: 'Montserrat',
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onTap: (){
                              this.goToCallPage(topics[index]);

                            },
                          );
                        }

                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void goToCallPage(String topic) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new CallPage(
                  channelName: topic,
                )));
  }

  addNewTopic() {
    TextEditingController newTopic = new TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                new Text('Create a topic to discuss in Dutch with other users'),
            content: TextField(
              controller: newTopic,
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('Create'),
                onPressed: () {
                  try {
                    db.updateVideoChatTopicTable(newTopic.text, 0);
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          );
        });
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
}
