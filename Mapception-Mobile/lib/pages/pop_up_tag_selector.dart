import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/models/reusable_widgets.dart';
import 'package:mapception/services/colourPalette.dart';
import 'package:mapception/services/directions_repo.dart';
import 'package:mapception/services/location_list.dart';
import 'package:mapception/services/userData.dart';
import 'package:http/http.dart' as http;

/// {@template hero_dialog_route}
/// Custom [PageRoute] that creates an overlay dialog (popup effect).
///
/// Best used with a [Hero] animation.
/// {@endtemplate}
class PopUpTagSelector<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  PopUpTagSelector({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    print(context);
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

class AddTagPopupCard extends StatefulWidget {
  final List<List<double>> distMatrix;
  final List<List<double>> durationMatrix;
  AddTagPopupCard({
    Key key,
    @required this.distMatrix,
    @required this.durationMatrix,
  }) : super(key: key);

  @override
  State<AddTagPopupCard> createState() => _AddTagPopupCard();
}

class _AddTagPopupCard extends State<AddTagPopupCard> {
  static final List<String> items = <String>['Work', 'Delivery', 'Road Trip'];
  String value = items.first;

  final myTextController = TextEditingController();
  var client = http.Client();
  final FirebaseAuth auth = FirebaseAuth.instance;

  //date selected defaults to the current date
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: '_heroAddTag',
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: popUpCardColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Save Route",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TextField(
                      controller: myTextController,
                      decoration: InputDecoration(
                        hintText: 'Tag Name',
                        errorText: 'Enter a valid name',
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Tag: ',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                          value: value,
                          style: GoogleFonts.montserrat(color: Colors.white),
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: Text('Choose a tag!',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          onChanged: (value) => setState(() {
                            this.value = value;
                          }),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Task date: ',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                onSurface: Colors.black, primary: Colors.black),
                            child: ReusableSubtitleWidget(
                              text: "Select date",
                              fontsize: 20,
                              justification: TextAlign.justify,
                            ),
                            onPressed: () {
                              _selectDate(context);
                            },
                          )
                        ]),
                    SizedBox(height: 10),
                    FlatButton(
                      onPressed: () async {
                        //print(widget.distMatrix);
                        RouteStructure newDataInstance = RouteStructure(
                            tag: value,
                            name: myTextController.value.text,
                            mapList: mapList,
                            date: selectedDate.millisecondsSinceEpoch,
                            totalDuration: totalDuration,
                            totalDistance: totalDistance,
                            // durationMatrixOfLocations: widget.durationMatrix,
                            // distMatrixOfLocations: widget.distMatrix,
                            // listOfPolylines: polylines.toList()
                            );
                        //print(newDataInstance);
                        String encodedJson = jsonEncode(newDataInstance);
                        //print(encodedJson);
                        await client.post(
                            Uri.parse(
                                "https://mapception-c014b-default-rtdb.asia-southeast1.firebasedatabase.app/Users/${auth.currentUser.uid}.json"),
                            body: encodedJson);
                        Navigator.pop(context);
                      },
                      child: const Text('Save',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _enableDays(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 365))))) {
      return true;
    }
    return false;
  }

  //logic to handle datepicker
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
      //only allow day from up to 1 year from current date
      selectableDayPredicate: _enableDays,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    print(selectedDate);
     // final snackBar = SnackBar(
    //       content: Text('Date saved!',
    //           style: GoogleFonts.montserrat(color: Colors.white)));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    @required Rect begin,
    @required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin.left, end.left, elasticCurveValue),
      lerpDouble(begin.top, end.top, elasticCurveValue),
      lerpDouble(begin.right, end.right, elasticCurveValue),
      lerpDouble(begin.bottom, end.bottom, elasticCurveValue),
    );
  }
}
