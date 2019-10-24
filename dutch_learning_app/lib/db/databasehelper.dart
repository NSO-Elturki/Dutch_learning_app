import 'dart:io';
import 'dart:math';

import 'package:dutch_learning_app/UI/quizresult.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userId;

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser().then((user) {
      this.userId = user.uid;
    });
  }

  getCurrentUserInfo() async {
    this.getCurrentUser();
    User user;
    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(userId)
        .child('profile');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {

        this.updateRankingTable(values['name'], values['image'], values['points']);
      });
    });

  }

  Future<void> updateRankingTable(String name, String img, int score) async {


    //to get image from storge and upload to realtime
      final databaseReference = FirebaseDatabase.instance
          .reference()
          .child('Ranking')
          .push();
      databaseReference
          .set({'name': name, 'img': img, 'score': score});
  }

  updateUser(int updateScore){

  //  this.getCurrentUser();
  final databaseReference = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child('FZaDKCGEfIcbdeaj0cN3KV8kU7I3')
      .child('profile')
      .update({

    'points': updateScore
  });
  


}



  Future<void> saveTranslateItemToDb(String image, String nameOfItemInEn,
      String nameOfItemInNl, String groupName) async {
    this.getCurrentUser();
    final String imageName = Random().nextInt(10000).toString();
    var convertImagToFile = new File(image);
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$imageName');

    final StorageUploadTask storageUploadTask =
        storageReference.putFile(convertImagToFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    //to get image from storge and upload to realtime
    final ref = FirebaseStorage.instance.ref().child('Images/$imageName');
    var imageURL = await ref.getDownloadURL().then((value) {
      final databaseReference = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(userId)
          .child('words')
          .child(groupName)
          .push();
      databaseReference.set({
        'itemInEn': nameOfItemInEn,
        'ItemInNl': nameOfItemInNl,
        'ItemImg': value
      });
    });
  }

  Future<void> saveUserProfile(String name, String city, File image) async {
    // this.getCurrentUser();
    final String imageName = Random().nextInt(10000).toString();
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$imageName');

    final StorageUploadTask storageUploadTask = storageReference.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    //to get image from storge and upload to realtime
    final ref = FirebaseStorage.instance.ref().child('Images/$imageName');
    var imageURL = await ref.getDownloadURL().then((value) {
      final databaseReference = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child('qYwM6hfzmdgzTUBYcdogYVJBKKh1')
          .child('profile')
          .push();
      databaseReference
          .set({'name': name, 'city': city, 'image': value, 'points': 0});
    });
  }
}
