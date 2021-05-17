import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/screens/login_screen.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/widgets/auth_endpoint_visualisation.dart';
import 'package:swtp_app/widgets/poi_endpoint_visualisation.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class CheckBiometricsWidget extends StatefulWidget {
  static const routeName = '/biometrics';

  final bool isOldLogInAvailable;

  CheckBiometricsWidget({this.isOldLogInAvailable});

  @override
  State<StatefulWidget> createState() => CheckBiometricsWidgetState();
}

class CheckBiometricsWidgetState extends State<CheckBiometricsWidget> {
  bool _isOldLogInAvailable = true;

  LocalAuthentication _authentication = LocalAuthentication();
  Future<bool> _canCheckBiometrics;
  List<BiometricType> _availableBiometrics = [];
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    _checkIfDataAvailable().then((_) => _checkIfBiometricsAvailable()).then((value) => _getBiometrics());
  }

  Future<void> _checkIfDataAvailable() async {
    bool hasToken = await AuthEndpointProvider.storage.containsKey(key: 'token');
    bool hasUserId = await AuthEndpointProvider.storage.containsKey(key: 'userId');

    _isOldLogInAvailable = hasToken && hasUserId;
    if (!_isOldLogInAvailable) {
      Navigator.popAndPushNamed(context, LoginScreen.routeName);
    }
  }

  Future<void> _checkIfBiometricsAvailable() async {
    try {
      _canCheckBiometrics = _authentication.canCheckBiometrics;

      if (!mounted) {
        print("Not mounted");
        return;
      }
    } on PlatformException catch (E) {
      print(E);
    }
  }

  Future<void> _getBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await _authentication.getAvailableBiometrics();
    } on PlatformException catch (E) {
      print(E);
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    if (_isOldLogInAvailable) {
      try {
        print("number of verifications: ${_availableBiometrics.length}");
        print("canCheckBiometrics: $_canCheckBiometrics");
        if (await _canCheckBiometrics) {
          if (_availableBiometrics != null &&
              (_availableBiometrics.contains(BiometricType.face) ||
                  _availableBiometrics.contains(BiometricType.fingerprint))) {
            authenticated = await _authentication.authenticate(
                localizedReason: Language.of(context).authMessage, biometricOnly: true, stickyAuth: true);
          }
        }
      } on PlatformException catch (E) {
        setState(() {
          _canCheckBiometrics = Future<bool>.value(false);
        });
      }
      setState(() {
        if (authenticated) {
          _loadLogInDataAndLogIn();
        }
      });
    }
  }

  Future<void> _loadLogInDataAndLogIn() async {
    AuthService().token = await AuthEndpointProvider.storage.read(key: 'token');
    String userIdString = await AuthEndpointProvider.storage.read(key: 'userId');
    int userId = int.parse(userIdString);
    await AuthEndpointProvider().checkIfAlreadyLoggedInAndLoadUser(userId);

    AuthEndpointProvider().reloadUserResponse.fold((failure) {}, (success) {
      GroupServiceProvider()
          .loadAllGroups()
          .then((value) => UserServiceProvider().getAllUsers(GroupServiceProvider().ownGroup))
          .then((value) => AuthService().loadUsersAndPoiData());
    });
  }

  _createBiometricAuthWidget() {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Language.of(context).login),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _selectLanguage(),
                    Text(
                      Language.of(context).continueSession,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                        child: ElevatedButton(
                          onPressed: _authenticate,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              (Colors.black12),
                            ),
                          ),
                          child: Text(
                            Language.of(context).yes,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, LoginScreen.routeName);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              (Colors.black12),
                            ),
                          ),
                          child: Text(
                            Language.of(context).no,
                            style: TextStyle(
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AuthEndpointVisualisation(),
                PoiEndpointVisualisation(
                  destinationRouteBySuccess: TabScreen.routeName,
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _canCheckBiometrics,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                _createBiometricAuthWidget(),
                if (!snapshot.data)
                  PopUpWarningDialog(context: context, failure: Failure(Language.of(context).biometricNotPossible))
              ],
            );
          } else {
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
            );
          }
        });
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
          icon: Image.asset('icons/flags/png/de.png', package: 'country_icons'), //Text(Language.of(context).german)),
        )
      ],
    );
  }
}