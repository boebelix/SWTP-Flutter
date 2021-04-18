import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/screens/invite_user_screen.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/widgets/auth_endpoint_visualisation.dart';
import 'package:swtp_app/widgets/poi_endpoint_visualisation.dart';
import 'package:swtp_app/widgets/user_endpoint_visualisation.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class Register extends StatefulWidget {
  static const routeName = "/register";

  @override
  _RegisterStage createState() => _RegisterStage();
}

class _RegisterStage extends State<Register> {
  /*
   * Hinweis zu Validatoren
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

  Future<void> _sendRegisterData() async {
    try {
      AuthService authService = AuthService();
      if (_formKey.currentState.validate()) {
        bool succesfullSignUp = await authService.registerUser(
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

        if (succesfullSignUp) {
          await authService.logIn(
            context: context,
            username: username.text,
            password: password.text,
          );

          if (authService.isSignedIn()) {
            // Lösche den Stack der bei der Navigation hier enstand
            Navigator.pop(context);

            // Verbietet, das zurück navigieren im TabScreen
            Navigator.popAndPushNamed(context, TabScreen.routeName);
          }
        }
      }
    } on Failure catch (error) {
      print(error.toString());

      PopUpWarningDialog(
        context: context,
        failure: error,
      );
    }
  }

  @override
  void initState() {
    username.text = "Bob";
    password.text = "\$Test1234";
    repeatPassword.text = "\$Test1234";
    email.text = "abef1234@stud.hs-kl.de";
    firstname.text = "Bob";
    lastname.text = "Der";
    street.text = "Baumeister";
    streetNr.text = "1";
    zip.text = "11111";
    city.text = "Berlin";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.of(context).register),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Stack(children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: _formElements(deviceSize),
          ),
          AuthEndpointVisualisation(),
          UserScreenVisualisation(),
          PoiEndpointVisualisation(
            destinationRouteBySuccess: TabScreen.routeName,
          ),

        ]),
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
            Language.of(context).personal_data,
            style: TextStyle(fontSize: 18),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).firstname,
              icon: Icon(Icons.account_circle),
            ),
            validator: _validatorFirstname,
            controller: firstname,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).lastname,
              icon: Icon(Icons.account_circle),
            ),
            validator: _validatorLastname,
            controller: lastname,
          ),
          Row(
            children: [
              Flexible(
                flex: 10,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: Language.of(context).street,
                    icon: Icon(Icons.location_city),
                  ),
                  validator: _validatorStreet,
                  controller: street,
                ),
              ),
              Spacer(),
              Flexible(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: Language.of(context).house_number,
                  ),
                  validator: _validatorHouseNumber,
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
                  decoration:
                      InputDecoration(labelText: Language.of(context).postcode, icon: Icon(Icons.location_city)),
                  validator: _validatorPostcode,
                  controller: zip,
                ),
              ),
              Spacer(),
              Flexible(
                flex: 7,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: Language.of(context).city,
                  ),
                  validator: _validatorCity,
                  controller: city,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 5.0),
            child: Text(
              Language.of(context).login_data,
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).user_name,
              icon: Icon(Icons.account_circle),
            ),
            validator: _validatorUsername,
            controller: username,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).email,
              icon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validatorEmail,
            controller: email,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).password,
              icon: Icon(Icons.vpn_key),
            ),
            validator: _validatorPassword,
            controller: password,
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).password_repeat,
              icon: Icon(Icons.vpn_key),
            ),
            validator: _validatorRepeatPassword,
            controller: repeatPassword,
            obscureText: true,
          ),
          _submitButton(deviceSize)
        ],
      ),
    );
  }

  String _validatorFirstname(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_firstname_NN;
    }

    RegExp regexFirstname = RegExp(
      r"^[A-ZÄÖÜ][a-zäöü]+\b",
      multiLine: false,
    );

    if (!regexFirstname.hasMatch(value)) {
      return Language.of(context).warning_firstname_UpperThenLower;
    }

    return null;
  }

  String _validatorLastname(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_lastname_NN;
    }

    RegExp regexLastname = RegExp(
      r"^[A-ZÄÖÜ][a-zäöü]+\b",
      multiLine: false,
    );

    if (!regexLastname.hasMatch(value)) {
      return Language.of(context).warning_lastname_UpperThenLower;
    }

    return null;
  }

  String _validatorStreet(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_street_NN;
    }

    RegExp regexLastname = RegExp(
      r"^[A-ZÄÖÜ][a-zäöü]+\b",
      multiLine: false,
    );

    if (!regexLastname.hasMatch(value)) {
      return Language.of(context).warning_street_UpperThenLower;
    }

    return null;
  }

  String _validatorHouseNumber(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_house_number_NN;
    }

    RegExp regexStreetNr = RegExp(
      r"^[1-9]([0-9]?)([a-zA-Z]?)$",
      multiLine: false,
    );

    if (!regexStreetNr.hasMatch(value)) {
      return Language.of(context).warning_house_number_UpperThenLower;
    }

    return null;
  }

  String _validatorPostcode(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_postcode_NN;
    }

    RegExp regexZipCode = RegExp(
      r"^\d{5}$",
      multiLine: false,
    );

    if (!regexZipCode.hasMatch(value)) {
      return Language.of(context).warning_postcode_5_Figures;
    }

    return null;
  }

  String _validatorCity(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_city_NN;
    }

    RegExp regexCity = RegExp(
      r"^[A-ZÄÖÜ][a-zäöü-]+\b",
      multiLine: false,
    );

    if (!regexCity.hasMatch(value)) {
      return Language.of(context).warning_city_UpperThenLower;
    }

    return null;
  }

  String _validatorUsername(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_user_name_NN;
    }

    return null;
  }

  String _validatorEmail(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_email_NN;
    }

    RegExp regexEmail = RegExp(
      r"^\w{4}\d{4,}@stud\.(hs-kl|fh-kl)\.de$",
      multiLine: false,
    );

    if (!regexEmail.hasMatch(value)) {
      return Language.of(context).warning_email_not_hskl;
    }

    return null;
  }

  String _validatorPassword(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_password;
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
    bool hasUpperAndLowerCase = regexUpperAndLowerCase.hasMatch(value);

    if (hasMinLen && hasUpperAndLowerCase && hasNumber && hasSpecialSign && hasLenBigger7) {
      // TODO Passwortstärke Visual darstellen siehe SWTP Projekt
      // sehr sicher

      return null;
    } else if (hasMinLen && hasUpperAndLowerCase && hasNumber && hasSpecialSign) {
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

      return Language.of(context).password_level_not_save;
    }
  }

  String _validatorRepeatPassword(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).password_empty;
    }
    if (value != password.text) {
      return Language.of(context).warning_password_not_same;
    }
    return null;
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
              Language.of(context).register,
              style: TextStyle(
                fontSize: 30,
              ),
            )),
      ),
    );
  }
}
