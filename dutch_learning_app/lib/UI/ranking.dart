import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dutch_learning_app/classes/rank.dart';
import 'package:camera/camera.dart';
import 'package:dutch_learning_app/UI/camera.dart';


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
    this.sortList();
  }

  @override
  void initState() {
    super.initState();
   this.getUsersRank();
  // this.sortList();
  }

  sortList(){

    Comparator<Ranker> priceComparator = (a, b) => b.score.compareTo(a.score);
    allUsers.sort(priceComparator);

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
                )
              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Ranking',
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

                        itemCount: this.allUsers.length,
                        itemBuilder: (context, index){

                          return Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                            child: InkWell(
                              onTap: (){


                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Hero(

                                            tag: allUsers[index].img,
                                            child: Image(
                                              image: NetworkImage(allUsers[index].img),
                                              fit: BoxFit.cover,
                                              height: 75.0,
                                              width: 75.0,
                                            )
                                        ),
                                        SizedBox(width: 10.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              allUsers[index].name,
                                              style: TextStyle(

                                                  fontFamily: 'Montserrat',
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              allUsers[index].score.toString(),
                                              style: TextStyle(

                                                  fontFamily: 'Montserrat',
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
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