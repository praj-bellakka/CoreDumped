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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    imagePath
                  ),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
          ),

          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left:15),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tagName,
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$numOfItems items",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400]),
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}

class ReusableTitleWidget extends StatelessWidget {
  final title;
  final color;
  final double fontsize;
  ReusableTitleWidget({this.title, this.color, this.fontsize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        '$title',
        style: GoogleFonts.montserrat(
            fontSize: fontsize, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

class ReusableSubtitleWidget extends StatelessWidget {
  final text;
  final double fontsize;
  final justification;
  ReusableSubtitleWidget({this.text, this.fontsize, this.justification});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        '$text',
        style: GoogleFonts.montserrat(
            fontSize: fontsize,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500]),
        textAlign: justification,
      ),
    );
  }
}

