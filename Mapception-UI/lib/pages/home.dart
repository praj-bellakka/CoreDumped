import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/services/auth.dart';
import 'package:mapception/services/colourPalette.dart';

import 'google_map_page.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService(); //add this line
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(children: [
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
              SizedBox(height: 350,),
            ]),
            Positioned(
                right: 20,
                bottom: 0,
                child: FloatingActionButton(onPressed: () {
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
            ReusableCategoryWidget(
              tagName: 'All',
              numOfItems: 3,
            ),
            ReusableCategoryWidget(tagName: 'Daily Routine', numOfItems: 5),
          ],
        ),
      ),
    );
  }
}
