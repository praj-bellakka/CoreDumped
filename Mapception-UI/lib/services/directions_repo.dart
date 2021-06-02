import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapception/services/place_services.dart';

PolylinePoints polylinePoints = PolylinePoints();

void setPolyLines(LatLng source, LatLng dest) async {
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    apiKey,
    PointLatLng(source.latitude, source.longitude),
    PointLatLng(dest.latitude, dest.longitude),
    travelMode: TravelMode.driving,
  );
  if (result.status == 'OK') {
    print(result.points);
  }
}
