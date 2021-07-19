import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/pages/forgot_password.dart';
import 'package:mapception/pages/home.dart';
import 'package:mapception/services/auth.dart';
import 'package:mapception/services/colourPalette.dart';

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

  bool _obscureText = true;

  //toggles the password field to show or hide password
  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Image(image: AssetImage('assets/loginImage.png')),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome Back!",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please sign in to continue",
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      //Username container
                      Container(
                        child: TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(104, 90, 146, 0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            labelText: "Email",
                            labelStyle:
                                GoogleFonts.montserrat(color: Colors.white),
                            //textInputDecorations.copyWith(hintText: 'Email'),
                          ),
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      //Password container
                      Container(
                        child: TextFormField(
                          //controller: passwordController,
                          validator: (val) =>
                              val.length < 8 ? 'Password too short' : null,
                          obscureText: _obscureText,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: Colors.white,
                              onPressed: () {
                                _togglePassword();
                              },
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(104, 90, 146, 0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            labelText: "Password",
                            labelStyle:
                                GoogleFonts.montserrat(color: Colors.white),
                            //textInputDecorations.copyWith(hintText: 'Email'),
                          ),
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          //width: MediaQuery.of(context).size.width * 0.8,
                          //height: 40,
                          //color: Color.fromRGBO(148, 233, 174, 1),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                              context,
                                MaterialPageRoute(builder: (context) => ForgotPassword()),
                              );
                            },
                            child: RichText(
                                text: TextSpan(children: [
                                TextSpan(
                                  text: 'Forgot password?',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold, color: signInButtonColour)),
                            ])),
                      )),
                      SizedBox(height: 60.0),
                      Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          decoration: BoxDecoration(
                            color: signInButtonColour,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Invalid Credentials! ", 
                                        style: GoogleFonts.montserrat(color: Colors.red[400]),),
                                      duration: Duration(seconds: 4),

                                    ));
                                  });
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => Home()),
                                    ModalRoute.withName('/'));
                                }
                              }
                            },
                            //style: TextButton.styleFrom(primary: Colors.transparent),
                            child: Text("SIGN IN",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                          )),
                      Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 40,
                          //color: Color.fromRGBO(148, 233, 174, 1),
                          child: TextButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "No account? ",
                                  style: TextStyle(color: Colors.grey[400])),
                              TextSpan(
                                  text: ' Sign Up!',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ])),
                          )),
                    ],
                  ),

                  // ElevatedButton(
                  //   child: Text("Continue without account"),
                  //   onPressed: () async {
                  //     dynamic result = await _auth.signInAnon();
                  //     if (result == null) {
                  //       print("error signing in");
                  //     } else {
                  //       print("signed in");
                  //       print(result.uid);
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          )),
    );
  }
}
