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

Future<DirectionModel> setPolyLines(
    LatLng source, LatLng dest, String placeId) async {
  var baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${dest.latitude},${dest.longitude}&key=$apiKey";
  final response = await http.get(Uri.parse(baseUrl));

  //print(response.body);
  if (response.statusCode == 200) {
    var jsonResult = DirectionModel.fromJson(jsonDecode(response.body));
    Polyline polyline = Polyline(
        polylineId: PolylineId(placeId),
        color:
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        points: polylinePoints
            .decodePolyline(jsonResult.polyline)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList());
    polylines.add(polyline);
    return jsonResult;
  }
  print(response.body);
}
