import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';

String currentUser;

class Chatscreen extends StatefulWidget {
  @override
  _ChatscreenState createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Future<void> getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      try {
        loggedInUser = user;
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: Container()),
          // Expanded(child: TextField()),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: TextField(
              maxLines: 10,
              minLines: 1,
              textInputAction: TextInputAction.send,
              autofocus: true,
              // autocorrect: true,
              style: TextStyle(fontSize: 20, wordSpacing: 1),
              decoration: InputDecoration(
                labelText: "Chat Here",
                labelStyle:
                    TextStyle(fontSize: 25, color: color[color.length - 1]),
                hintMaxLines: 10,
                filled: true,
                suffixIcon: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: color[color.length - 1],
                        size: 35,
                      ),
                    )),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                      // style: BorderStyle.solid,
                      width: 20,
                      color: color[color.length - 1],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
