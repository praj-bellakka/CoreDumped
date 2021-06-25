import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'example.g.dart';

//@JsonSerializable()
class RouteStructure {
  final tag;
  final name;
  final mapList; //list of LocationList details
  final double totalDuration;
  final double totalDistance;
  final List<List<double>>
      durationMatrixOfLocations; //2d array which stores upper triangular matrix of locations for durations between each location
  final List<List<double>>
      distMatrixOfLocations; //2d array which stores upper triangular matrix of locations for distances between each location
  final List<Polyline> listOfPolylines; //converted from set to List so that JSON encode works

  RouteStructure(
      {this.tag,
      this.name,
      this.mapList,
      this.totalDuration,
      this.totalDistance,
      this.durationMatrixOfLocations,
      this.distMatrixOfLocations,
      this.listOfPolylines}); //Set that holds polyline data

  RouteStructure.fromJson(Map<String, dynamic> json) :
    tag = json['tag'],
    name = json['name'],
    mapList = json['mapList'],
    totalDuration = json['totalDuration'],
    totalDistance = json['totalDistance'],
    durationMatrixOfLocations = json['durationMatrixOfLocations'],
    distMatrixOfLocations = json['distMatrixOfLocations'],
    listOfPolylines = json['listOfPolylines'];

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'name': name,
        'mapList': mapList,
        'totalDuration': totalDuration,
        'totalDistance': totalDistance,
        'durationMatrixOfLocations': durationMatrixOfLocations,
        'distMatrixOfLocations': distMatrixOfLocations,
        'listOfPolylines': listOfPolylines,
  };
  //Map<String, dynamic> toJson() => _$PersonToJson(this);
}
