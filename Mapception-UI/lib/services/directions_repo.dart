import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapception/services/place_services.dart';
import 'package:http/http.dart' as http;

PolylinePoints polylinePoints = PolylinePoints();
Set<Polyline> polylines = {};

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

Future<DirectionModel> setPolyLines(LatLng source, LatLng dest ,String placeId) async {
  /*PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    apiKey,
    PointLatLng(source.latitude, source.longitude),
    PointLatLng(dest.latitude, dest.longitude),
    travelMode: TravelMode.driving,
  );
  if (result.status == 'OK') {
    print(result.points);
  }*/
  var baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${dest.latitude},${dest.longitude}&key=$apiKey";
  final response = await http.get(Uri.parse(baseUrl));

  //print(response.body);
  if (response.statusCode == 200) {
    var jsonResult = DirectionModel.fromJson(jsonDecode(response.body));
    Polyline polyline = Polyline(
        polylineId: PolylineId(placeId),
        color: Color.fromARGB(255, 40, 122, 198),
        points: polylinePoints
            .decodePolyline(jsonResult.polyline)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList());
    polylines.add(polyline);
    return jsonResult;
  }
  print(response.body);
}
