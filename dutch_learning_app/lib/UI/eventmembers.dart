import 'package:dutch_learning_app/UI/eventsmap.dart';
import 'package:dutch_learning_app/classes/user.dart';
import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EventMembers extends StatefulWidget{

  String eventAddress;
  EventMembers(this.eventAddress);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EventMembersState();
  }


}

class EventMembersState extends State<EventMembers>{

  DatabaseHelper db;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//  List<User>allMembers = new List<User>();
  List<User>allMembers = new List<User>();
  var usersIds = [];

  var userId;

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser().then((user) {
      this.userId = user.uid;
    });
  }

  addUserToEvent() async {
    debugPrint('$userId NAGI');
    debugPrint('${widget.eventAddress}NAGI2');

    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(userId)
        .child('profile');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {
        setState(() {
          var name = values["name"];
          var city = values["city"];
          var points = values["points"];
          var image = values["image"];


          db.saveNewEventMember(User(name, city, points, image), widget.eventAddress, userId);
        });
      });
    });
  }

  getAllEventMembers() async{

    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('EventsMembers')
        .child(widget.eventAddress);
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {
        setState(() {
          var name = values["name"];
          var city = values["city"];
          var points = values["points"];
          var image = values["image"];
          this.allMembers.add(User(name, city, points, image));
          this.usersIds.add(values['id']);


        });
        print(key);
      });
    });

  }

  @override
  void initState() {
    super.initState();

   db = new DatabaseHelper();
   getCurrentUser();
   getAllEventMembers();
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

                    this.goToMap();

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
                Text('Event',
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

                        itemCount: this.allMembers.length,
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

                                            tag: allMembers[index].image,
                                            child: Image(
                                              image: NetworkImage(allMembers[index].image),
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
                                              allMembers[index].name,
                                              style: TextStyle(

                                                  fontFamily: 'Montserrat',
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              allMembers[index].points.toString(),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: (){


         // this.addUserToEvent();
          if(this.checCurrentkUserInList(this.userId) == true){

            debugPrint('User already in the list');
            this.userIsInTheList();
          }else{

              this.addUserToEvent();

          }
        },

      ),
    );

  }

  userIsInTheList(){

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('You are already in the event list'),

            actions: <Widget>[
              FlatButton(
                child: new Text('Ok'),
                onPressed: (){

                  Navigator.of(context).pop();

                },
              )
            ],
          );
        });
  }

  checCurrentkUserInList(String id){

    for( String i in this.usersIds){

      if(i == id){

        return true;
      }

    }
    return false;
  }

  void goToMap() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventsMap(),
      ),
    );
  }



}