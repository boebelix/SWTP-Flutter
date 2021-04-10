import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/widgets/auth_endpoint_visualisation.dart';
import 'package:swtp_app/services/information_pre_loader_service.dart';
import 'package:swtp_app/widgets/register.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.of(context).login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                children: [
                  _selectLanguage(),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: Language.of(context).user_name,
                    ),
                    controller: username,
                    validator: _validatorUsernameIsNotEmpty,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: Language.of(context).password,
                    ),
                    validator: _validatorPasswordIsNotEmpty,
                    controller: password,
                    obscureText: true,
                  ),
                  _buttonLogin(deviceSize, context),
                  _buttonRegistration(deviceSize, context),
                ],
              ),
            ),
            AuthEndpointVisualisation(
              destinationRouteBySuccess: TabScreen.routeName,
            )
          ],
        ),
      ),
    );
  }

  void _sendLoginData() async {
    if (_formKey.currentState.validate()) {
      await Provider.of<AuthEndpointProvider>(context, listen: false)
          .logIn(LoginCredentials(username.text, password.text));
      username.clear();
      password.clear();
      await InformationPreLoaderService().loadAllInformation();
      AuthEndpointProvider().setState(NotifierState.loaded);

    }
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
            Language.of(context).login,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
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
              Language.of(context).register,
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
              Language.load(Locale('en'));
            });
          },
          icon: Image.asset('icons/flags/png/gb.png', package: 'country_icons'),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              Language.load(Locale('de'));
            });
          },
          icon: Image.asset('icons/flags/png/de.png',
              package: 'country_icons'), //Text(Language.of(context).german)),
        )
      ],
    );
  }

  String _validatorUsernameIsNotEmpty(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_user_name_NN;
    }

    return null;
  }

  String _validatorPasswordIsNotEmpty(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).password_empty;
    }

    return null;
  }
}
