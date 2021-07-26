import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/services/auth.dart';
import 'package:mapception/services/colourPalette.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  final _passwordText = TextEditingController();
  final _passwordConfirmText = TextEditingController();
  bool _obscurePWText = true;
  bool _obscureCPWText = true;

  //toggles the password field to show or hide password
  void _togglePassword(String field) {
    setState(() {
      field == 'PW'
          ? _obscurePWText = !_obscurePWText
          : _obscureCPWText = !_obscureCPWText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Register An Account!",
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
                    "Fill in the details below",
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(104, 90, 146, 0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Email",
                      labelStyle: GoogleFonts.montserrat(color: Colors.white),
                      //textInputDecorations.copyWith(hintText: 'Email'),
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: TextFormField(
                    controller: _passwordText,
                    validator: (val) => val.length < 8
                        ? 'Password too short'
                        : (val != _passwordText.text
                            ? 'Passowrds do not match'
                            : null),
                    obscureText: _obscurePWText,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        color: Colors.white,
                        onPressed: () {
                          _togglePassword('PW');
                        },
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(104, 90, 146, 0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Password",
                      labelStyle: GoogleFonts.montserrat(color: Colors.white),
                      //textInputDecorations.copyWith(hintText: 'Email'),
                    ),
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: TextFormField(
                    controller: _passwordConfirmText,
                    validator: (val) => val.length < 8
                        ? 'Password too short'
                        : (val != _passwordText.text
                            ? 'Passowrds do not match'
                            : null),
                    obscureText: _obscureCPWText,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        color: Colors.white,
                        onPressed: () {
                          _togglePassword('CPW');
                        },
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(104, 90, 146, 0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Confirm Password",
                      labelStyle: GoogleFonts.montserrat(color: Colors.white),
                    ),
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(148, 233, 174, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          // print(email);
                          // print(password);
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          //print());
                          if (result != null) {
                            setState(() {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  result == 'email-already-in-use' ? "Email is already in use! Log In!" : 
                                  result == 'invalid-email' ? "Please provide a valid email! " : "",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.red[400]),
                                ),
                                duration: Duration(seconds: 4),
                              ));
                            });
                          } 
                        }
                      },
                      child: Text("REGISTER ACCOUNT",
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                    )),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  error,
                ),
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
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.grey[400])),
                        TextSpan(
                            text: ' Log In!',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
