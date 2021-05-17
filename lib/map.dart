import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicineapp/homescreen.dart';

class MapPage extends StatefulWidget {
  final bool hasOrdered = true;                                                 //Since a user can only come to this page once the order is complete, hence setting it to true
                                                                                //and will use it to navigate directly to this page
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {                                          //The code is pretty straight-forward integration of google maps
                                                                                // with starting location at Marine Drive
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[200],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 10.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 7.0,
                          color: Colors.grey[700],
                          offset: Offset(1.0, 1.0),
                        ),
                      ], //shadows[]
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    height: 700.0,
                    width: 400.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(18.947227557399, 72.820775229464),
                            zoom: 11.5),
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(hasOrdered: widget.hasOrdered)));
                      },
                      child: Text(
                        "Go to Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 7.0,
                              color: Colors.grey[700],
                              offset: Offset(1.0, 1.0),
                            ),
                          ], //shadows[]
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
