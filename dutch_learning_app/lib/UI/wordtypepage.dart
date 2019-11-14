import 'package:dutch_learning_app/UI/quizpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dutch_learning_app/UI/displaywords.dart';
import 'package:camera/camera.dart';
import 'package:dutch_learning_app/UI/camera.dart';


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
               Text('Type of words',
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

                      itemCount: typeOfWords.length,
                      itemBuilder: (context, index){

                        return ListTile(
                          title: new Text(typeOfWords[index],
                            style: TextStyle(

                                fontFamily: 'Montserrat',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          onTap: (){
                            this.nextPage(typeOfWords[index]);

                          },
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

  Widget _wordsTranslate(String img, String word){

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

                       tag: img,
                       child: Image(
                         image: AssetImage(img),
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
                           word,
                           style: TextStyle(

                             fontFamily: 'Montserrat',
                             fontSize: 17.0,
                             fontWeight: FontWeight.bold
                           ),
                         )
                       ],
                     )
                   ],
                 ),
               ),
               IconButton(

                 icon: Icon(Icons.surround_sound),
                 color: Colors.black,
                 onPressed: (){


                 },
               ),
             ],
         ),
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
