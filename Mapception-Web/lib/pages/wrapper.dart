import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate.dart';
import 'home.dart';
import '../models/user_profile.dart';
import '../services/authService.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProfile? user = Provider.of<UserProfile>(context);

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
