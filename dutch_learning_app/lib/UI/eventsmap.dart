import 'dart:ffi';
import 'dart:math';

import 'package:dutch_learning_app/UI/eventmembers.dart';
import 'package:dutch_learning_app/db/databasehelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:camera/camera.dart';
import 'package:dutch_learning_app/UI/camera.dart';




class EventsMap extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EventMapState();
  }

}

class EventMapState extends State<EventsMap>{

  GoogleMapController mapController;
  List<Marker> _markers = [];
  DatabaseHelper db;
  var lat, long;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final LatLng _center = const LatLng(51.4416, 5.4697);

  getAllEvent() async{

    final String _markerID = Random().nextInt(10000).toString();

    DatabaseReference _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('Events');
    await _firebaseDatabase.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {


        setState((){



        print(values['address'].toString());
        print(key.toString());
        var lat = values['lat'];
        var long = values['long'];


        _markers.add(Marker(
              markerId: MarkerId(_markerID),
              position: LatLng(lat, long),
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventMembers(values['address']),
                  ),
                );
              }

          ));


        });
      });
    });
 }




  drawMarker(String adress) async{

  //  final query = "Rachelsmolen 1, 5612 MA Eindhoven";
    var addresses = await Geocoder.local.findAddressesFromQuery(adress);
    var first = addresses.first;
    setState(() {

      lat = first.coordinates.latitude;
      long = first.coordinates.longitude;
    });


    final String _markerID = Random().nextInt(10000).toString();

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_markerID),
        position: LatLng(lat, long),
        onTap: (){

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventMembers(adress),
            ),
          );
        }

      )
      );
    });

  }

  @override
  void initState() {
    super.initState();
    this.db = new DatabaseHelper();
    this.getAllEvent();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Map'),
        leading: new Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              this.goToCamera();
            },
          ),
        ),
      ),
      body: GoogleMap(

        markers: Set.from(_markers),
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0
        ),

      ),
      floatingActionButton: FloatingActionButton(

        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: (){


           this.addEvent();
        },
      ),

    );
  }

  Widget showEventInfo(){

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text('Heart Shaker'),
            subtitle: Text('TWICE'),
          ),
        ],
      ),
    );
  }

  addEvent(){

    TextEditingController eventAddress = new TextEditingController();
    TextEditingController eventPlaceName = new TextEditingController();


    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Give the address of the event'),
            content: TextField(
              controller: eventAddress,
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  try{

                      this.drawMarker(eventAddress.text);
                      this.db.saveAddress(eventAddress.text, lat, long);

                  }catch(e){print(e);}
                },
              )
            ],
          );
        });

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