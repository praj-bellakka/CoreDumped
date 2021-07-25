import 'package:flutter/material.dart';
import 'package:mapception/models/user_profile.dart';
import 'package:mapception/pages/google_map_page.dart';
import 'package:mapception/pages/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapception/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//temp MyApp for testing
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserProfile>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

//original MyApp
/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapception',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}
*/
