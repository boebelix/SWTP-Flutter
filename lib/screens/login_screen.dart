import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/services/user_service.dart';
import 'package:swtp_app/widgets/register.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  void _sendLoginData() async {
    print(username.text);
    print(password.text);

    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      Provider.of<UserService>(context, listen: false)
          .logIn(LoginCredentials(username.text, password.text));
      username.clear();
      password.clear();
      print('Login beendet');
    } else {
      print('Keine Login Daten');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
      ),
      body: ListView(
        children: [
          _selectLanguage(),
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
          SizedBox(
            width: double.infinity,
            height: deviceSize.height * 0.1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.02, 0, 0),
              child: _buttonLogin(context),
            ),
          ),
          _buttonRegistration(deviceSize, context),
          Consumer<UserService>(
            builder: (_, notifier, __) {
              if (notifier.state == NotifierState.initial) {
                return StyledText('Press the button 👇');
              } else if (notifier.state == NotifierState.loading) {
                return CircularProgressIndicator();
              } else {
                return notifier.authResponse.fold(
                  (failure) => StyledText(failure.toString()),
                  (_) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print('Login Screen: Before popAndPushNamed');
                      Navigator.popAndPushNamed(context, TabScreen.routeName);
                      print('Login Screen: After popAndPushNamed');
                    });
                    return Container();
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }

  ElevatedButton _buttonLogin(BuildContext context) {
    return ElevatedButton(
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
      ),
    );
  }

  SizedBox _buttonRegistration(Size deviceSize, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: deviceSize.height * 0.1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.02, 0, 0),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Register.routeName);
            },
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
    );
  }

  Row _selectLanguage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              S.load(Locale('en'));
            });
          },
          icon: Image.asset('icons/flags/png/gb.png', package: 'country_icons'),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              S.load(Locale('de'));
            });
          },
          icon: Image.asset('icons/flags/png/de.png',
              package: 'country_icons'), //Text(S.of(context).german)),
        )
      ],
    );
  }
}

class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    Key key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 40),
    );
  }
}
