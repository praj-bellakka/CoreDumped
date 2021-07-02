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
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableTitleWidget(
                  color: Colors.black,
                  title: route['name'],
                  fontsize: 20,
                ),
                Text(
                  route['tag'],
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                    color: Colors.grey[500],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  size: 30,
                ),
                Text(route['totalDistance'] == null ? "? km" : "${route['totalDistance'].toStringAsFixed(2)} km", style: TextStyle(fontSize: 15)),
                SizedBox(width: 20,),
                Icon(
                  Icons.timer,
                  size: 30,
                ),
                Text(route['totalDuration'] == null ? "? min" : "${route['totalDuration'].toStringAsFixed(2)} min", style: TextStyle(fontSize: 15))

              
              ],
            )
          ],
        ));
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
        ReusableTitleWidget(
          color: Colors.white,
          title: "All Routes",
          fontsize: 40,
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
