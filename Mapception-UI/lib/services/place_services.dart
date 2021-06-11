import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

/* Using Google Places API for autocomplete function. 
Extracted from: https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete 
*/

final String androidKey = 'AIzaSyAaa2p7_QrOhGFQS-DHndqEZZa5-BV7vRw';
final String iosKey = '';
//final apiKey = Platform.isAndroid ? androidKey : iosKey;
final apiKey = androidKey;

//To store the results
class Suggestion {
  final String placeId;
  final String description;
  final String placeIcon;
  final String shortName;
  Suggestion(this.placeId, this.description, this.placeIcon, this.shortName);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId, placeIcon: $placeIcon, shortName: $shortName)';
  }
}

class PlaceDetails {
  final coordinates;
  final zipCode;
  final name;
  final shortName;

  PlaceDetails({this.coordinates, this.zipCode, this.name, this.shortName});
  factory PlaceDetails.fromJson(Map<dynamic, dynamic> json) {
    return PlaceDetails(
      coordinates: json['geometry']['location'],
      name: json['formatted_address'],
      zipCode: json['zipCode'],
      shortName: json['name'],
    );
  }
}

class PlaceApiProvider {
  final client = Client();
  final sessionToken;

  PlaceApiProvider(this.sessionToken);

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    //api is now limited to Singapore places
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=en&components=country:sg&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));
    if (response.statusCode == 200) {
      //response is successful
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        //print(result['status']);
        return result['predictions']
            .map<Suggestion>(
                (p) => Suggestion(p['place_id'], p['description'], p['icon'], p['name']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<List> fetchAddress(LatLng pos) async {
    final request =
        'https://maps.googleapis.com/maps/api/geocode/json?&latlng=${pos.latitude},${pos.longitude}&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      // print(result['results'][0]);
      if (result['status'] == 'OK') {
        final jsonResult = result['results'];
        return jsonResult;
        //building the result from the returned details
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  //get details from google map api using the place id
  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,place_id,geometry&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      //print(result);
      if (result['status'] == 'OK') {
        final jsonResult = result['result'] as Map<String, dynamic>;
        return PlaceDetails.fromJson(jsonResult);
        //building the result from the returned details
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  /*Future<PlaceDetails> getAddressFromCoordinates(
      LatLng pos, String locale) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
  }*/
}
