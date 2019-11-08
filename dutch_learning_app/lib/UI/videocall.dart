import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:dutch_learning_app/src/pages/call.dart';

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
      appBar: new AppBar(
        title: new Text('Topics to chats'),
        backgroundColor: Colors.deepOrange[600],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.border_color),
            onPressed:(){
              this.addNewTopic();
            } ,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: new Text(topics[index]),
            onTap: () {
              this.goToCallPage(topics[index]);
            },
          );
        },
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
}
