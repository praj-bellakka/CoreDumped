import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//part 'example.g.dart';

//@JsonSerializable()
class RouteStructure {
  final tag;
  final name;
  final mapList; //list of LocationList details
  final date;
  final double totalDuration;
  final double totalDistance;
  // final List<List<double>>
  //     durationMatrixOfLocations; //2d array which stores upper triangular matrix of locations for durations between each location
  // final List<List<double>>
  //     distMatrixOfLocations; //2d array which stores upper triangular matrix of locations for distances between each location
  // final List<Polyline>
  //     listOfPolylines; //converted from set to List so that JSON encode works

  RouteStructure({
    this.tag,
    this.name,
    this.mapList,
    this.date,
    this.totalDuration,
    this.totalDistance,
  }); //Set that holds polyline data

  RouteStructure.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'],
        mapList = json['mapList'],
        date = json['date'],
        totalDuration = json['totalDuration'],
        totalDistance = json['totalDistance'].toDouble();

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'name': name,
        'mapList': mapList,
        'date': date,
        'totalDuration': totalDuration,
        'totalDistance': totalDistance,
      };
  //Map<String, dynamic> toJson() => _$PersonToJson(this);
}

/* This data structure is used to extract location data when uploaded from the web app */
class RouteStructureWeb {
  final tag;
  final name;
  final mapList; //list of LocationList details
  // final date;

  RouteStructureWeb({
    this.tag,
    this.name,
    this.mapList,
    // this.date,
  });

  RouteStructureWeb.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        name = json['name'],
        mapList = json['mapList'];
  // date = json['date'],

  // Map<String, dynamic> toJson() => {
  //       'tag': tag,
  //       'name': name,
  //       'mapList': mapList,
  //       'date' : date,
  //     };
  //Map<String, dynamic> toJson() => _$PersonToJson(this);
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final userId = _auth.currentUser.uid;
final databaseReference = FirebaseDatabase(
        databaseURL:
            'https://mapception-c014b-default-rtdb.asia-southeast1.firebasedatabase.app')
    .reference();

List<dynamic> list = [];
final dataBaseReferenceData = databaseReference.child('Users/$userId/');

Future<dynamic> getUserData() async {
  return await dataBaseReferenceData.once().then((result) {
    final value = result.value;
    print(value);
    print(result.key);
    return value;
  });
}

void readData() async {
  databaseReference
      .child('Users/$userId/')
      // .orderByChild('tag')
      // .equalTo('School')
      .once()
      .then((DataSnapshot snapshot) {
    print(snapshot.value);
    list.add(snapshot.value);
    print(snapshot.key);
    // print(snapshot.value);
    //print(name);
    //print('Data : ${snapshot.value}');
  });
}
