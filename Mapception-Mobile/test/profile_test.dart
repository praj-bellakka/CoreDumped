import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapception/pages/profile.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  testWidgets("Profile", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Profile()));
    expect(find.text('Profile'), findsOneWidget);
  });
}
