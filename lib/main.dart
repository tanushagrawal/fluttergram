import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/otp_service.dart';
import 'package:fluttergram/screens/create_userprofile.dart';
import 'package:fluttergram/screens/login_page.dart';
import 'package:fluttergram/screens/otp_screen.dart';
import 'package:fluttergram/screens/registration_page.dart';

import 'package:fluttergram/screens/chat_screen.dart';


import 'package:fluttergram/screens/homepage.dart';


import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(new MaterialApp(
//     debugShowCheckedModeBanner: false,
//     showSemanticsDebugger: false,
//     debugShowMaterialGrid: false,
//     home: ImageUploader(
//       username: "tanumanu",
//     )));
bool nav;
List<Widget> intialPage = [LoginPage()];
void main() {
  runApp(MyApp());
  // runApp(ImageFilterTest());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getValues(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // sharedPreferences.getString("phonenumber");
    print(sharedPreferences.getString("phonenumber"));
    print(sharedPreferences.getString("password"));
    if (sharedPreferences.getString("phonenumber") != null) {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomePage()));
      nav = true;
      intialPage.clear();
      intialPage.add(HomePage());
    }
  }

  @override
  void initState() {
//      Firestore.instance.collection("users") .where('username',isEqualTo: "giri").getDocuments().then((QuerySnapshot val) =>print(val.documents[0]["username"]));
    // getValues(context);
    // print("this is encoded" + hashedPassword("9652534488Om").toString());

    Firestore.instance
        .collection('app')
        .where("name", isEqualTo: "fast")
        .getDocuments()
        .then(
      (QuerySnapshot value) {
        print(value.documents[0]["key"]);
        api.clear();
        api.add(value.documents[0]["key"].toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getValues(context);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomePage()));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CheckOtp(otp: "1234", phonenumber: "9652534488", pa: "qwerty123"),
//      home: CreateUserProfile(phone: "798754",password: "879745dfsa",),
      // home: ResetPasswordScreen(phone: "9652534488"),
      initialRoute: '/',

      routes: {
        // '/': (context) => intialPage[0],
        '/':(context)=> HomePage(),
        'register': (context) => RegisterPage(),
        'chat': (context) => Chatscreen(),
        'homepage': (context) => HomePage(),
        'otp':(context) => CheckOtp(),
        'create-user-profile': (context) => CreateUserProfile(phone: null, password: null),
      },
    );
  }
}
