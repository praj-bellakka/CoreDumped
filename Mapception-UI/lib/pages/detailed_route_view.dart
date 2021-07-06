import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/services/colourPalette.dart';
import 'package:mapception/services/userData.dart';

import 'google_map_page.dart';

/* Page that displays the route data dynamically 
*/

class DetailedRouteView extends StatefulWidget {
  //takes in data from firebase that was called in the previous page
  final routeList;
  final routeName;

  const DetailedRouteView({Key key, this.routeList, this.routeName})
      : super(key: key);

  @override
  _DetailedRouteView createState() => _DetailedRouteView();
}

class _DetailedRouteView extends State<DetailedRouteView> {
  @override
  Widget build(BuildContext context) {
    print(widget.routeList['mapList'][0]['address']);
    print(widget.routeList['mapList'].length);
    return Scaffold(
      backgroundColor: backgroundColorMain,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
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
              fontsize: 15, justification: TextAlign.justify,),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: widget.routeList['mapList'].length,
              itemBuilder: (context, index) {
                return ListCardWidget(
                    content: widget.routeList['mapList'][index], index: index);
              })
        ],
      ),
    );
  }
}

class ListCardWidget extends StatelessWidget {
  final content, index;

  const ListCardWidget({Key key, this.content, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(content);
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      height: 100,
      child: Row(
        children: [
          Icon(Icons.location_pin, size: 40, color: Colors.pink),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ReusableTitleWidget(title: content['address'].split(',')[0], color: Colors.black, fontsize: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ReusableTitleWidget(title: "Coordinates: ", color: Colors.grey[700], fontsize: 16),
                  ReusableSubtitleWidget(text: "${content['coordinates'][0].toStringAsFixed(4)} , ${content['coordinates'][1].toStringAsFixed(4)}", justification: TextAlign.left,)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
