import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/screens/login_screen.dart';
import 'package:swtp_app/screens/tabs_screen.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/widgets/auth_endpoint_visualisation.dart';
import 'package:swtp_app/widgets/poi_endpoint_visualisation.dart';

class CheckBiometricsWidget extends StatefulWidget {
  static const routeName = '/biometrics';

  final bool isOldLogInAvailable;

  CheckBiometricsWidget({this.isOldLogInAvailable});

  @override
  State<StatefulWidget> createState() => CheckBiometricsWidgetState();
}

class CheckBiometricsWidgetState extends State<CheckBiometricsWidget> {
  bool _isOldLogInAvailable;

  LocalAuthentication _authentication = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics = [];
  bool authenticated = false;


  @override
  void initState() {
    super.initState();
    _checkIfDataAvailable().then((_)=>_checkIfBiometricsAvailable()).then((value) => _getBiometrics());
  }

  Future<void> _checkIfDataAvailable() async{
    bool hasToken = await AuthEndpointProvider.storage.containsKey(key: 'token');
    bool hasUserId = await AuthEndpointProvider.storage.containsKey(key: 'userId');

    setState(() {
      _isOldLogInAvailable=hasToken && hasUserId;
    });
  }

  Future<void> _checkIfBiometricsAvailable() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _authentication.canCheckBiometrics;

      if (!mounted) {
        print("Not mounted");
        return;
      }
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
      });
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
        if (_canCheckBiometrics) {
          if (_availableBiometrics != null &&
              (_availableBiometrics.contains(BiometricType.face) ||
                  _availableBiometrics.contains(BiometricType.fingerprint))) {
            authenticated = await _authentication.authenticate(
                localizedReason: Language.of(context).authMessage, biometricOnly: true);
          }
        }
      } on PlatformException catch (E) {
        print(E);
      }
      setState(() {
        if (authenticated) {
          _loadLogInDataAndLogIn();
        }
        else
          {
            setState(() {
              Navigator.popAndPushNamed(context, LoginScreen.routeName);
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Language.of(context).login),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(Language.of(context).continueSession),
                      ElevatedButton(
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
                      ElevatedButton(
                        onPressed: (){
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
                            fontSize: 30,
                          ),
                        ),
                      ),
                      //_selectLanguage(),
                    ],
                  ),
                ),
                AuthEndpointVisualisation(),
                PoiEndpointVisualisation(
                  destinationRouteBySuccess: TabScreen.routeName,
                ),
              ],
            )
        )
    );
  }
}
