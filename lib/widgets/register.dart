import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/services/user_service.dart';
import 'package:swtp_app/generated/l10n.dart';

class Register extends StatefulWidget {
  @override
  _RegisterStage createState() => _RegisterStage();
}

class _RegisterStage extends State<Register> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController streetNr = TextEditingController();
  final TextEditingController zip = TextEditingController();
  final TextEditingController city = TextEditingController();

  String _errorMsg;

  void _sendRegisterData() {
    try {
      UserService userService = UserService();
      userService.registerUser(RegisterCredentials(
          username.text,
          password.text,
          email.text,
          firstname.text,
          lastname.text,
          street.text,
          streetNr.text,
          zip.text,
          city.text));
      Navigator.pop(context);
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
        title: Text(S.of(context).register),
      ),
      body: Container(
        margin: EdgeInsets.all(deviceSize.width * 0.1),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: S.of(context).email,
                ),
                controller: email,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: S.of(context).first_name,
                ),
                controller: firstname,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: S.of(context).last_name,
                ),
                controller: lastname,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: S.of(context).street,
                ),
                controller: street,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: S.of(context).house_number,
                ),
                controller: streetNr,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: S.of(context).postcode,
                ),
                controller: zip,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: S.of(context).town,
                ),
                controller: city,
              ),
              _errorMsg == null
                  ? Container()
                  : Text(
                      _errorMsg,
                      style: TextStyle(color: Colors.redAccent),
                    ),
              SizedBox(
                width: double.infinity,
                height: deviceSize.height * 0.1,
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, deviceSize.height * 0.02, 0, 0),
                  child: ElevatedButton(
                      onPressed: _sendRegisterData,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
