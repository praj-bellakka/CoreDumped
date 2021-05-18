import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapception',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //Position _currentPosition; //object to hold location data
  GoogleMapController _controller;
  //Geolocator geolocator = Geolocator();
  Marker marker;
  Location location = Location();
  Circle circle;
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 11.5,
  );

  //_onMapCreated generates an animation to focus on the user's current location
  // StreamSubscription<Position> homeTabPostionStream;
  // //_controller = _cntlr;
  // homeTabPostionStream = Geolocator.getPositionStream(
  //         desiredAccuracy: LocationAccuracy.bestForNavigation)
  //     .listen((location) async {
  //   print(_currentPosition);
  //   _controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(10, 1),
  //     zoom: 20,
  //   )));
  // });
  // if (_currentPosition != null) {
  //   _controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //           target:
  //               LatLng(_currentPosition.latitude, _currentPosition.longitude),
  //           zoom: 15),
  //     ),
  //   );
  // }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _controller;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //     title: Text('Mapception'),
        //     backgroundColor: Colors.blue[400],
        //   ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
            Positioned(
                top: 70.0,
                right: 15.0,
                left: 15.0,
                child: Column(children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                        decoration: InputDecoration(
                      labelText: "Going to?",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    )),
                  )
                ])),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getCurrentLocation();
          },
          child: Icon(Icons.location_pin),
          backgroundColor: Colors.cyan,
        ));
  }


  void updateMarker(LocationData _locationData) {
    LatLng latlng = LatLng(_locationData.latitude, _locationData.longitude);
    this.setState((){
      marker = Marker(
        markerId: MarkerId("current_location"),
        position:latlng,
        draggable: false,
        flat: true,
        //icon: BitmapDescriptor.fromBytes("ADD CUSTOM MARKER HERE")

      );
    });
  }
//function to get the current location using geocoder api
  void _getCurrentLocation() async {
    try {
      var currentLocation = await location.getLocation();
      
    } 
  }
}
