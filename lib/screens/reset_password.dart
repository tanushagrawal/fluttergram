import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/services/update_feild.dart';
import 'package:google_fonts/google_fonts.dart';

bool cannot_see_password = true;
String password;
IconData visibility = Icons.visibility_off;
String re_password;
String num;
String error_text=" good ";
IconData error_icon = Icons.done;
Color error_color = Colors.amberAccent;
class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({@required String phone}) {
    num = phone;
  }
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  void throwerror(String text){
    setState(() {
      // error_color =Color(0xFFF47531);
      error_color =Colors.cyanAccent;

      error_icon = Icons.error;
      error_text = text;
    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: instadeco,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                      // Text(
                      //   "Password",
                      //   style: GoogleFonts.poppins(
                      //       color: Colors.black,
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w700),
                      // ),
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
              onTap: () async {
                if (password!=null && re_password !=null) {
                  if (password==re_password) {
                    final doc = await Firestore.instance
                        .collection("users")
                        .where("phonenumber", isEqualTo: num)
                        .getDocuments();
                    print(doc.documents[0].documentID);
                    var docid = await doc.documents[0].documentID;
                    updateField("users", docid, "password", password);
                  }
                  else{
                    throwerror("Passwords must match");
                  }
                }
                else{
                  throwerror("Fields can not be empty");
                }

              },
              child: Container(
                width: 300,
                height: 49,
                //  color: Colors.lightBlue,
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     colors: [Colors.cyan, Color(0xFFE839F6)]),
                    // color: Colors.grey.withOpacity(0.),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                child: Center(
                  child: Text(
                    "RESET PASSWORD",
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() {}
}
