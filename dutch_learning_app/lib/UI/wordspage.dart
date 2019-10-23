import 'package:dutch_learning_app/UI/quizpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dutch_learning_app/UI/displaywords.dart';

class Types {
  String _type;
  List<Words> words = new List<Words>();
  Types(String type, String word, String img) {
    this._type = type;
    this.words.add(new Words(img, word));
  }
}

class Words {
  String word, img;
  Words(String img, String word) {
    this.word = word;
    this.img = img;
  }
}

class WordsPage extends StatefulWidget {
  String userId;
  String nextPage;
  WordsPage(this.userId, this.nextPage);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WordsPageState();
  }
}

class WordsPageState extends State<WordsPage> {
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
          print('$key nagi');
        });
      });
    });
  }

  getAllWords() async {
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
    getAllWords();
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
