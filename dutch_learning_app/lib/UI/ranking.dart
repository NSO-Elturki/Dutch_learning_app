import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class User{

  String city, name, image;
  int points;
  User(String name, String city, int points, String image){
    this.name = name;
    this.city = city;
    this.points = points;
    this.image = image;
  }
}
class Rank{

  String name, img;
  int score;
  Rank(String name, String img, int score){

    this.name = name;
    this.img = img;
    this.score = score;
  }
}

class Ranking extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RankingState();
  }


}

class RankingState extends State<Ranking>{

  List<Rank>allUsers = new List<Rank>();

  getAllWords() async {
    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Ranking');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          allUsers.add(new Rank(values['name'], values['img'], values['score']));
          print(allUsers.length);
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