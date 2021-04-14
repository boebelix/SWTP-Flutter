class RegisterCredentials {
  final String _username;
  final String _password;
  final String _email;
  final String _firstname;
  final String _lastname;
  final String _street;
  final String _streetNr;
  final String _zip;
  final String _city;

  RegisterCredentials(
    this._username,
    this._password,
    this._email,
    this._firstname,
    this._lastname,
    this._street,
    this._streetNr,
    this._zip,
    this._city,
  );

  Map<String, dynamic> toJson() =>
      {
        "username": _username,
        "password": _password,
        "email": _email,
        "firstname": _firstname,
        "lastname": _lastname,
        "street": _street,
        "streetNr": _streetNr,
        "zip": _zip,
        "city": _city,
      };
}
