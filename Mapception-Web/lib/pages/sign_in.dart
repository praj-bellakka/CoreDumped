import 'package:flutter/material.dart';
import '../services/authService.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(300)),
          TextFormField(
            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            decoration: InputDecoration(hintText: "Email", labelText: "Email"),
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
          Padding(padding: EdgeInsets.all(100)),
          TextFormField(
            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            decoration: InputDecoration(hintText: "Email", labelText: "Email"),
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
          Padding(padding: EdgeInsets.all(100)),
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
          Padding(padding: EdgeInsets.all(100)),
          ElevatedButton(onPressed: null, child: Text("Sign In")),
          Padding(padding: EdgeInsets.all(100)),
          ElevatedButton(onPressed: null, child: Text("Create Account")),
        ],
      ),
    );
  }
}
