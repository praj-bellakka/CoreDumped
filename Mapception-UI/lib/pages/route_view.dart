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

/* Page that displays the route data dynamically 
RouteView takes in a tag string so that it can dynamically show the relevant list
*/

class RouteView extends StatefulWidget {
  final tagName;
  // final AuthService _auth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RouteView({Key key, this.tagName}) : super(key: key);

  @override
  _RouteView createState() => _RouteView();
}

class _RouteView extends State<RouteView> {
  Query _ref;
  bool emptyList;
  @override
  void initState() {
    super.initState();
    /* Search database by tag name
      If All route is specified, order by name, else query relevant tag name */
    widget.tagName == 'All'
        ? _ref = databaseReference.child('Users/$userId/').orderByChild('name')
        : _ref = databaseReference
            .child('Users/$userId/')
            .orderByChild('tag')
            .equalTo(widget.tagName);
    checkEmptyList().then((value) => setState(() {
          emptyList = value;
        }));
  }

  /* Checks if database has entries for the query
    Returns true if data entries exist
  */

  Future<bool> checkEmptyList() async {
    var data = await _ref.once();
    if (data.value != null) return true;
    return false;
  }
  Widget _buildEmptyList() {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.7,
      //width: MediaQuery.of(context).size.width * 1,
      child: Center(
        //widthFactor: 10.0,
        //heightFactor: 10,
        child: Column(
          children: [
            Image(image: AssetImage('assets/flamenco-list-is-empty.png'), width: 400, height: 400),
            Text("No Routes Found", style: GoogleFonts.montserrat(fontSize: 25.0, color: Colors.grey[200], fontWeight: FontWeight.w700)),
            TextButton(
              // style: ButtonStyle(

              // )
              child: Text("Go to maps!", 
                style: GoogleFonts.montserrat(fontSize: 20.0, color: signInButtonColour, fontWeight: FontWeight.w700)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> MapScreen(),
                ));
              }, 
            )

          ],
        )
      ),
    );
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
                SizedBox(width: 15),
                Icon(
                  Icons.location_on,
                  size: 25,
                ),
                Text(
                    route['totalDistance'] == null
                        ? "? km"
                        : " ${route['totalDistance'].toStringAsFixed(2)} km",
                    style: TextStyle(fontSize: 15)),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.timer,
                  size: 25,
                ),
                Text(
                    route['totalDuration'] == null
                        ? "? min"
                        : " ${route['totalDuration'].toStringAsFixed(2)} min",
                    style: TextStyle(fontSize: 15))
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
          title: "${widget.tagName} Routes",
          fontsize: 40,
        ),
        emptyList == false
            ? _buildEmptyList()
            : FirebaseAnimatedList(
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
