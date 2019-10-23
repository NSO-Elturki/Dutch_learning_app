import 'package:dutch_learning_app/UI/loginpage.dart';
import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class User{

  String name, city, image, key;
  int score;
  User( String key, String name, String city, String image, int score){

    this.key = key;
    this.name = name;
    this.city = city;
    this.image = image;
    this.score = score;
  }
}
class QuizResult extends StatelessWidget {
  int score, quizLenght;
  var feedback = '';

  QuizResult(this.score, this.quizLenght);



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Container(
        margin: const EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: feedBack(context),
      )),
    );
  }

  Widget feedBack(BuildContext context) {
    int fullMark = this.quizLenght;
    int midMark = (this.quizLenght / 2).toInt();

    if (this.score == fullMark) {
      return Column(
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(15.0)),
          new Text('Total score: $score'),
          new Padding(padding: EdgeInsets.all(12.0)),
          new Image.network(
              'https://media.giphy.com/media/6nuiJjOOQBBn2/giphy.gif'),
          new Padding(padding: EdgeInsets.all(10.0)),
          new Text(
            'Great job, you answer all questions correct!',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          RaisedButton(
            child: new Text('Go back'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );             },
          )
        ],
      );
    }
    if (this.score <= midMark) {
      return Column(
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(15.0)),
          new Text('Total score: $score'),
          new Padding(padding: EdgeInsets.all(12.0)),
          new Image.network(
              'https://media.giphy.com/media/WoFqnK8UvaqqrgCjyg/giphy.gif'),
          new Padding(padding: EdgeInsets.all(10.0)),
          new Text(
            'You need to practice the words more',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          RaisedButton(
            child: new Text('Go back'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );             },
          )
        ],
      );
    }
    if (this.score > midMark && this.score < fullMark) {
      return Column(
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(15.0)),
          new Text('Total score: $score'),
          new Padding(padding: EdgeInsets.all(12.0)),
          new Image.network(
              'https://media.giphy.com/media/31Q36EHJ7C5ZoIMw79/giphy.gif'),
          new Padding(padding: EdgeInsets.all(10.0)),
          new Text(
            'Good job, you almost get full mark',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          RaisedButton(
            child: new Text('Go back'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );            },
          )
        ],
      );
    }
  }
}
