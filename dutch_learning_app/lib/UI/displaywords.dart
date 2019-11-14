import 'package:dutch_learning_app/UI/wordtypepage.dart';
import 'package:dutch_learning_app/classes/words.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_tts/flutter_tts.dart';


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
  FlutterTts flutterTts = new FlutterTts();

  Future _speak(String word) async{

    await flutterTts.setLanguage("nl");
    var speach = await flutterTts.speak(word);
  }


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

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordTypesPage(widget.userId, null),

                      ),
                    );

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
                Text(widget.title,
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

                        itemCount: this.allWords.length,
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

                                            tag: allWords[index].img,
                                            child: Image(
                                              image: NetworkImage(allWords[index].img),
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
                                              allWords[index].word,
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

                                      this._speak(allWords[index].word);


                                    },
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

  Widget _wordsTranslate(String img, String word, int index){

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
                        image: NetworkImage(img),
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

                this._speak(allWords[index].word);


              },
            ),
          ],
        ),
      ),
    );

  }
}
