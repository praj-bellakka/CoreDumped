import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/pages/profile.dart';
import 'package:mapception/pages/route_view.dart';
import 'package:mapception/services/auth.dart';
import 'package:mapception/services/colourPalette.dart';
import 'package:mapception/services/userData.dart';

import 'google_map_page.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  Query _ref;
  @override
  void initState() {
    super.initState();
    //amount = getUserAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "My Places",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  RawMaterialButton(
                      shape: CircleBorder(),
                      fillColor: Colors.pink[600],
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => Profile()));
                      },
                      enableFeedback: false,
                      constraints: BoxConstraints(minWidth: 70),
                      child: Icon(Icons.supervised_user_circle_outlined,
                          size: 30, color: Colors.white)),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Route Categories",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              CategoriesScrollBar(),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Upcoming Agenda",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                  ),
                ),
              ),
              CategoriesScrollBarBottom(),
              SizedBox(
                height: 100,
              ),
            ]),
            Positioned(
                right: 20,
                bottom: 0,
                child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      // var dataBaseUserData =
                      //     databaseReference.child("Users").child(userId);
                      // //readData();
                      // var result = await getUserData();
                      // print(result.length);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    })),
          ]),
        ),
      ),
    );
  }
}

class CategoriesScrollBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RouteView(tagName: 'All')));
              },
              child: ReusableCategoryWidget(
                imagePath: 'assets/all-route.jpeg',
                tagName: 'All',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RouteView(tagName: 'Work')));
              },
              child: ReusableCategoryWidget(
                  tagName: 'Work', imagePath: 'assets/work.jpg'),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RouteView(tagName: 'Delivery')));
              },
              child: ReusableCategoryWidget(
                  tagName: 'Delivery',
                  imagePath: 'assets/delivery.jpg'),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RouteView(tagName: 'Road Trip')));
              },
              child: ReusableCategoryWidget(
                  tagName: 'Road Trip',
                  imagePath: 'assets/road-trip1.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}


class CategoriesScrollBarBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RouteView(tagName: 'Sent Agenda')));
              },
              child: ReusableCategoryWidget(
                imagePath: 'assets/boss.jpg',
                tagName: 'Sent by boss',
              ),
            ),
          ],
        ),
    );
  }
}

