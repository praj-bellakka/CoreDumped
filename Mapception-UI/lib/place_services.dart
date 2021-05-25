import 'dart:convert';
import 'package:http/http.dart';
import 'package:location/location.dart';

/* Using Google Places API for autocomplete function. 
Extracted from: https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete 
*/

//To store the results
class Suggestion {
  final String placeId;
  final String description;
  final String placeIcon;

  Suggestion(this.placeId, this.description, this.placeIcon);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId, placeIcon: $placeIcon)';
  }
}

class PlaceDetails {
  final coordinates;
  final zipCode;
  final name;

  PlaceDetails({this.coordinates, this.zipCode, this.name});
  factory PlaceDetails.fromJson(Map<dynamic, dynamic> json) {
    return PlaceDetails(
      coordinates: json['geometry']['location'],
      name: json['formatted_address'],
      zipCode: json['zipCode'],
    );
  }
}

class PlaceApiProvider {
  final client = Client();
  final sessionToken;

  PlaceApiProvider(this.sessionToken);

  static final String androidKey = 'AIzaSyAaa2p7_QrOhGFQS-DHndqEZZa5-BV7vRw';
  static final String iosKey = '';
  //final apiKey = Platform.isAndroid ? androidKey : iosKey;
  final apiKey = androidKey;

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
        //debugPrint("reached here");
        //print(result);
        //print(result['status']);
        //print(result['predictions']);
        return result['predictions']
            //TODO: beautify the list, add a add button to include for algorithm
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description'], p['icon']))
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

  //get details from google map api using the place id
  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken';
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
}
