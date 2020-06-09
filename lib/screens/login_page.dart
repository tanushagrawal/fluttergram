import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/screens/homepage.dart';
import 'package:fluttergram/screens/otp_screen.dart';
import 'package:fluttergram/otp_service.dart';
import 'package:fluttergram/services/hash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'pack';
IconData visibility = Icons.visibility_off;
bool cannot_see_password = true;
String phonenumber;
String _password;
bool wrongPassword = false;
String error_text = " good ";
IconData error_icon = Icons.done;
Color error_color = Colors.amberAccent;
String resetphone;
String _encoded;
ScrollController _controller = ScrollController();
bool remember_password = true;
var rng = new Random();
var _code = rng.nextInt(9000) + 1000;
void onForgetPassword() {
  // write code for "forget passoword"
}

class LoginPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(
        decoration: instadeco,
        child: Center(child: Body()),
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  void initState() {
    // super.initState();
    print('hellooooooo');
  }

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    void throwerror(String text, {IconData iconData = Icons.error}) {
      setState(() {
        // error_color =Color(0xFFF47531);
        error_color = Colors.cyanAccent;

        error_icon = iconData;
        error_text = text;
      });
    }

    void setValues() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("phonenumber", phonenumber);
      sharedPreferences.setString("password", _password);
    }

    final _auth = FirebaseAuth.instance;

    void login() async {
      _controller.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      if (_password != null && phonenumber != null) {
        setState(() {
          error_text = "connecting";
        });
        Response response = await get(
            "https://api.hashify.net/hash/md5/hex?value=${_password}");
        print(response.body);
        _encoded = jsonDecode(response.body)["Digest"].toString();
        // write code for login button
        final data = await Firestore.instance
            .collection("users")
            .where("phonenumber", isEqualTo: phonenumber)
            .getDocuments();
        if (data.documents.length == 1) {
          String _pas = data.documents[0]["password"];
          print(_pas);
          if (_encoded == _pas) {
            if (remember_password) {
              setValues();
            }
            Navigator.pushNamed(context, 'homepage');
            throwerror("Welcome", iconData: Icons.done);
            print("welcome");
          } else {
            throwerror("Wrong password");
          }
        } else {
          throwerror("This mobile number\n is not registered \nwith $app_name");
        }
      }

      // print(data.documents[0].data);
      else {
        throwerror("Fields can not be empty");
      }
    }

    void goToRegister() {
      // write code for "Not An User? Register"
      Navigator.pushNamed(context, 'register');
    }

    foretPass(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Center(
                  child: new Text("reset your password",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ))),
              actions: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1.5),
                      ),
                    ),
                    width: 350,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.redAccent,
                        primaryColorDark: Colors.red,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("phone number",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                          TextField(
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                                hintText: "Type your phonenumber",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                // labelText: "Email",
                                // labelStyle: TextStyle(color:Colors.black,fontSize: 20),
                                prefixIcon: Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                    child: Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.white,
                                      size: 25,
                                    )),
                                prefixIconConstraints: BoxConstraints()),
                            onChanged: (x) {
                              resetphone = x;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      if (resetphone != null && resetphone.length == 10) {
                        final doc = await Firestore.instance
                            .collection("users")
                            .where("phonenumber", isEqualTo: resetphone)
                            .getDocuments();

                        if (doc.documents.length == 1) {
                          print(_code.toString());
                          //                      sendOtp(_code.toString(), resetphone);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckOtp(
                                      otp: _code.toString(),
                                      use: "resetpass")));
                        } else {
                          Navigator.pop(context);
                          throwerror(
                              "This mobile number\n is not registered \nwith $app_name");
                        }
                      } else {
                        Navigator.pop(context);
                        throwerror("Enter correct phone number");
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 35,
                      //  color: Colors.lightBlue,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.cyan, Color(0xFFE839F6)]),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Center(
                        child: Text(
                          "SEND OTP",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    }

    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        // mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Image.asset("assests/logo.png"),
          SizedBox(height: 50),
          Text("Login",
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
                  maxLines: 3,
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
                        _password = value;
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
            height: 3,
          ),
          Container(
            width: 350,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  foretPass(context);
                },
                child: Text("forget password",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          SizedBox(height: 50),
          GestureDetector(
            onTap: login,
            child: Container(
              width: 350,
              height: 49,
              //  color: Colors.lightBlue,
              decoration: mainbuttondeco,
              child: Center(
                child: Text(
                  "LOGIN",
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
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  value: remember_password,
                  onChanged: (bool value) {
                    setState(() {
                      remember_password = !remember_password;
                    });
                  }),
              Text(
                "Remember Password",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white),
              )
            ],
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
            child: SignInButton(
              Buttons.Facebook,
              onPressed: () async {
                Response response = await get(
                    "https://api.hashify.net/hash/md5/hex?value=9652534488");
                print(response.body);
                print(jsonDecode(response.body)["Digest"]);
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: goToRegister,
            child: Text(
              "Not An User? Register",
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
