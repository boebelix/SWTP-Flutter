class Credentials {
  String _username;
  String _password;

  Credentials(this._username, this._password);

  set password(String value) {
    _password = value;
  }

  set username(String value) {
    _username = value;
  }

  Map<String, dynamic> toJson() =>
      {"username": _username, "password": _password};
}
