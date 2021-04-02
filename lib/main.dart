import 'package:flutter/material.dart';
import 'package:swtp_app/endpoints/LogInEndpoint.dart';
import 'package:swtp_app/models/Credentials.dart';
import 'package:swtp_app/widgets/login.dart';

import 'models/User.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  LogInEndpoint _endpoint = LogInEndpoint();

  void _incrementCounter() {
    setState(() {
      print("Test");

      Credentials credentials = Credentials("test", "test");
      _endpoint.signIn(credentials);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Login();
  }
}
