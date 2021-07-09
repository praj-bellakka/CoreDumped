import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: const <Widget>[
          Text("home page"),
          Padding(padding: EdgeInsets.all(50)),
          ElevatedButton(onPressed: null, child: Text("sign out"))
        ],
      ),
    );
  }
}
