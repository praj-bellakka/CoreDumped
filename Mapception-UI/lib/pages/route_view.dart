import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/services/colourPalette.dart';
import 'package:mapception/services/userData.dart';

import 'google_map_page.dart';

/* Page that displays the route data dynamically */

class RouteView extends StatefulWidget {
  // final AuthService _auth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _RouteView createState() => _RouteView();
}

class _RouteView extends State<RouteView> {
  Query _ref;

  @override
  void initState() {
    super.initState();
    _ref = databaseReference.child('Users/$userId/').orderByChild('name');
  }

  Widget _buildRouteItem({Map route}) {
    return Container(
        height: 100,
        width: 100,
        color: Colors.white,
        child: Text(route['name']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: backgroundColorMain,
      body: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "All Routes",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 40,
            ),
          ),
        ),
        FirebaseAnimatedList(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            print(snapshot);
            Map route = snapshot.value;
            print(route);
            return _buildRouteItem(route: route);
          },
        ),
      ]),
    );
  }
}
