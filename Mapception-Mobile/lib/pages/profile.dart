import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/services/colourPalette.dart';
import 'package:mapception/services/userData.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          ReusableTitleWidget(title: "Profile", color: Colors.white, fontsize: 40,),
          SizedBox(height:10),

          ReusableTitleWidget(title: "User ID", color: Colors.grey[100], fontsize: 24,),
          Row( 
            children: [
              ReusableSubtitleWidget(text: userId, fontsize: 16, justification: TextAlign.start),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.white,),
                onPressed: () {
                  //copy the uid to clipboard when the copy button is pressed
                  Clipboard.setData(new ClipboardData(text: userId)).then((_) {
                    ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Copied to your clipboard!')));
                  });
                },

              )
            ]
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),          
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.info_outline_rounded, size: 20, color: Colors.white),
                  ),
                  TextSpan(
                    text: " Do not share your user id to strangers. New routes can be added remotely through the user id",
                    style: GoogleFonts.montserrat(color: Colors.grey[400], fontSize: 16),
                  ),
                ],
              ),
            )
          )
        ],
      ),
      
    );
  }
}
