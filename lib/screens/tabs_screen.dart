import 'package:flutter/material.dart';
import 'package:swtp_app/screens/groups_screen.dart';
import 'package:swtp_app/screens/login_screen.dart';
import 'package:swtp_app/screens/map_screen.dart';
import 'package:swtp_app/screens/profile_screen.dart';
import 'package:swtp_app/services/user_service.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/tabScreen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': MapScreen(),
        'title': 'Karte',
      },
      {
        'page': GroupsScreen(),
        'title': 'Gruppen',
      },
      {
        'page': ProfileScreen(),
        'title': 'Profil',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                UserService().logOut();
                Navigator.popAndPushNamed(context, LoginScreen.routeName);
              }),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.map),
            label: 'Karte',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.group),
            label: 'Gruppe',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
