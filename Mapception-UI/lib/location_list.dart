import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationList {
  final placeId;
  final address;
  final condensedName;
  final LatLng coordinates;
  LocationList(
      {this.placeId, this.address, this.condensedName, this.coordinates});
}

/*ORIGINAL VERSION OF MAPLIST. UNCOMMENT ONCE TESTING IS DONE!*/
//var mapList;

/*THIS IS A DEBUG VERSION OF MAPLIST TO REDUCE API REQUESTS. CHANGE BACK TO ORIGINAL VERSION AFTER TESTING!*/
var mapList = [
  LocationList(address: "Arab Street, Singapore", condensedName:"Arab Street, Singapore", coordinates: LatLng(1.3023026, 103.85816190000003),
  placeId: "EhZBcmFiIFN0cmVldCwgU2luZ2Fwb3JlIi4qLAoUChIJd20Ex7AZ2jERKkn67E-Gq0YSFAoSCXWTi4ojEdoxEcT1q1LPaXiI"),
  LocationList(address: "Yishun Street 51, Singapore", condensedName:"Yishun Street 51, Singapore", coordinates: LatLng(1.4163675, 103.84335900000002),
  placeId: "EhtZaXNodW4gU3RyZWV0IDUxLCBTaW5nYXBvcmUiLiosChQKEgnRKc7oPxTaMREewGKDvAGkCRIUChIJyY4rtGcX2jERIKTarqz3AAQ"),
  LocationList(address: "Marina Boulevard, Singapore", condensedName:"Marina Boulevard, Singapore", coordinates: LatLng(1.2808044, 103.8541596),
  placeId: "EhtNYXJpbmEgQm91bGV2YXJkLCBTaW5nYXBvcmUiLiosChQKEgnjIQa0DxnaMREoAd-aNdhaWxIUChIJdZOLiiMR2jERxPWrUs9peIg"),
  LocationList(address: "Sentosa Gateway, Singapore", condensedName:"Sentosa Gateway, Singapore", coordinates: LatLng(1.2607914, 103.8237317),
  placeId: "EhpTZW50b3NhIEdhdGV3YXksIFNpbmdhcG9yZSIuKiwKFAoSCTMWLoRXGdoxEeRWEDVI6eBjEhQKEgl1k4uKIxHaMRHE9atSz2l4iA"),
];

/*List implementation
List<LocationList> locationList = List<LocationList>.empty(growable: true); */
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
