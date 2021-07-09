import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationList {
  final placeId;
  final address;
  final condensedName;
  final LatLng coordinates;
  LocationList(
      {this.placeId, this.address, this.condensedName, this.coordinates});

  Map<String, dynamic> toJson() => {
        'placeId': placeId,
        'address': address,
        'condensedName': condensedName,
        'coordinates': coordinates
  };

  
}

/*ORIGINAL VERSION OF MAPLIST. UNCOMMENT ONCE TESTING IS DONE!*/
List<LocationList> mapList = [];
int placesVisited = 0;

/*List implementation */
//using a linkedhashmap to store the details; Using placeid as the key, LocationList as the value
LinkedHashMap<String, LocationList> linkedData =
    LinkedHashMap<String, LocationList>();

void addToList(
    var _placeId, var _address, var _condensedName, LatLng _coordinates) {
  LocationList newLocation = LocationList(
      placeId: _placeId,
      address: _address,
      condensedName: _condensedName,
      coordinates: _coordinates);
  linkedData[_placeId] = newLocation; //add to linked hash map
  mapList = linkedData.values.toList();
}

//Debug utility function to print list
void printList() {
  //print(locationList.length);

  print(linkedData.length);
  print(linkedData.values);
}
