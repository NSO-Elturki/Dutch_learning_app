import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dutch_learning_app/classes/rank.dart';

class Ranking extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RankingState();
  }

}

class RankingState extends State<Ranking>{

  List<Ranker>allUsers = new List<Ranker>();

  getUsersRank() async {
    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Ranking');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          allUsers.add(new Ranker(values['name'], values['img'], values['score']));
          print(allUsers.length);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
   this.getUsersRank();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: new AppBar(
        title: new Text('Ranking'),
        backgroundColor: Colors.deepOrange[700],
      ),
      body: ListView.builder(
        itemCount: this.allUsers.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: new Text(allUsers[index].name),
                subtitle: new Text(allUsers[index].score.toString()),
                leading: CircleAvatar(
                  child: Image.network(
                    allUsers[index].img,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
            ],
          );
        },
      ),
    );
  }

}