import 'package:dutch_learning_app/classes/words.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DisplayWords extends StatefulWidget {
  String title, userId;
  DisplayWords(this.title, this.userId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DisplayWordsState();
  }
}


class DisplayWordsState extends State<DisplayWords> {

  List<Words> allWords = new List<Words>();


  getAllWords() async {
    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(widget.userId)
        .child('words')
        .child(widget.title);
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          allWords.add(new Words(values['ItemImg'], values['ItemInNl']));
          print(values['ItemInNl']);
          print(allWords.length);
        });
      });
    });
  }

    @override
    void initState() {
      super.initState();

      this.getAllWords();
    }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        backgroundColor: Colors.deepOrange[600],
      ),
      body: ListView.builder(
        itemCount: this.allWords.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: new Text(allWords[index].word),
                leading: CircleAvatar(
                  child: Image.network(
                    allWords[index].img,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
