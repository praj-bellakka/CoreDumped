import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapception/pages/google_map_page.dart';
import 'package:mapception/services/location_list.dart';
import 'package:mapception/services/place_services.dart';

// class Search_Places extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("hi"),

//       )  ,
//     );
//   }
// }

//number of indexes clicked
int clickedSearchItems = 0;

class DataSearch extends SearchDelegate<Suggestion> {
  final sessionToken;
  PlaceApiProvider apiClient;
  DataSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // action for the search bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = ''; //make the textfield empty when clear button is pressed
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null); //close current instance
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on selection
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // items to display when something is searched
    return FutureBuilder(
      future: query == "" ? null : apiClient.fetchSuggestions(query),
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Enter your destination!'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    // we will display the data returned from our future here
                    leading: Icon(Icons.location_city),
                    title: TextButton(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (snapshot.data[index] as Suggestion).description,
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      onPressed: () {
                        close(context, snapshot.data[index]);
                      },
                    ),
                    //trailing: tapped  ? Icon(Icons.add_box_outlined) : Icon(Icons.access_alarms),
                    trailing: IconButton(
                        //icon: tapped ? Icon(Icons.add_box_outlined) : Icon(Icons.access_alarms),
                        icon: Icon(Icons.add_box_outlined),
                        onPressed: () async {
                          //get the coordinates from the location selected
                          final placeDetails = await PlaceApiProvider(
                                  sessionToken)
                              .getPlaceDetails(snapshot.data[index].placeId);
                          print(snapshot.data[index]);
                          addToList(
                              snapshot.data[index].placeId,
                              snapshot.data[index].description,
                              snapshot.data[index].description,
                              LatLng(placeDetails.coordinates['lat'],
                                  placeDetails.coordinates['lng']));

                          printList();
                          clickedSearchItems += 1;
                        }),
                    onTap: () {
                      //tapped = true;
                    },
                  ),
                  itemCount: snapshot.data.length,
                )
              : Container(child: Text('Loading...')),
    );
  }
}
