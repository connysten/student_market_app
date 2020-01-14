import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_market_app/auth_service.dart';

import './pages/extended_pages/user_chat.dart';

import './pages/login.dart';
import './pages/search.dart';
import './pages/sell.dart';
import './pages/profile.dart';
import './global.dart' as global;

void main() {
  runApp(MaterialApp(
    initialRoute: "/login",
    routes: {
      "/login": (context) => Login(),
      "/home": (context) => Home(),
    },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPage = 0;

  List<Widget> _pageOptions() => [
        SearchPage(
          key: PageStorageKey('Search'),
        ),
        Sell(
          key: PageStorageKey('Sell'),
        ),
        Profile(),
      ];

  @override
  Widget build(BuildContext context) {
    final pageOptions = _pageOptions();
    return Scaffold(
      body: IndexedStack(
        index: _selectedPage,
        children: pageOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(size: 30),
        selectedFontSize: 14,
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.home,
              ),
              title: Text(global.currentLanguage == global.Language.eng ?"Discover"
              :"Utforska")),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.plus),
            title: Text(global.currentLanguage == global.Language.eng ? "Sell" : "Sälj"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userAlt),
            title: Text(global.currentLanguage == global.Language.eng ? "Profile" : "Profil"),
          ),
        ],
      ),
    );
  }
}
