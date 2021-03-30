import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swtp_app/models/Credentials.dart';
import 'package:swtp_app/services/user_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  String _errorMsg;

  void _sendLoginData() {
    try {
      UserService userService = UserService();
      print(username.text);
      print(password.text);
      userService.logIn(Credentials(username.text, password.text));
    } on HttpException catch (error) {
      setState(() {
        _errorMsg = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        margin: EdgeInsets.all(deviceSize.width * 0.1),
        child: Column(

          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nutzername',
              ),
              controller: username,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Passwort',
              ),
              controller: password,
            ),
            _errorMsg == null
                ? Container()
                : Text(
                    _errorMsg,
                    style: TextStyle(color: Colors.redAccent),
                  ),
            SizedBox(
              width: double.infinity,
              height: deviceSize.height*0.1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, deviceSize.height*0.02, 0, 0),
                child: ElevatedButton(
                    onPressed: _sendLoginData,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        (Colors.black12),
                      ),
                    ),
                    child: Text(
                      'Einloggen',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    )),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: deviceSize.height*0.1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, deviceSize.height*0.02, 0, 0),
                child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        (Colors.black12),
                      ),
                    ),
                    child: Text(
                      'Registrieren',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
