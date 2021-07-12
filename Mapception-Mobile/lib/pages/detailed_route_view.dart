import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/pages/google_map_page.dart';
import 'package:mapception/services/colourPalette.dart';
import 'package:mapception/services/userData.dart';

/* Page that displays the route data dynamically 
*/

class DetailedRouteView extends StatefulWidget {
  //takes in data from firebase that was called in the previous page
  final routeList; //takes in all the details from firebase
  final routeName;
  final itemKey;
  const DetailedRouteView(
      {Key key, this.routeList, this.routeName, this.itemKey})
      : super(key: key);

  @override
  _DetailedRouteView createState() => _DetailedRouteView();
}

class _DetailedRouteView extends State<DetailedRouteView> {
  //formatted date
  DateTime date;
  var formattedDate;

  @override
  void initState() {
    super.initState();
    if (widget.routeList['date'] != null) {
      date = new DateTime.fromMillisecondsSinceEpoch(widget.routeList['date']);
      formattedDate = DateFormat('EEE M/d/y').format(date);
    } else
      formattedDate = 'No deadline';
  }

  @override
  Widget build(BuildContext context) {
    final newlist = Map<String, dynamic>.from(widget.routeList);
    RouteStructure newlist2 = RouteStructure.fromJson(
        newlist); //extracts data into the desired structure
    //print(newlist2.mapList);
    return Scaffold(
        backgroundColor: backgroundColorMain,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(top: 5),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                //delete saved route when pressed
                dataBaseReferenceData.child('${widget.itemKey}').remove();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ReusableTitleWidget(
                title: widget.routeName,
                fontsize: 35,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              ReusableSubtitleWidget(
                text:
                    "The details of this saved route is presented below! You can choose to reuse this route by clicking on the button below",
                fontsize: 15,
                justification: TextAlign.justify,
              ),
              SizedBox(height: 10),
              DetailsCardWidget(
                totalDist: widget.routeList['totalDistance'],
                totalDuration: widget.routeList['totalDuration'],
                formattedDate: formattedDate,
              ),
              Expanded(
                  flex: 0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemCount: widget.routeList['mapList'].length,
                      itemBuilder: (context, index) {
                        return ListCardWidget(
                            content: widget.routeList['mapList'][index],
                            index: index);
                      })),
              InkWell(
                onTap: () {
                  // var distMatrixOfLocations =
                  //     widget.routeList['distMatrixOfLocations'];
                  // var durationMatrixOfLocations =
                  //     widget.routeList['durationMatrixOfLocations'];
                  var listOfPolylines = widget.routeList['listOfPolylines'];
                  var mapList = widget.routeList['mapList'];
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          dbTotalDistance: widget.routeList['totalDistance'],
                          dbTotalDuration: widget.routeList['totalDuration'],
                          dbMarkers: listOfPolylines,
                          dbRouteList: newlist2.mapList,
                        ),
                      ),
                      (Route<dynamic> route) => false);

                  print(mapList);
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green[200]),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Use Route",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class ListCardWidget extends StatelessWidget {
  final content, index;

  const ListCardWidget({Key key, this.content, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(content);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      height: 85,
      child: Row(
        children: [
          RawMaterialButton(
              shape: CircleBorder(),
              fillColor: Colors.white,
              padding: EdgeInsets.all(10),
              onPressed: () {},
              enableFeedback: false,
              constraints: BoxConstraints(minWidth: 70),
              child: Icon(Icons.location_pin, size: 30, color: Colors.black)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ReusableTitleWidget(
                title: content['address'].split(',')[0],
                color: Colors.black,
                fontsize: 20,
              ),
              Row(
                children: [
                  ReusableTitleWidget(
                      title: "Coordinates:",
                      color: Colors.grey[700],
                      fontsize: 16),
                  ReusableSubtitleWidget(
                    text:
                        "${content['coordinates'][0].toStringAsFixed(4)} , ${content['coordinates'][1].toStringAsFixed(4)}",
                    justification: TextAlign.left,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class DetailsCardWidget extends StatelessWidget {
  final totalDist;
  final totalDuration;
  final tagName;
  final formattedDate;

  const DetailsCardWidget(
      {Key key,
      this.totalDist,
      this.totalDuration,
      this.tagName,
      this.formattedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.orange[200]),
      child: Column(
        children: [
          Row(
            children: [
              RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  onPressed: () {},
                  constraints: BoxConstraints(maxWidth: 100, minWidth: 70),
                  enableFeedback: false,
                  child: Icon(Icons.date_range, size: 30, color: Colors.black)),
              ReusableTitleWidget(
                title: "Task date:",
                fontsize: 20,
                color: Colors.black,
              ),
              ReusableTitleWidget(
                title: "$formattedDate",
                fontsize: 18,
                color: Colors.grey[800],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(maxWidth: 100, minWidth: 70),
                  onPressed: () {},
                  enableFeedback: false,
                  child: Icon(Icons.directions_walk,
                      size: 30, color: Colors.black)),
              ReusableTitleWidget(
                title: "Distance: ",
                fontsize: 20,
                color: Colors.black,
              ),
              ReusableTitleWidget(
                title: "$totalDist km",
                fontsize: 18,
                color: Colors.grey[800],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(maxWidth: 100, minWidth: 70),
                  onPressed: () {},
                  child: Icon(Icons.timer, size: 30, color: Colors.black)),
              ReusableTitleWidget(
                title: "Duration: ",
                fontsize: 20,
                color: Colors.black,
              ),
              ReusableTitleWidget(
                title: "$totalDuration min",
                fontsize: 18,
                color: Colors.grey[800],
              )
            ],
          )
        ],
      ),
    );
  }
}