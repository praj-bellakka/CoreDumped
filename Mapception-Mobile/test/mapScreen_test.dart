import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapception/pages/google_map_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {

  testWidgets("UI Display Maps", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MapScreen()));
    expect(find.byType(GoogleMap), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(SlidingUpPanel), findsOneWidget);

    // await tester.;
    // expect(find.byType(Marker), findsWidgets);
  });
  // testWidgets("FAB", (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: MapScreen()));
  //   expect(find.byType(FloatingActionButton), findsOneWidget);
  // });
}

