import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Reusable widget for category cards in home page

class ReusableCategoryWidget extends StatelessWidget {
  final imagePath;
  final tagName;
  final numOfItems;
  const ReusableCategoryWidget({this.imagePath, this.tagName, this.numOfItems});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.39,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          //boxShadow: 
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("$tagName",
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)
              )
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("$numOfItems items",
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey)
              ),
            )

          ],
          
        ));
  }
}
