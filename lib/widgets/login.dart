import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swtp_app/models/Credentials.dart';
import 'package:swtp_app/services/user_service.dart';
import 'package:swtp_app/generated/l10n.dart';

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
        title: Text( S.of(context).login),
      ),
      body: Container(
        margin: EdgeInsets.all(deviceSize.width * 0.1),
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: (){setState(() {
                      S.load(Locale('en'));
                    });},
                    child: Text(S.of(context).english)),
                ElevatedButton(
                    onPressed: (){setState(() {
                      S.load(Locale('de'));
                    });},
                    child: Text(S.of(context).german)),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: S.of(context).user_name,
              ),
              controller: username,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: S.of(context).password,
              ),
              controller: password,
              obscureText: true,
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
                      S.of(context).login,
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
                     S.of(context).register,
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
