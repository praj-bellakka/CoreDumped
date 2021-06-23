import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteStructure {
  final tag;
  final name;
  final mapList; //list of LocationList details
  final totalDuration;
  final totalDistance;
  final List<List<double>>
      durationMatrixOfLocations; //2d array which stores upper triangular matrix of locations for durations between each location
  final List<List<double>>
      distMatrixOfLocations; //2d array which stores upper triangular matrix of locations for distances between each location
  final Set<Polyline> listOfPolylines;

  RouteStructure(
      {this.tag, 
      this.name, this.mapList,
      this.totalDuration,
      this.totalDistance,
      this.durationMatrixOfLocations,
      this.distMatrixOfLocations,
      this.listOfPolylines}); //Set that holds polyline data
}

