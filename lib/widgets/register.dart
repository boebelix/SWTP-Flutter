import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/services/user_service.dart';

class Register extends StatefulWidget {
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

  String _errorMsg;

  void _sendRegisterData() {
    try {
      UserService userService = UserService();
      if (password.text == repeatPassword.text) {
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
      } else {
        setState(() {
          _errorMsg = 'Passwörter stimmen nicht überein';
        });
      }
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
            controller: firstname,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nachname',
              icon: Icon(Icons.account_circle),
            ),
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
            controller: username,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email Adresse',
              icon: Icon(Icons.email),
            ),
            controller: email,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Passwort',
              icon: Icon(Icons.vpn_key),
            ),
            controller: password,
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Passwort wiederholen',
              icon: Icon(Icons.vpn_key),
            ),
            controller: repeatPassword,
            obscureText: true,
          ),
          _errorMsg == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMsg,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
          SizedBox(
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
          )
        ],
      ),
    );
  }
}
