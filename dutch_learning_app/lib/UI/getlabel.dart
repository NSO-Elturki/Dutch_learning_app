import 'dart:convert';
import 'dart:core';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:translator/translator.dart';
import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:dutch_learning_app/UI/wordspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';



class GetLabel extends StatefulWidget {
  final String imagePath;
  GetLabel(this.imagePath);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<GetLabel> {
  List<ImageLabel> _labels;
  File userTakenImage;
  var englishWord = '';
  var dutchTranslate = '';
  final translator = GoogleTranslator();
  DatabaseHelper db;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userId;

  Future<FirebaseUser>getCurrentUser() async{


    return await _auth.currentUser().then((user){

      this.userId = user.uid;

    });

  }


  saveWordToDb() {
    TextEditingController insertText = new TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Please choose where to save the new word'),
            content: TextField(
              controller: insertText,
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  print(insertText.text);
                  try{

                    db.saveTranslateItemToDb(widget.imagePath, englishWord, dutchTranslate, insertText.text);


                  }catch(e){print(e);}
                },
              )
            ],
          );
        });
  }



  void _takenImageByUser() async {
    try {
      final imageFromCamera = new File(widget.imagePath);
      final image = FirebaseVisionImage.fromFile(imageFromCamera);

      final ImageLabeler labeler = FirebaseVision.instance.imageLabeler(
        ImageLabelerOptions(confidenceThreshold: 0.75),
      );

      final labels = await labeler.processImage(image);
      if (this.mounted) {
        setState(() {
          this._labels = labels;
          this.userTakenImage = imageFromCamera;
        });
      }

      setState(() {
        this._translateToDutch(_labels[0].text);
        this.englishWord = _labels[0].text;
      });

      this._translateToDutch(englishWord);
    } catch (e) {}
  }

  void _translateToDutch(String word) {
    final input = word;

    translator.translate(input, to: 'nl').then((dutchWord) {
      setState(() {
        this.dutchTranslate = dutchWord;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    db = new DatabaseHelper();
    this._takenImageByUser();
    this.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('$englishWord - $dutchTranslate'),
      ),
      body: Image.file(new File(widget.imagePath)),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: saveWordToDb,
//        backgroundColor: Colors.green,
//      ),
    persistentFooterButtons: <Widget>[
    new FloatingActionButton(
      heroTag: 'saveWord',
        onPressed: saveWordToDb,
        backgroundColor: Colors.green,
      child: new Text('Save'),
      ),
      new FloatingActionButton(
        heroTag: 'showWords',
        child: new Text('Show all words'),

        onPressed: (){

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WordsPage(userId,'showWords'),
            ),
          );
        },
        backgroundColor: Colors.green,
      ),
    ],
    );
  }
}
