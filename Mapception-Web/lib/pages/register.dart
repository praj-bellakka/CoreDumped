import 'package:flutter/material.dart';
import '../services/authService.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(200)),
          TextFormField(
            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            decoration: InputDecoration(hintText: "Email", labelText: "Email"),
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
          Padding(padding: EdgeInsets.all(200)),
          TextFormField(
            validator: (val) => val!.isEmpty ? 'Enter password' : null,
            obscureText: true,
            decoration:
                InputDecoration(hintText: "Password", labelText: "Password"),
            onChanged: (val) {
              setState(() {
                password = val;
              });
            },
          ),
          Padding(padding: EdgeInsets.all(200)),
          ElevatedButton(onPressed: null, child: Text("Create Account")),
          Padding(padding: EdgeInsets.all(200)),
          ElevatedButton(onPressed: null, child: Text("Back to login")),
        ],
      ),
    );
  }
}
