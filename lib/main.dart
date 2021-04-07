import 'package:flutter/material.dart';
import 'package:swtp_app/screens/login_screen.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/widgets/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWTP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
      ),
      routes: {
        '/': (ctx) => LoginScreen(),
        TabScreen.routeName: (ctx) => TabScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        Register.routeName: (ctx) => Register(),
      },
    );
  }
}
