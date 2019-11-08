import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> updateRankingTable(String name, String img, int score,
      String userId, int isUserexsist) async {
    //  var userNotExsist = this.checkUserOnRankingTable(name);
    if (isUserexsist == 0) {
      final databaseReference =
          FirebaseDatabase.instance.reference().child('Ranking').child(userId);
      databaseReference.set({'name': name, 'img': img, 'score': score});
    } else {
      final databaseReference = FirebaseDatabase.instance
          .reference()
          .child('Ranking')
          .child(userId)
          .update({'score': score});
    }
  }

  Future<void> updateVideoChatTopicTable(String topic, int nrOfView) async {
    //  var userNotExsist = this.checkUserOnRankingTable(name);
    if (nrOfView == 0) {
      final databaseReference =
      FirebaseDatabase.instance.reference().child('VideoChatTopices').push();
      databaseReference.set({'topic': topic, 'view': 0});
    } else {
      final databaseReference = FirebaseDatabase.instance
          .reference()
          .child('VideoChatTopices')
          .update({'view': nrOfView});
    }
  }

  updateUser(int updateScore, String userId) {
    //  this.getCurrentUser();
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(userId)
        .child('profile')
        .update({'points': updateScore});
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
