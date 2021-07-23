import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapception/pages/home.dart';

void main() {
  testWidgets("Home screen", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));
    expect(find.text('My Places'), findsOneWidget);
    expect(find.text('Upcoming Agenda'), findsOneWidget);
    expect(find.text('Route Categories'), findsOneWidget);
  });

  testWidgets("Categories", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));
    expect(find.byType(CategoriesScrollBar), findsWidgets);
  });
  testWidgets("FAB", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

