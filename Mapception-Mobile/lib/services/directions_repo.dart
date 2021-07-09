import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapception/services/place_services.dart';
import 'package:http/http.dart' as http;

PolylinePoints polylinePoints = PolylinePoints();
Set<Polyline> polylines = {};
Map<String, Polyline> tempPolylines = {};
double totalDuration = 0;
double totalDistance = 0;

class DirectionModel {
  final String polyline;
  final String dist;
  final String journeyDuration;

  @override
  String toString() {
    return '{ ${this.polyline}, ${this.dist}, ${this.journeyDuration} }';
  }

  DirectionModel({this.polyline, this.dist, this.journeyDuration});

  factory DirectionModel.fromJson(Map<String, dynamic> json) {
    final data = json['routes'][0] as Map<String, dynamic>;
    return DirectionModel(
        polyline: data['overview_polyline']['points'],
        dist: data['legs'][0]['distance']['text'],
        journeyDuration: data['legs'][0]['duration']['text']);
  }
}

Future<DirectionModel> findIndividualDirections(
    LatLng source, LatLng dest, String placeId, String tempId) async {
  print("$source, $dest");
  var baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${dest.latitude},${dest.longitude}&key=$apiKey";
  final response = await http.get(Uri.parse(baseUrl));

  //print(response.body);
  if (response.statusCode == 200) {
    // print(tempId);
    var jsonResult = DirectionModel.fromJson(jsonDecode(response.body));
    print(jsonResult.polyline);
    Polyline polyline = Polyline(
        polylineId: PolylineId(tempId),
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
        color: Color.fromRGBO(0, 51, 102, 1), //darkblue color
        //Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        points: polylinePoints
            .decodePolyline(jsonResult.polyline)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList());
    tempPolylines[tempId] = polyline;
    return jsonResult;
  }
  print(response.body);
  return null;
}

//this function will run the 2 approx algorithm, which will return a list of index in the correct order
//Then, it will draw the polylines and update the main list
void runAlgoAndSetPolylines(List<int> sortedList,
    List<List<double>> durationMatrix, List<List<double>> distMatrix) async {
  print(tempPolylines);
  for (int i = 0; i < sortedList.length - 1; i++) {
    int from = sortedList[i];
    int to = sortedList[i + 1];
    print("from${from}to$to");
    totalDuration +=
        from < to ? durationMatrix[from][to] : durationMatrix[to][from];
    totalDistance += from < to
        ? num.parse((distMatrix[from][to]).toStringAsFixed(2)).toDouble()
        : num.parse((distMatrix[to][from]).toStringAsFixed(2)).toDouble();
    Polyline extractedPolyline =
        tempPolylines[from < to ? "from${from}to$to" : "from${to}to$from"];
    if (extractedPolyline != null) {
      print(extractedPolyline.points);
      print(extractedPolyline.mapsId);
      polylines.add(extractedPolyline);
      print('length of polylines is ${polylines.length}');
    }
  }
  //clear temp storages
  tempPolylines.clear();
}
