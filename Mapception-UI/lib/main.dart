import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geolocator;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapception/location_list.dart';
import 'package:mapception/place_services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import 'search-map.dart';

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
  StreamSubscription _locationSubscription;
  PanelController _panelController =
      new PanelController(); //control the slide up menu panel
  //Geolocator geolocator = Geolocator();
  Marker marker; //adds the locator icoon to mark current location in real time
  List<Marker> _markers = <Marker>[]; //list of markers for locations picked
  Location _locationTracker = Location();
  Circle circle; // adds a circle around the marker for visibility
  bool flag = false;
  Map _position;

  final _destinationController = TextEditingController();

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 11.5,
  );

  static const double fabHeightClosed = 130.0;
  double fabHeight = fabHeightClosed;

  //code to convert icon asset to bitmap
  Future<Uint8List> getMarker() async {
    ByteData bytedata =
        await DefaultAssetBundle.of(context).load("assets/locator.png");
    return bytedata.buffer.asUint8List();
  }

  void updateMarker(LocationData _locationData, Uint8List imageData) async {
    LatLng latlng = LatLng(_locationData.latitude, _locationData.longitude);
    this.setState(() {
      _markers.add(Marker(
        markerId: MarkerId("current_location"),
        position: latlng,
        draggable: false,
        flat: true,
        zIndex: 2,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData),
      ));
      circle = Circle(
        circleId: CircleId("locator-circle"),
        radius: _locationData.accuracy,
        zIndex: 1,
        center: latlng,
        strokeColor: Colors.lightBlue,
        fillColor: Colors.blue.withAlpha(80),
      );
    });
  }

//utility function to get the current location using geocoder api
  void _gotoCurrentPosition() {
    if (null != _controller && null != _position) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: _position["heading"],
              target: LatLng(_position["lat"], _position["lng"]),
              tilt: 0,
              zoom: 14.00),
        ),
      );
    }
  }

  //utility function to transition map camera to given coordinates from present state location
  void _gotoGivenPostion(double lat, double long) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(lat, long),
      zoom: 16.00,
    )));
  }

  void _getCurrentLocation() async {
    //print("executing _getCurrentLocation ");
    try {
      Uint8List imageData = await getMarker();
      var currentLocation = await _locationTracker.getLocation();

      updateMarker(currentLocation, imageData);
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged
          .listen((LocationData newLocalData) {
        setState(() {
          _position = {
            "lat": newLocalData.latitude,
            "lng": newLocalData.longitude,
            "heading": newLocalData.heading,
          };
        });
        updateMarker(newLocalData, imageData);
      });
    } on PlatformException catch (error) {
      if (error.code == 'PERMISSION DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  //utility function to dynamically add markers
  void _addMarker(markerId, coord) {
    _markers.add(Marker(
      markerId: MarkerId(markerId),
      position: coord,
      infoWindow: InfoWindow(title: 'The title of the marker'),
      draggable: false,
    ));
  }

  void _findLocationAndAddMarker(LatLng pos) async {
    final sessionToken = Uuid().v4();
    List<geolocator.Placemark> placemarks =
        await geolocator.placemarkFromCoordinates(pos.latitude, pos.longitude);
    //Assuming the first result is correct
    var placeDetails = await PlaceApiProvider(sessionToken).fetchAddress(pos);
    print(placeDetails[0]['place_id']);
    //add marker
    _addMarker(placeDetails[0]['place_id'], pos);
    //add to list
    addToList(placeDetails[0]['place_id'], placeDetails[0]['formatted_address'],
        placeDetails[0]['formatted_address'], pos);
  }

  //utility function to go to current position and add marker
  void addMarkerAndGoPosition(double lat, double long, markerId) {
    _gotoGivenPostion(lat, long);
    _addMarker(markerId, LatLng(lat, long));
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height *
        0.8; //relative height of panel when fully opened
    final panelHeightClosed = MediaQuery.of(context).size.height *
        0.15; //relative height of panel when closed
    print(fabHeight);
    _getCurrentLocation();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            markers: Set<Marker>.of(_markers),
            circles: Set.of((circle != null) ? [circle] : []),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            onTap: (_position) async {
              print(_position);
              _findLocationAndAddMarker(_position);
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
                      onTap: () async {
                        final sessionToken = Uuid().v4();
                        final Suggestion result = await showSearch(
                          context: context,
                          delegate: DataSearch(sessionToken),
                        );
                        if (result != null) {
                          final placeDetails =
                              await PlaceApiProvider(sessionToken)
                                  .getPlaceDetails(result.placeId);
                          setState(() {
                            LatLng _coord = LatLng(
                                placeDetails.coordinates['lat'],
                                placeDetails.coordinates['lng']);
                            //animate camera to location once json request has been received
                            _gotoGivenPostion(
                                _coord.latitude, _coord.longitude);
                            _addMarker(result.placeId, _coord);
                            _destinationController.text = result.description;
                          });
                          printList();
                        }
                        //showSearch(context: context, delegate: DataSearch());
                      },
                      controller: _destinationController,
                      readOnly: true,
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
                ),
              ])),
          SlidingUpPanel(
            backdropEnabled: true,
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            color: Color(0xFF2D2F40),
            borderRadius: BorderRadius.circular(30),
            controller: _panelController,
            panel: Center(
              child: ReorderableListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: mapList.length,
                itemBuilder: (context, index) {
                  if (index >= mapList.length) {
                    //taken from stackoverflow to fix range error
                    return const Offstage();
                  }
                  return Card(
                    color: Color.fromRGBO(64, 75, 96, .9),
                    key: ValueKey(mapList[index]),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.white24))),
                        child: Text("${index + 1} ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                                fontFamily: 'Open Sans')),
                      ),
                      title: Text(
                        mapList[index].address,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      trailing: IconButton(
                        padding: EdgeInsets.only(left: 20),
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          linkedData.remove(mapList[index]
                              .placeId); //remove item from the linkedhashmap
                          _markers.removeAt(index);
                          mapList.removeAt(index); //remove item from the list
                        },
                      ),
                      onTap: () {
                        _panelController.close();
                        addMarkerAndGoPosition(
                            mapList[index].coordinates.latitude,
                            mapList[index].coordinates.longitude,
                            mapList[index].placeId);
                      },
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  /*Logic to handle swapping of list items */
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = mapList.removeAt(oldIndex);
                    mapList.insert(newIndex, item);
                    linkedData
                        .clear(); /*recreate a linked hashmap for each swap operation*/
                    mapList.forEach((element) => linkedData[element.placeId] =
                        LocationList(
                            placeId: element.placeId,
                            address: element.address,
                            condensedName: element.condensedName,
                            coordinates: element.coordinates));
                  });
                },
              ),
            ),
            collapsed: Container(
              color: Colors.blueGrey,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                tileColor: Colors.blueGrey[800],
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Text("${linkedData.length} ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          fontFamily: 'Open Sans')),
                ),
                title: Text("Hi"),
              ),
            ),
            onPanelSlide: (position) => setState(() {
              final panelScrollExtent = panelHeightOpen - panelHeightClosed;
              fabHeight = position * panelScrollExtent + fabHeightClosed;
            }),
          ),

          /*Set up a Floating action button */
          Positioned(
              right: 20,
              bottom: fabHeight,
              child: FloatingActionButton(
                onPressed: () {
                  if (_panelController.isPanelOpen) {
                    _panelController.close();
                    _gotoCurrentPosition();
                  }
                  _gotoCurrentPosition();
                },
                // ignore: unnecessary_statements
                child: Icon(Icons.location_pin),
                backgroundColor: Colors.cyan,
              )),

          /*TODO: ADD PROFILE BUTTON*/
          /*Positioned(
            top: 70,
            right: 0,
            left: 80,
            child: Container(
              child:Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      image: DecorationImage(
                        image: AssetImage('assets/locator.png'),
                      ), 
                    ),
                  )
                ]
              )
            )
          ),*/
        ],
      ),
    );
  }
}
