import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/widgets/register.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  void _sendLoginData() async {
    // TODO Change to validators
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      Provider.of<AuthEndpointProvider>(context, listen: false)
          .logIn(LoginCredentials(username.text, password.text));
      username.clear();
      password.clear();
    } else {}
  }

  // TODO Delete before merge
  @override
  void initState() {
    username.text = 'test';
    password.text = 'test';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            ListView(
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
                _buttonLogin(deviceSize, context),
                _buttonRegistration(deviceSize, context),
              ],
            ),
            _authEndpointController(context),
          ],
        ),
      ),
    );
  }

  Consumer<AuthEndpointProvider> _authEndpointController(BuildContext context) {
    return Consumer<AuthEndpointProvider>(
      builder: (_, notifier, __) {
        switch (notifier.state) {
          case NotifierState.initial:
            {
              return Container();
            }
            break;

          case NotifierState.loading:
            {
              return _loadingIndicator(context);
            }
            break;

          default:
            {
              return notifier.authResponse.fold(
                //Fehlerfall
                (failure) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    notifier.resetState();
                  });

                  return PopUpWarningDialog(
                    context: context,
                    failure: failure,
                  );
                },
                // Alles in Ordnung
                (userService) {
                  _loginSuccessChangeScreen(context);
                  return Container();
                },
              );
            }
        }
      },
    );
  }

  SizedBox _buttonLogin(Size deviceSize, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: deviceSize.height * 0.1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.02, 0, 0),
        child: ElevatedButton(
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
        ),
      ),
    );
  }

  void _loginSuccessChangeScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.popAndPushNamed(context, TabScreen.routeName);
    });
  }

  Widget _loadingIndicator(BuildContext context) {
    final sizeLoadingIndicator = MediaQuery.of(context).size.shortestSide * 0.7;
    return Center(
      child: SizedBox(
        height: sizeLoadingIndicator,
        width: sizeLoadingIndicator,
        child: CircularProgressIndicator(
          strokeWidth: 10,
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
