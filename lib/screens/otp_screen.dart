import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/screens/create_userprofile.dart';
import 'package:fluttergram/screens/registration_page.dart';
import 'package:google_fonts/google_fonts.dart';

String _otp;
String entered_otp;
String mobileNumber = "9652534488";
String p;
String otpUse;
double seconds;
String message_text = "An OTP is send to phone number";
IconData message_icon = Icons.done;
Color message_color = Colors.amberAccent;

class CheckOtp extends StatefulWidget {
  CheckOtp(
      {@required String otp,
      String phonenumber,
      String pa,
      @required String use}) {
    _otp = otp;
    mobileNumber = phonenumber;
    p = pa;
    otpUse = use;
  }

  @override
  _CheckOtpState createState() => _CheckOtpState();
}

class _CheckOtpState extends State<CheckOtp> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      upperBound: 120,
      vsync: this,
      duration: Duration(seconds: 120),
    );
    animationController.forward();
    animationController.addListener(() {
      setState(() {
        seconds = animationController.value;
        if (seconds.toInt() == 120) {
          // Navigator.pop(context);
        }
      });
    });
  }

  void throwerror(String text) {
    setState(() {
      message_color = Colors.cyanAccent;
      message_icon = Icons.error;
      message_text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
        decoration: instadeco,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  message_icon,
                  color: message_color,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  message_text,
                  style: GoogleFonts.poppins(
                    color: message_color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                decoration: entrydeco,
                width: 200,
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
                            hintText: "Enter OTP",
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
                          entered_otp = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "time left : ${120 - seconds.toInt()} secs",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (entered_otp == _otp) {
                  if (otpUse == "registration") {
                    print("Ok done Boss");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateUserProfile(
                                phone: mobileNumber, password: p)));
                  }
                  if (otpUse == "resetpass") {
                    print("ok resetting");
                  }
                } else {
                  print(_otp);
                  throwerror("Wrong otp entered");
                }
              },
              child: Container(
                width: 150,
                height: 49,
                //  color: Colors.lightBlue,
                decoration: mainbuttondeco,
                child: Center(
                  child: Text(
                    "Check OTP",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
