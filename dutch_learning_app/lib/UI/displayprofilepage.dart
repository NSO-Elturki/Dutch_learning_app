import 'package:flutter/material.dart';


class DisplayProfilePage extends StatefulWidget{

  String userImage, userName, userCity;
  int userScore;
  DisplayProfilePage(this.userImage, this.userName, this.userScore, this.userCity);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DisplayProfilePageState();
  }


}
class DisplayProfilePageState extends State<DisplayProfilePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: Stack(

        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.blue),
            clipper: getClipper(),
          ),
          Positioned(

            width: 350.0,
            top: MediaQuery.of(context).size.height/5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      image: NetworkImage(widget.userImage),
                      fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75.0))
                  ),
                ),
                Text(

                  widget.userName,
                  style: TextStyle(

                    color: Colors.black,
                    fontSize: 50.0,

                  ),


                ),
                SizedBox(height: 45.0),
                Text(

                  'City: ' + widget.userCity,
                  style: TextStyle(

                    color: Colors.black,
                    fontSize: 35.0,


                  ),


                ),
                SizedBox(height: 20.0),

                Text(

                  'Score:' +widget.userScore.toString(),
                  style: TextStyle(

                    color: Colors.black,
                    fontSize: 35.0,


                  ),


                ),
              ],
            ),
          )
        ],
      )
      ,
    );
  }

}

class getClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }


}