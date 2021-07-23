import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mapception/services/place_services.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('Fetch features return list of features', () async {
    //final wakeApi = WakeProvider();
    //final client = Client();
    final sessionToken = Uuid().v4();
    
    final apiClient = PlaceApiProvider(sessionToken);
    MockClient integrationTestMockClient = MockClient((request) async {


    });
    //MockClient(apiClient.fetchSuggestions('hi')))

    // wakeApi.client = MockClient((request) async {
    //   final jsonMap = {'features' : [{'type' : 'Feature', 'properties' : {'mag': 1.2}, 'geometry' : {}, 'id' : ''}]};
    //   return Response(json.encode(jsonMap), 200);
    // });

    // final _data = await wakeApi.fetchFeatures();
    // ItemModel itemModel = _data[0];
    // expect(itemModel.type, 'Feature');
  // });
    // await tester.;
    // expect(find.byType(Marker), findsWidgets);
  });
  // testWidgets("FAB", (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: MapScreen()));
  //   expect(find.byType(FloatingActionButton), findsOneWidget);
  // });
}
