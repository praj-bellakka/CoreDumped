import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapception/services/auth.dart';
import 'package:mapception/services/colourPalette.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter the email address to which we will send authentication details to",
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                //Username container
                Container(
                  padding: EdgeInsets.only(top: 30),
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
                SizedBox(height: 15),
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
                        var result = await _auth.resetPasswordWithEmail(email);
                        setState(() {
                          //Checks for error message. If error, displays error message with red snackbar, else a confirmation with green snackbar
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                            content: Text(result == 'invalid-email' ? "Email address is badly formatted" : 
                                          result == 'user-not-found' ? "There is no user associated with this email" : "Password has been reset!", 
                              style: GoogleFonts.montserrat(color: result == null ? Colors.green[400] : Colors.red[400])),
                            duration: Duration(seconds: 4),

                          ));
                        });
                        
                      }
                    },
                    //style: TextButton.styleFrom(primary: Colors.transparent),
                    child: Text("Reset Password",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18)),
                  )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
