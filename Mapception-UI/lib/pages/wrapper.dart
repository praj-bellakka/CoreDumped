import 'package:flutter/material.dart';
import 'package:mapception/models/user_profile.dart';
import 'package:mapception/pages/authenticate.dart';
import 'package:mapception/pages/home.dart';
import 'package:mapception/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProfile>(context);

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
