import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapception/place_services.dart';





// class Directions {
//   final List<PointLatLng> polylinePoints;
//   final String totalDist;
//   final String totalTime;

//   Directions({this.polylinePoints, this.totalDist, this.totalTime});

//   factory Directions.fromMap(Map<String, dynamic> map) {
//     //check if route is available
//     if ((map['routes'] as List).isEmpty) return null;

//     final data = Map<String, dynamic>.from(map['routes'][0]);
//     String distance = '';
//     String duration = '';
//     if ((data['legs'] as List).isNotEmpty) {
//       final leg = data['legs'][0];
//       distance = leg['distance']['text'];
//       duration = leg['duration']['text'];
//     }

//     return Directions(
//       polylinePoints: PolylinePoints()
//           .decodePolyline(data['overview_polyline']['points']),
//       totalDist: distance,
//       totalTime: duration);
//   }
// }

// class DirectionsRepo {
//   final Dio _dio;
//   static const String _baseUrl =
//       'https://maps.googleapis.com/maps/api/directions/json?';

//   DirectionsRepo({Dio dio}) : _dio = dio ?? Dio();

//   Future<Directions> getDirections({LatLng origin, LatLng destination}) async {
//     final response = await _dio.get(_baseUrl, queryParameters: {
//       'origin': '${origin.latitude},${origin.longitude}',
//       'destination': '${destination.latitude},${destination.longitude}',
//       'key': apiKey,
//     });

//     if (response.statusCode == 200) {
//       return Directions.fromMap(response.data);
//     }
//   }
// }
