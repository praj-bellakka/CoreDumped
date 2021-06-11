import 'package:flutter/material.dart';
import 'package:mapception/services/auth.dart';
import 'package:mapception/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

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
      backgroundColor: Colors.brown,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  decoration: textInputDecorations.copyWith(hintText: 'Email'),
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (val) =>
                      val.length < 8 ? 'Password too short' : null,
                  obscureText: true,
                  decoration:
                      textInputDecorations.copyWith(hintText: 'Password'),
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);

                      if (result == null) {
                        setState(() => error = 'invalid credentials');
                      }
                    }
                  },
                  child: Text('Sign In'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.toggleView();
                  },
                  child: Text('Sign up now!'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  error,
                ),
                ElevatedButton(
                  child: Text("Continue without account"),
                  onPressed: () async {
                    dynamic result = await _auth.signInAnon();
                    if (result == null) {
                      print("error signing in");
                    } else {
                      print("signed in");
                      print(result.uid);
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}
