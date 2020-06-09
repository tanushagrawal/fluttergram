import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/screens/otp_screen.dart';
import 'package:fluttergram/otp_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

// import 'pack';
IconData visibility = Icons.visibility_off;
bool cannot_see_password = true;
String phonenumber;
String password;
String re_password;
String error_text = " good ";
IconData error_icon = Icons.done;
Color error_color = Colors.green;
String encoded_pass;
ScrollController newcon = ScrollController();
var rng = new Random();
var code = rng.nextInt(9000) + 1000;
void onForgetPassword() {
  // write code for "forget passoword"
}

class RegisterPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: instadeco,
        child: Center(child: Body()),
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void throwerror(String text) {
    setState(() {
      error_color = Colors.cyanAccent;

      error_icon = Icons.error;
      error_text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    void register() async {
      newcon.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      // write code for login button
      Response response =
          await get("https://api.hashify.net/hash/md5/hex?value=${password}");
      print(response.body);
      encoded_pass = jsonDecode(response.body)["Digest"].toString();
      final p = await Firestore.instance
          .collection("users")
          .where("phonenumber", isEqualTo: phonenumber)
          .getDocuments();

      if (p.documents.length == 0) {
        if (phonenumber == null || password == null || re_password == null) {
          throwerror("Fields can not be empty");
        } else if (phonenumber.length != 10) {
          throwerror("Wrong phone number");
        } else if (password != re_password) {
          throwerror("Password are not matching");
        } else if (password.length < 6) {
          throwerror("Password is too short");
        } else if (phonenumber != null &&
            password != null &&
            re_password != null &&
            password == re_password &&
            phonenumber.length == 10 &&
            password.length > 6) {
          // String otpStatus =  await sendOtp(code.toString(), phonenumber);
          // print(otpStatus);
          print(code);
          String otpStatus = "true";
          if (otpStatus == "true") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckOtp(
                          otp: code.toString(),
                          phonenumber: phonenumber.toString(),
                          pa: encoded_pass,
                          use: "registration",
                        )));
          } else {
            throwerror("try after some time");
          }
        }
      } else {
        throwerror("An account already exits \nwith this number ");
      }
    }

    void goToLogin() {
      // write code for "Not An User? Register"
      Navigator.popAndPushNamed(context, '/');
    }

    return SingleChildScrollView(
      controller: newcon,
      child: Column(
        // mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          Text("Register",
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              )),
          SizedBox(height: 10),
          Hero(
            tag: "common",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  error_icon,
                  color: error_color,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  error_text,
                  style: GoogleFonts.poppins(
                    color: error_color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              decoration: entrydeco,
              width: 350,
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.redAccent,
                  primaryColorDark: Colors.red,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                          hintText: "Type Your Phone Number",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          // labelText: "Email",
                          // labelStyle: TextStyle(color:Colors.black,fontSize: 20),
                          prefixIcon: Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 25,
                              )),
                          prefixIconConstraints: BoxConstraints()),
                      onChanged: (value) {
                        phonenumber = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              decoration: entrydeco,
              width: 350,
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.redAccent,
                  primaryColorDark: Colors.red,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      obscureText: cannot_see_password,
                      decoration: InputDecoration(
                          hintText: "Type Your Password",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          // labelText: "Email",
                          // labelStyle: TextStyle(color:Colors.black,fontSize: 20),
                          prefixIcon: Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 25,
                              )),
                          suffixIcon: IconButton(
                              icon: Icon(
                                visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  cannot_see_password = !cannot_see_password;
                                  visibility == Icons.visibility
                                      ? visibility = Icons.visibility_off
                                      : visibility = Icons.visibility;
                                });
                              }),
                          prefixIconConstraints: BoxConstraints()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              decoration: entrydeco,
              width: 350,
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.redAccent,
                  primaryColorDark: Colors.red,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        re_password = value;
                      },
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      obscureText: cannot_see_password,
                      decoration: InputDecoration(
                          hintText: "Type Your Password Again",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          // labelText: "Email",
                          // labelStyle: TextStyle(color:Colors.black,fontSize: 20),
                          prefixIcon: Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 25,
                              )),
                          prefixIconConstraints: BoxConstraints()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              register();
              print("yes");
            },
            child: Container(
              width: 350,
              height: 49,
              //  color: Colors.lightBlue,
              decoration: mainbuttondeco,
              child: Center(
                child: Text(
                  "REGISTER",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Hero(
            tag: "c1",
            child: Text(
              "Or Sign Up using",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Hero(
            tag: "social",

            // Icon(Icons)

            child: SignInButton(
              Buttons.Facebook,
              // mini: true,
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: goToLogin,
            child: Text(
              "Already An User?Sign In ",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
