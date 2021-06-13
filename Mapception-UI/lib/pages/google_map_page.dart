import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapception/services/directions_repo.dart';
import 'package:mapception/services/place_services.dart';
import 'package:mapception/services/writeToFile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:uuid/uuid.dart';

import '../services/location_list.dart';
import 'search-map.dart';

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

  String startLocationProgBar =
      'Nil'; //controls the start location of the progress bar
  String endLocationProgBar = 'Nil';

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
  void _addMarker(markerId, coord, address) {
    _markers.add(Marker(
      markerId: MarkerId(markerId),
      position: coord,
      infoWindow: InfoWindow(title: "$address"),
      draggable: false,
    ));
  }

  void _findLocationAndAddMarker(LatLng pos) async {
    final sessionToken = Uuid().v4();
    //Assuming the first result is correct
    var placeDetails = await PlaceApiProvider(sessionToken).fetchAddress(pos);
    print(placeDetails[0]['place_id']);
    //add marker
    _addMarker(
        placeDetails[0]['place_id'], pos, placeDetails[0]['formatted_address']);
    //add to list
    addToList(placeDetails[0]['place_id'], placeDetails[0]['formatted_address'],
        placeDetails[0]['formatted_address'], pos);
  }

  //utility function to go to current position and add marker
  void addMarkerAndGoPosition(
      double lat, double long, markerId, String address) {
    _gotoGivenPostion(lat, long);
    _addMarker(markerId, LatLng(lat, long), address);
  }

  //utility function to clear variable values
  void clearVariables() {
    totalDistance = 0;
    totalDuration = 0;
    polylines.clear();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height *
        0.8; //relative height of panel when fully opened
    final panelHeightClosed = MediaQuery.of(context).size.height *
        0.15; //relative height of panel when closed
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
            polylines: polylines,
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
                        print(mapList.length - clickedSearchItems);
                        /*handle markers for those clicked by + button */
                        for (int i = mapList.length - clickedSearchItems;
                            i < mapList.length;
                            i++) {
                          setState(() {
                            _addMarker(mapList[i].placeId,
                                mapList[i].coordinates, mapList[i].address);
                          });
                        }
                        print(mapList);
                        clickedSearchItems = 0; //reset counter to 0
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
                            _addMarker(
                                result.placeId, _coord, result.description);
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
            panel: Column(children: <Widget>[
              SizedBox(height: 10),
              GestureDetector(
                  //create drag handle
                  child: Center(
                    child: Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onTap: () {
                    _panelController.isPanelOpen
                        ? _panelController.close()
                        : _panelController.open();
                  }),
              //
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 70,
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10),
                    //color: Color.fromRGBO(64, 75, 96, .9),
                    ),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("At A Glance",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.left),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Card(
                  color: Color.fromRGBO(64, 75, 96, .9),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${linkedData.length - placesVisited}",
                              style: TextStyle(
                                color: Colors.teal[300],
                                fontFamily: 'Karla',
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "/${linkedData.length} places to go",
                              style: TextStyle(
                                fontFamily: 'Karla',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(Icons.location_city,
                                      color: Colors.pink[200]),
                                ),
                              ),
                            ])),
                            Column(
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: "Starting Point:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                RichText(
                                    text: TextSpan(
                                        text: startLocationProgBar,
                                        style: TextStyle(
                                            color: Colors.grey[500]))),
                              ],
                            ),
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(Icons.location_city,
                                      color: Colors.pink[200]),
                                ),
                              ),
                            ])),
                            Column(
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: "Ending Point:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                RichText(
                                    text: TextSpan(
                                        text: endLocationProgBar,
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                    overflow: TextOverflow.clip),
                              ],
                            ),
                          ]),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: StepProgressIndicator(
                          totalSteps: linkedData.length + 1,
                          currentStep: placesVisited,
                          size: 8,
                          padding: 0,
                          selectedColor: Colors.cyan,
                          unselectedColor: Colors.cyan[900],
                          roundedEdges: Radius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(Icons.directions_transit,
                            color: Colors.pink[200]),
                      ),
                    ),
                  ])),
                  Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "${linkedData.length} Destinations",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      RichText(
                          text: TextSpan(
                              text: "Selected",
                              style: TextStyle(color: Colors.grey[500]))),
                    ],
                  ),
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(Icons.timer, color: Colors.pink[200]),
                      ),
                    ),
                  ])),
                  Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "$totalDuration mins",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      RichText(
                          text: TextSpan(
                              text: "Total Time",
                              style: TextStyle(color: Colors.grey[500]))),
                    ],
                  ),
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(Icons.directions_walk_rounded,
                            color: Colors.pink[200]),
                      ),
                    ),
                  ])),
                  Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "$totalDistance km",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      RichText(
                          text: TextSpan(
                              text: "Total Distance",
                              style: TextStyle(color: Colors.grey[500]))),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10),
              Expanded(
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
                            setState(() {
                              //find the marker to remove it
                              Marker markerToRemove = _markers.firstWhere(
                                  (marker) =>
                                      marker.markerId.value ==
                                      "${mapList[index].placeId}",
                                  orElse: () => null);
                              _markers.remove(markerToRemove); //remove marker
                            });
                            mapList.removeAt(index); //remove item from the list
                          },
                        ),
                        onTap: () {
                          _panelController.close();
                          addMarkerAndGoPosition(
                              mapList[index].coordinates.latitude,
                              mapList[index].coordinates.longitude,
                              mapList[index].placeId,
                              mapList[index].address);
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
              Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 143, 158, 1),
                          Color.fromRGBO(255, 188, 143, 1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: ElevatedButton(
                    onPressed: () async {
                      clearVariables();
                      /*RUNNING ALGORITHM FOR TRAVELLING SALESMAN HERE! */
                      //create storage 2d list
                      var pathDurationPermutations =
                          List<List<double>>.generate(
                              mapList.length, (i) => List(mapList.length),
                              growable: false);
                      if (mapList.length > 2) {
                        for (int i = 0; i < mapList.length - 1; i++) {
                          for (int j = mapList.length - 1; j > i; j--) {
                            double durationValue =
                                await generatePathFunction(i, j);
                            pathDurationPermutations[i][j] = durationValue;
                          }
                        }
                        await saveFile(pathDurationPermutations);
                        await runAlgoAndSetPolylines();
                      } else if (mapList.length == 2) {
                        generatePathFunction(0, 1);
                        runAlgoAndSetPolylines();
                      }
                      startLocationProgBar =
                          mapList[0].condensedName.split(',')[0];
                      endLocationProgBar = mapList[mapList.length - 1]
                          .condensedName
                          .split(',')[0];
                      flag = true;
                      _panelController.close();
                      //print(mapList[0].coordinates);
                    },
                    style:
                        ElevatedButton.styleFrom(primary: Colors.transparent),
                    child: Text("Generate Route!"),
                  )),
            ]),
            collapsed: Container(
              color: Colors.blueGrey,
              child:
                  flag ? CollpasedMenuWithRoute() : CollpasedMenuWithoutRoute(),
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

  Future<double> generatePathFunction(int i, int j) async {
    var responseData = await findIndividualDirections(mapList[i].coordinates,
        mapList[j].coordinates, mapList[i].placeId, "from${i}to$j");
    double durationValue =
        double.parse(responseData.journeyDuration.split(" ")[0]);
    double distValue = double.parse(responseData.dist.split(" ")[0]);
    totalDuration += durationValue;
    totalDistance += distValue;
    return durationValue;
  }
}

/* CollpasedMenuWithoutRoute displays the collapsed widget when route is not being generated
    It contains basic info about selected route length & route duration
*/
class CollpasedMenuWithoutRoute extends StatelessWidget {
  const CollpasedMenuWithoutRoute({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      tileColor: Colors.blueGrey[800],
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Text("${linkedData.length}",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 25,
                fontFamily: 'Open Sans')),
      ),
      title: Text("$totalDuration min \n$totalDistance km",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20,
              fontFamily: 'Open Sans')),
    );
  }
}

/* CollpasedMenuWithoutRoute displays next route information
    Displays when generate route is pressed
*/
class CollpasedMenuWithRoute extends StatelessWidget {
  const CollpasedMenuWithRoute({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      tileColor: Colors.blueGrey[800],
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.location_pin, color: Colors.white),
      ),
      title: Text("${mapList[0].condensedName.split(',')[0]}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20,
              fontFamily: 'Open Sans')),
    );
  }
}
