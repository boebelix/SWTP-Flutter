import 'package:flutter/cupertino.dart';

class Credentials{

  String _username;
  String _password;

  Credentials.name(this._username, this._password);

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  Map<String, dynamic> toJson() => {
    "username":   username,
    "password":   password,
  };

}