import 'package:flutter/material.dart';
import 'package:mapception/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService(); //add this line
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: ElevatedButton(
          //add this widget
          child: Text("Sign Out"),
          onPressed: () async {
            await _auth.signOut();
          },
        ),
      ),
    );
  }
}
