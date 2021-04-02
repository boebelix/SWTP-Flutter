class RegisterCredentials {
  String _username;
  String _password;
  String _email;
  String _firstname;
  String _lastname;
  String _street;
  String _streetNr;
  String _zip;
  String _city;

  RegisterCredentials(
      this._username,
      this._password,
      this._email,
      this._firstname,
      this._lastname,
      this._street,
      this._streetNr,
      this._zip,
      this._city);

  set password(String value) {
    _password = value;
  }

  set username(String value) {
    _username = value;
  }

  Map<String, dynamic> toJson() => {
        "username": _username,
        "password": _password,
        "email": _email,
        "firstname": _firstname,
        "lastname": _lastname,
        "street": _street,
        "streetNr": _streetNr,
        "zip": _zip,
        "city": _city
      };
}
