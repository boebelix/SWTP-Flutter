import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/services/user_service.dart';

class Register extends StatefulWidget {
  static const routeName = "/register";

  @override
  _RegisterStage createState() => _RegisterStage();
}

class _RegisterStage extends State<Register> {
  /*
   * TODO: Wird für die späteren Validatoren gebraucht
   * https://flutter.dev/docs/cookbook/forms/validation
   * */
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController streetNr = TextEditingController();
  final TextEditingController zip = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();

  @override
  void initState() {
    username.text = "username";
    password.text = "1234";
    repeatPassword.text = "12345";
    email.text = "abcd1234@stud.hs-kl.de";
    firstname.text = "firstname";
    lastname.text = "Lastname";
    street.text = "Street";
    streetNr.text = "42a";
    zip.text = "11111";
    city.text = "City";
    super.initState();
  }

  void _sendRegisterData() {
    try {
      UserService userService = UserService();
      if (_formKey.currentState.validate()) {
        userService.registerUser(
          credentials: RegisterCredentials(
            username.text,
            password.text,
            email.text,
            firstname.text,
            lastname.text,
            street.text,
            streetNr.text,
            zip.text,
            city.text,
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: _formElements(deviceSize),
        ),
      ),
    );
  }

  Form _formElements(Size deviceSize) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(5),
        children: [
          Text(
            'Persönliche Daten',
            style: TextStyle(fontSize: 18),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Vorname',
              icon: Icon(Icons.account_circle),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Bitte geben Sie einen Vornamen ein";
              }

              RegExp regexFirstname = RegExp(
                r"^[A-ZÄÖÜ][a-zäöü]+\b",
                multiLine: false,
              );

              if (!regexFirstname.hasMatch(value)) {
                return "Der Name muss mit einem Großbuchstaben beginnen gefolgt von Kleinbuchstaben";
              }

              return null;
            },
            controller: firstname,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nachname',
              icon: Icon(Icons.account_circle),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Bitte geben Sie einen Nachnamen ein";
              }

              RegExp regexLastname = RegExp(
                r"^[A-ZÄÖÜ][a-zäöü]+\b",
                multiLine: false,
              );

              if (!regexLastname.hasMatch(value)) {
                return "Der Name muss mit einem Großbuchstaben beginnen gefolgt von Kleinbuchstaben";
              }

              return null;
            },
            controller: lastname,
          ),
          Row(
            children: [
              Flexible(
                flex: 10,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Straße',
                    icon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte geben Sie Ihre Straße ein";
                    }

                    RegExp regexLastname = RegExp(
                      r"^[A-ZÄÖÜ][a-zäöü]+\b",
                      multiLine: false,
                    );

                    if (!regexLastname.hasMatch(value)) {
                      return "Der Name muss mit einem Großbuchstaben beginnen gefolgt von Kleinbuchstaben";
                    }

                    return null;
                  },
                  controller: street,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Flexible(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nr.',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte geben Sie Ihre Hausnummer ein";
                    }

                    RegExp regexStreetNr = RegExp(
                      r"^[1-9]([0-9]?)([a-zA-Z]?)$",
                      multiLine: false,
                    );

                    if (!regexStreetNr.hasMatch(value)) {
                      return "Die Hausnummer beginnt mit Zahlen und kann mit einem Buchstaben enden";
                    }

                    return null;
                  },
                  controller: streetNr,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 5,
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Postleitzahl',
                      icon: Icon(Icons.location_city)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte geben Sie Ihre Postleitzahl ein";
                    }

                    RegExp regexZipCode = RegExp(
                      r"^\d{5}$",
                      multiLine: false,
                    );

                    if (!regexZipCode.hasMatch(value)) {
                      return "Die Postleitzahl besteht aus 5 Zahlen";
                    }

                    return null;
                  },
                  controller: zip,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Flexible(
                flex: 7,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Stadt',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte geben Sie Ihre Stadt ein";
                    }

                    RegExp regexCity = RegExp(
                      r"^[A-ZÄÖÜ][a-zäöü-]+\b",
                      multiLine: false,
                    );

                    if (!regexCity.hasMatch(value)) {
                      return "Der Stadt muss mit einem Großbuchstaben beginnen gefolgt von Kleinbuchstaben";
                    }

                    return null;
                  },
                  controller: city,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 5.0),
            child: Text(
              'Login Daten',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nutzername',
              icon: Icon(Icons.account_circle),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Bitte geben wählen Sie einen Nutzernamen";
              }

              return null;
            },
            controller: username,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email Adresse',
              icon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Bitte geben Sie Ihre E-Mailadresse ein";
              }

              RegExp regexEmail = RegExp(
                r"^\w{4}\d{4,}@stud\.(hs-kl|fh-kl)\.de$",
                multiLine: false,
              );

              if (!regexEmail.hasMatch(value)) {
                return "Es handelt sich um keine gültige Hochschule E-Mailadresse";
              }

              return null;
            },
            controller: email,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Passwort',
              icon: Icon(Icons.vpn_key),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Sie müssen ein Passwort wählen";
              }

              int passwordLength = value.length;
              RegExp regexHasNumber = RegExp(
                r"\d",
                multiLine: false,
              );
              RegExp regexHasSpecialSign = RegExp(
                r"[!§$&?]",
                multiLine: false,
              );
              RegExp regexUpperAndLowerCase = RegExp(
                r"([A-Z])(?=.*[a-z])|([a-z])(?=.*[A-Z])",
                multiLine: false,
              );

              bool hasMinLen = passwordLength > 5;
              bool hasLenBigger7 = passwordLength > 7;
              bool hasNumber = regexHasNumber.hasMatch(value);
              bool hasSpecialSign = regexHasSpecialSign.hasMatch(value);
              bool hasUpperAndLowerCase =
                  regexUpperAndLowerCase.hasMatch(value);

              if (hasMinLen &&
                  hasUpperAndLowerCase &&
                  hasNumber &&
                  hasSpecialSign &&
                  hasLenBigger7) {
                // TODO Passwortstärke Visual darstellen siehe SWTP Projekt
                // sehr sicher

                return null;
              } else if (hasMinLen &&
                  hasUpperAndLowerCase &&
                  hasNumber &&
                  hasSpecialSign) {
                // TODO siehe oben
                // sicher

                return null;
              } else if (hasMinLen && hasUpperAndLowerCase) {
                // TODO siehe oben
                // mittel sicher

                return null;
              } else if (hasMinLen) {
                // TODO siehe oben
                // akzeptabel

                return null;
              } else {
                // nicht sicher

                return "Passwort nicht sicher";
              }
            },
            controller: password,
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Passwort wiederholen',
              icon: Icon(Icons.vpn_key),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Bitte wiederholen Sie die Passworteingabe";
              }
              if (value != password.text) {
                return "Die Eingabe stimmt nicht mit dem Passwort überein";
              }
              return null;
            },
            controller: repeatPassword,
            obscureText: true,
          ),
          _submitButton(deviceSize)
        ],
      ),
    );
  }

  SizedBox _submitButton(Size deviceSize) {
    return SizedBox(
      width: double.infinity,
      height: deviceSize.height * 0.1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.02, 0, 0),
        child: ElevatedButton(
            onPressed: _sendRegisterData,
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
    );
  }
}
