import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

/* Using Google Places API for autocomplete function. 
Extracted from: https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete 
*/

//To store the results
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
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
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=en&components=country:ch&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));
    if (response.statusCode == 200) {
      //response is successful
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        //debugPrint("reached here");
        print(result);
        print(result['status']);
        print(result['predictions']);
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
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
}
