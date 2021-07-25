import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/pages/detailed_route_view.dart';
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
  Query _refSentAgenda; //this query is for data input through the web app
  bool emptyList;
  // List<String> dropDown = <String>["Name", "Duration", "Distance", "Date"];
  // String sortMethod = 'Name'; //default sorting method

  // int buildCompareName(DataSnapshot a, DataSnapshot b) {
  //   return a.value['name'].toString().compareTo(b.value['name'].toString());
  // }

  // int buildCompareDist(DataSnapshot a, DataSnapshot b) {
  //   return a.value['totalDistance'].compareTo(b.value['totalDistance']);
  // }

  @override
  void initState() {
    super.initState();
    /* Search database by tag name
      If Accessed throught the upcoming agenda tag, query sent data.
      If All route is specified, order by name, else query relevant tag name */

    widget.tagName == 'All'
        ? _ref = databaseReference.child('Users/$userId/').orderByChild('name')
        : widget.tagName == 'Sent Agenda'
            ? _refSentAgenda = databaseReference.child('sendData/$userId/')
            : _ref = databaseReference
                .child('Users/$userId/')
                .orderByChild('tag')
                .equalTo(widget.tagName);

    //check if no data exists
    checkEmptyList().then((value) => setState(() {
          emptyList = value;
        }));
  }

  /* Checks if database has entries for the query
    Returns true if data entries exist
  */

  Future<bool> checkEmptyList() async {
    print(widget.tagName);
    if (widget.tagName != 'Sent Agenda') {
      var data = await _ref.once();
      if (data.value != null) return true;
    } else {
      var data = await _refSentAgenda.once();
      if (data.value != null) return true;
    }
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
          Image(
              image: AssetImage('assets/flamenco-list-is-empty.png'),
              width: 400,
              height: 400),
          Text("No Routes Found",
              style: GoogleFonts.montserrat(
                  fontSize: 25.0,
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w700)),
          TextButton(
            // style: ButtonStyle(

            // )
            child: Text("Go to maps!",
                style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    color: signInButtonColour,
                    fontWeight: FontWeight.w700)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(),
                  ));
            },
          )
        ],
      )),
    );
  }

  Widget _buildRouteItem({Map route, String date}) {
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
                  title: widget.tagName != 'Sent Agenda' ? route['name'] : route['nameOfUser'],
                  fontsize: 20,
                ),
                //does not display if it is receiving location details
                if (widget.tagName != 'Sent Agenda')
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
            if (widget.tagName != 'Sent Agenda')
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
                    width: 15,
                  ),
                  Icon(
                    Icons.timer,
                    size: 25,
                  ),
                  Text(
                      route['totalDuration'] == null
                          ? "? min"
                          : " ${route['totalDuration'].toStringAsFixed(2)} min",
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 25,
                  ),
                  Text(" ${date}", style: TextStyle(fontSize: 15))
                ],
              ),
            if (widget.tagName == 'Sent Agenda')
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(width: 15),
                Icon(
                  Icons.location_on,
                  size: 25,
                ),
                Text("${route['numberOfLocations']} destinations",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ]),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // actions: [
          //   DropdownButton<String>(
          //     //dropdownColor: Colors.red,
          //     underline: Container(),
          //     items: dropDown.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(
          //           value,
          //         ),
          //       );
          //     }).toList(),
          //     onChanged: (String value) {
          //       setState(() {
          //         sortMethod =
          //             value; //change the sort method to the chosen value
          //       });
          //     },
          //     icon: Icon(Icons.filter_alt, color: Colors.white),
          //   )
          // ],
        ),
        backgroundColor: backgroundColorMain,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            ReusableTitleWidget(
              color: Colors.white,
              title: widget.tagName == "Sent Agenda"
                  ? "${widget.tagName}"
                  : "${widget.tagName} Routes",
              fontsize: 40,
            ),
            emptyList == false
                ? _buildEmptyList()
                : FirebaseAnimatedList(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    query:
                        widget.tagName != 'Sent Agenda' ? _ref : _refSentAgenda,
                    // sort: (a , b) {
                    //   if (sortMethod == 'Name') {
                    //    return a.value['name'].toString().compareTo(b.value['name'].toString());
                    //  } else {
                    //    return a.value['totalDistance']
                    //           .compareTo(b.value['totalDistance']);
                    //   }

                    // (a, b) {
                    //Sort by name
                    // switch (sortMethod) {
                    // case 'Name':
                    //   return buildCompareTo(a, b);
                    //   break;
                    // case 'Distance':
                    //   return a.value['totalDistance']
                    //       .compareTo(b.value['totalDistance']);
                    //   break;
                    // case 'Duration':
                    //   return a.value['totalDuration']
                    //       .compareTo(b.value['totalDuration']);
                    //   break;
                    // }
                    // return a.value['tag']
                    //     .toString()
                    //     .compareTo(b.value['tag'].toString());
                    // },
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      var route = snapshot.value;
                      // print(route);
                      // print(widget.tagName);
                      String itemKey = snapshot.key;
                      // final List list = route.map((o) => RouteStructure.fromJson(o)).toList();
                      //RouteStructure obj = RouteStructure.fromJson(route);
                      // for (var route in route['mapList']) {
                      //   LocationList obj = route.fromJson();
                      //   print(route);
                      // }
                      DateTime date;
                      var formattedDate;
                      if (route['date'] != null) {
                        date = new DateTime.fromMillisecondsSinceEpoch(
                            route['date']);
                        formattedDate = DateFormat('yMMMd').format(date);
                      } else
                        formattedDate = '∞';

                      return InkWell(
                          onTap: () {
                            //enter detailed view of route when contianer is pressed
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailedRouteView(
                                      routeList: route,
                                      routeName: widget.tagName != 'Sent Agenda' ? route['name'] : route['nameOfUser'],
                                      tagName: widget.tagName,
                                      itemKey: itemKey),
                                ));
                          },
                          child: _buildRouteItem(
                              route: route, date: formattedDate));
                    },
                  ),
          ]),
        ));
  }
}
