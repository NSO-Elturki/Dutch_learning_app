import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:dutch_learning_app/classes/quiz.dart';
import 'package:dutch_learning_app/UI/quizresult.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dutch_learning_app/classes/words.dart';

class QuizPage extends StatefulWidget {
  String titleOfQuiz, userId, userProfileKey;
  int points;

  QuizPage(this.titleOfQuiz, this.userId, this.userProfileKey, this.points);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return QuizPageState();
  }
}

class QuizPageState extends State<QuizPage> {
  var finalScore = 0;
  var questionNumber = 0;
  var quiz = new Quiz();
  List<Words> allWords = new List<Words>();
  int q1, q2, q3, q4, q5;
  var images = [];
  var choices = [];
  var correctAnswers = [];
  DatabaseHelper db;
  int userExsist;

  getAllWords() async {
    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(widget.userId)
        .child('words')
        .child(widget.titleOfQuiz);
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
    //  final int randomNr = Random().nextInt(allWords.length);
    setState(() {
      this.q1 = 1;
      this.q2 = 2;
      this.q3 = 3;
      this.q4 = 0;
      images = [
        allWords[q1].img,
        allWords[q2].img,
        allWords[q3].img,
        allWords[q4].img
      ];
      // choices of each question
      choices = [
        [allWords[q1].word, allWords[q4].word],
        [allWords[q2].word, allWords[q3].word],
        [allWords[q3].word, allWords[q2].word],
        [allWords[q4].word, allWords[q1].word]
      ];

//      //answers
      correctAnswers = [
        allWords[q1].word,
        allWords[q2].word,
        allWords[q3].word,
        allWords[q4].word
      ];
    });
  }

  @override
  void initState() {
    super.initState();

    this.getAllWords();
    db = new DatabaseHelper();
    this.checkUserOnRankingTable(widget.userId);

    //  this.userExsist = db.checkUserOnRankingTable(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: new Container(
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(10.0)),
              new Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      'Question ${questionNumber + 1} of 4',
                      style: new TextStyle(fontSize: 22.0),
                    ),
                    new Text(
                      'Score: $finalScore',
                      style: new TextStyle(fontSize: 22.0),
                    )
                  ],
                ),
              ),

              //  image of word
              new Padding(padding: EdgeInsets.all(10.0)),
              new Image.network(
                images[questionNumber],
                height: 230,
              ),
              new Padding(padding: EdgeInsets.all(10.0)),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
//button 1
                  new RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      if (choices[questionNumber][0] ==
                          correctAnswers[questionNumber]) {
                        print('Your answer is correct');
                        finalScore++;
                      } else {
                        print('Your answer is WRONG ');
                      }
                      this.nextQuestion();
                    },
                    child: new Text(
                      choices[questionNumber][0],
                      style: new TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),

//button 2
                  new RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      if (choices[questionNumber][1] ==
                          correctAnswers[questionNumber]) {
                        print('Your answer is correct');
                        finalScore++;
                      } else {
                        print('Your answer is WRONG ');
                      }
                      this.nextQuestion();
                    },
                    child: new Text(
                      choices[questionNumber][1],
                      style: new TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.all(10.0)),

              new Container(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  child: new Text('Stop quiz'),
                  color: Colors.red,
                  onPressed: stopQuiz,
                ),
              )
            ],
          ),

//
        ),
      ),
    );
  }

  updateUserScore(int updateScore) {
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(widget.userId)
        .child('profile')
        .child(widget.userProfileKey)
        .update({'points': updateScore + widget.points});
  }

  checkUserOnRankingTable(String id) async {
    DatabaseReference _firebaseDatabase =
        FirebaseDatabase.instance.reference().child('Ranking');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {
        setState(() {
          print('$key key of the foreach');
          if (key.toString() == id) {
            this.userExsist = 1;
          } else {
            this.userExsist = 0;
          }
        });
      });
    });
  }

  getCurrentUserInfo() async {
    // DatabaseHelper db = new DatabaseHelper();

    //  User user;
    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(widget.userId)
        .child('profile');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          print('$userExsist this is user exsist');
          db.updateRankingTable(values['name'], values['image'],
              values['points'], key.toString(), this.userExsist);
          print('${key.toString()} nagi key');
        });
      });
    });
  }

  nextQuestion() {
    setState(() {
      if (questionNumber == quiz.questions.length - 1) {
        //  DatabaseHelper db = new DatabaseHelper();
        updateUserScore(this.finalScore);
        this.getCurrentUserInfo();
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    new QuizResult(finalScore, this.allWords.length)));
      } else {
        questionNumber++;
      }
    });
  }

  stopQuiz() {
    setState(() {
      Navigator.pop(context);
      this.finalScore = 0;
      this.questionNumber = 0;
    });
  }
}
