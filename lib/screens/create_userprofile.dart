import 'dart:math';
import 'dart:io';

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
import 'package:fluttergram/services/crud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// import 'pack';

String re_password;
String error_text = " good ";
IconData error_icon = Icons.done;
Color error_color = Colors.green;
String gender = "select";
String username;
String phonenumber;
String password;
String description;
int birtdate = DateTime.now().day;
int birtmonth = DateTime.now().month;
int birthyear = DateTime.now().year;
int age = 0;
ScrollController newcon = ScrollController();

class CreateUserProfile extends StatefulWidget {
  String num;
  String pass;

  CreateUserProfile({@required String phone, @required String password}) {
    num = phone;
    pass = password;
  }

  // This widget is the root of your application.
  //
  @override
  _CreateUserProfileState createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  File _imagefile;

  Future<bool> deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Center(
                child: new Text("Select from where you want to select image",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ))),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    getCameraImg();
                    Navigator.pop(context);
                  },
                  child: Text("Camera",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ))),
              new SizedBox(
                width: 40,
              ),
              new FlatButton(
                  onPressed: () {
                    getGalleryImg();
                    Navigator.pop(context);
                  },
                  child: Text("Gallery",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ))),
              new SizedBox(
                width: 40,
              ),
            ],
          );
        });
  }

  Future getCameraImg() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imagefile = img;
    });
  }

  Future getGalleryImg() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagefile = img;
    });
  }

  void throwerror(String text) {
    setState(() {
      error_color = Colors.red;
      error_icon = Icons.error;
      error_text = text;
    });
  }

  void create() async {
    newcon.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);

    if (username.length > 6 && age > 13 && gender != "select") {
      final bar = _snackAction();
      _key.currentState.showSnackBar(bar);
      print(username);
      print(widget.num);
      print(description);
      print(birtdate);
      print(birtmonth);
      print(birthyear);
      print(age);
      print(gender);
      print(widget.pass);
      final username_check = await Firestore.instance
          .collection("users")
          .where("username", isEqualTo: username)
          .getDocuments();
      print(username_check.documents.length);
      if (username_check.documents.length == 0) {
        print("ok");
        addData(_imagefile, username, widget.num, widget.pass, description,
            birtdate, birtmonth, birthyear, age, gender);
            
      } else {
        print("no");
        throwerror("An Account already exists \nwith this username");
      }
    } else if (username.length < 6) {
      throwerror("username is too short");
    } else if (age < 13) {
      throwerror("your are too young for $app_name");
    } else if (gender == "select") {
      throwerror("select gender");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
            controller: newcon,
            child: Center(
              child: Column(
                // mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Text("User Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                      )),
                  SizedBox(height: 10),
                  Row(
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
                  SizedBox(height: 10),
                  _imagefile == null
                      ? CircleAvatar(
                          child: Icon(
                            Icons.camera,
                            size: 50,
                          ),
                          radius: 50,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(_imagefile),
                          radius: 50,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      deleteDialog(context);
                    },
                    child: Container(
                      width: 200,
                      height: 35,
                      //  color: Colors.lightBlue,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.cyan, Color(0xFFE839F6)]),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Center(
                        child: Text(
                          "Select Profile Image",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1.5),
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
                            Text("User Name",
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
                                  hintText: "Type your Desired Username",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
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
                                        color: Colors.grey,
                                        size: 25,
                                      )),
                                  prefixIconConstraints: BoxConstraints()),
                              onChanged: (x) {
                                username = x;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1.5),
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
                            Text("Description",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                  hintText: "Some thing About You",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none,
                                  // labelText: "Email",
                                  // labelStyle: TextStyle(color:Colors.black,fontSize: 20),
                                  prefixIcon: Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                      child: Icon(
                                        Icons.description,
                                        color: Colors.grey,
                                        size: 25,
                                      )),
                                  prefixIconConstraints: BoxConstraints()),
                              onChanged: (x) {
                                description = x;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Gender  -  ",
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        hint: Text(
                          "Select Your Gender",
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: "male",
                            child: Center(
                              child: Text(
                                "Male",
                                style: GoogleFonts.poppins(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "female",
                            child: Center(
                              child: Text(
                                "Female",
                                style: GoogleFonts.poppins(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "no",
                            child: Center(
                              child: Text(
                                "Gather prefer not to say",
                                style: GoogleFonts.poppins(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    gender,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Birth Date   -  ",
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 17,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                initialDatePickerMode: DatePickerMode.year,
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                setState(() {
                                  birthyear = int.parse(
                                      value.toString().substring(0, 4));
                                  birtmonth = int.parse(
                                      value.toString().substring(5, 7));
                                  birtdate = int.parse(
                                      value.toString().substring(8, 10));
                                  age = DateTime.now().year - birthyear;
                                });
//                            print("$birtmonth, $birtdate, $birthyear");
                              });
                            },
                            child: Container(
                              width: 200,
                              height: 40,
                              //  color: Colors.lightBlue,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFE839F6),
                                    Colors.cyan,
                                  ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: Center(
                                child: Text(
                                  "PICK DATE",
                                  style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "$birtdate/$birtmonth/$birthyear",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: create,
                    child: Container(
                      width: 350,
                      height: 49,
                      //  color: Colors.lightBlue,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.cyan, Color(0xFFE839F6)]),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Center(
                        child: Text(
                          "CREATE MY PROFILE",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _snackAction() => SnackBar(
      content: Text(
        "Test the action in the SnackBar.",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      action: SnackBarAction(
        label: "I Know!",
        textColor: Colors.white,
        disabledTextColor: Colors.black,
        onPressed: () {
          print("I know you are testing the action in the SnackBar!");
        },
      ),
      backgroundColor: Colors.cyanAccent,
    );
