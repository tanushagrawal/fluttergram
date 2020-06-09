import 'package:flutter/material.dart';
List color = <Color>[
  Colors.red,
  Colors.redAccent,
  Colors.green,
  Colors.greenAccent,
  Colors.pink,
  Colors.purpleAccent,
  Colors.teal,
  Colors.tealAccent,
  Colors.cyanAccent,
  Colors.pinkAccent,
  Colors.orange,
  Colors.purple,
  Colors.amber,
  Colors.cyan,
  Color(0xFF595AD2),
  Colors.orange,
];

double h;
bool cannot_see_password = true;
IconData visibility = Icons.visibility_off;

String app_name = "fluttergram";

var instadeco = BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topEnd,
              stops: [0.05,0.5,0.99],
              end: AlignmentDirectional.bottomCenter,
              colors: [
                // Colors.red,
                // Colors.purpleAccent,
                // Colors.red,
                 Color(0xFF6F48BD),
                 Color(0xFFCE3188),
                // Colors.redAccent[400],
                // Colors.deepOrangeAccent,
                // Colors.pink,
                // Colors.purpleAccent,
                Color(0xFFF47531),
                // Colors.deepOrangeAccent,
    
              ],
            ),
              );
var entrydeco = BoxDecoration(
  color: Colors.grey.withOpacity(0.275),
  border: Border(
    // bottom:
    // BorderSide(color: Colors.white, width: 1.5),
  ),
);
var mainbuttondeco = BoxDecoration(
  // gradient: LinearGradient(
  //     colors: [Colors.cyan, Color(0xFFE839F6)]),
  // color: Colors.grey.withOpacity(0.),
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(3)));

