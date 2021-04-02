class Credentials {
  final String _username;
  final String _password;

  Credentials(this._username, this._password);

  Map<String, dynamic> toJson() =>
      {"username": _username, "password": _password};
}
