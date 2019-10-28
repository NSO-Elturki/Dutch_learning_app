import 'package:dutch_learning_app/UI/quizpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dutch_learning_app/UI/displaywords.dart';




class WordTypesPage extends StatefulWidget {
  String userId;
  String nextPage;
  WordTypesPage(this.userId, this.nextPage);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WordTypesPageState();
  }
}

class WordTypesPageState extends State<WordTypesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userId;
  var typeOfWords = [];
  String userProfileKey;
  int points;

  geUserProfileKey() async {

    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(widget.userId)
        .child('profile');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {
        setState(() {
          this.userProfileKey = key;
          this.points = values['points'];
         // print('$key nagi');
        });
      });
    });
  }

  getAllWordTypes() async {
    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(widget.userId)
        .child('words');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {
        setState(() {
          typeOfWords.add(key);
        });
        print(key);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    geUserProfileKey();
    getAllWordTypes();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Wordssnagi'),
        backgroundColor: Colors.deepOrange[600],
      ),
      body: ListView.builder(
        itemCount: typeOfWords.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: new Text(typeOfWords[index]),
            onTap: () {
              this.nextPage(typeOfWords[index]);
            },
          );
        },
      ),
    );
  }

  void nextPage(var typeOfWord) {
    if (widget.nextPage == 'showQuiz') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(typeOfWord, widget.userId, userProfileKey, points),

        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayWords(typeOfWord, widget.userId),
        ),
      );
    }
  }
}
