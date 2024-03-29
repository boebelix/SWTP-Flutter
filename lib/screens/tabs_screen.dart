import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/screens/groups_screen.dart';
import 'package:swtp_app/screens/login_screen.dart';
import 'package:swtp_app/screens/map_screen.dart';
import 'package:swtp_app/screens/profile_screen.dart';
import 'package:swtp_app/services/auth_service.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/tabScreen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  AuthService _authService = AuthService();

  @override
  void initState() {
    _pages = [
      {
        'page': MapScreen(),
        'title_de': 'Karte',
        'title_en': 'Map',
      },
      {
        'page': GroupsScreen(),
        'title_de': 'Gruppen',
        'title_en': 'Groups',
      },
      {
        'page': ProfileScreen(),
        'title_de': _authService.user == null ? '' : '${_authService.user.firstName} ${_authService.user.lastName}',
        'title_en': _authService.user == null ? '' : '${_authService.user.firstName} ${_authService.user.lastName}',
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
      automaticallyImplyLeading: false,
        title: Text(_pages[_selectedPageIndex]['title_' + Intl.defaultLocale]),
        actions: [
          _pressedLogoutButton(context),
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
            label: Language.of(context).map,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.group),
            label: Language.of(context).groups,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_circle),
            label: Language.of(context).profile,
          ),
        ],
      ),
    );
  }

  IconButton _pressedLogoutButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          setState(() {
            AuthService().logOut(context);
            Provider.of<AuthEndpointProvider>(context, listen: false).resetState();
            Provider.of<PoiServiceProvider>(context, listen: false).resetState();
            Provider.of<UserServiceProvider>(context, listen: false).resetState();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                ModalRoute.withName(LoginScreen.routeName));
          });
        });
  }
}
