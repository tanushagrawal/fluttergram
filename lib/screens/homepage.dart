import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabs = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Welcome",
              style: GoogleFonts.poppins(fontSize: 30),
            ),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search",
              style: GoogleFonts.poppins(fontSize: 30),
            ),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Add",
              style: GoogleFonts.poppins(fontSize: 30),
            ),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Recent Activities",
              style: GoogleFonts.poppins(fontSize: 30),
            ),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Profile",
              style: GoogleFonts.poppins(fontSize: 30),
            ),
          )
        ],
      ),
    ];
    return PageView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        
        Scaffold(
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.home,
                  size: 30,
                ),
                title: Text(
                  "",
                  style: TextStyle(color: Colors.black, fontSize: 5),
                ),
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.search,
                  size: 30,
                ),
                title: Text(
                  "",
                  style: TextStyle(color: Colors.black, fontSize: 5),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: 40,
                ),
                title: Text(
                  "",
                  style: TextStyle(color: Colors.black, fontSize: 5),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.heart,
                  size: 30,
                ),
                title: Text(
                  "",
                  style: TextStyle(color: Colors.black, fontSize: 5),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                title: Text(
                  "",
                  style: TextStyle(color: Colors.black, fontSize: 5),
                ),
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
       Scaffold(
         body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Chat",
              style: GoogleFonts.poppins(fontSize: 30),
            ),
          )
        ],
      ),
       ), 
      ],
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            "Welcome",
            style: GoogleFonts.poppins(fontSize: 30),
          ),
        )
      ],
    );
  }
}
