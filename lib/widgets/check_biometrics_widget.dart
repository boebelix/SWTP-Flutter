// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:swtp_app/generated/l10n.dart';
// import 'package:swtp_app/providers/auth_endpoint_provider.dart';
// import 'package:swtp_app/providers/group_service_provider.dart';
// import 'package:swtp_app/providers/user_service_provider.dart';
// import 'package:swtp_app/services/auth_service.dart';
//
// class CheckBiometricsWidget extends StatefulWidget {
//
//   final bool isOldLogInAvailable;
//
//   CheckBiometricsWidget({this.isOldLogInAvailable});
//
//   @override
//   State<StatefulWidget> createState() => CheckBiometricsWidgetState();
// }
//
// class CheckBiometricsWidgetState extends State<CheckBiometricsWidget> {
//
//   final bool isOldLogInAvailable;
//
//   CheckBiometricsWidgetState({this.isOldLogInAvailable});
//
//   LocalAuthentication _authentication = LocalAuthentication();
//   bool _canCheckBiometrics;
//   List<BiometricType> _availableBiometrics = [];
//   bool authenticated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkIfBiometricsAvailable();
//     _getBiometrics();
//   }
//
//   Future<void> _checkIfBiometricsAvailable() async {
//     bool canCheckBiometrics = false;
//     try {
//       canCheckBiometrics = await _authentication.canCheckBiometrics;
//
//       if (!mounted) {
//         print("Not mounted");
//         return;
//       }
//       setState(() {
//         _canCheckBiometrics = canCheckBiometrics;
//       });
//     } on PlatformException catch (E) {
//       print(E);
//     }
//   }
//
//   Future<void> _getBiometrics() async {
//     List<BiometricType> availableBiometrics=[];
//     try {
//       availableBiometrics= await _authentication.getAvailableBiometrics();
//     } on PlatformException catch (E) {
//       print(E);
//     }
//
//     setState(() {
//       _availableBiometrics=availableBiometrics;
//     });
//   }
//
//   Future<void> authenticate() async
//   {
//     if(isOldLogInAvailable)
//     {
//       try{
//         print("number of verifications: ${_availableBiometrics.length}");
//         print("canCheckBiometrics: $_canCheckBiometrics");
//         if (_canCheckBiometrics) {
//           if (_availableBiometrics != null &&
//               (_availableBiometrics.contains(BiometricType.face) ||
//                   _availableBiometrics.contains(BiometricType.fingerprint))) {
//             authenticated = await _authentication.authenticate(
//                 localizedReason: Language.of(context).authMessage, biometricOnly: true);
//           }
//         }
//       } on PlatformException catch (E) {
//         print(E);
//       }
//       setState(() {
//         if (authenticated) {
//           _loadLogInDataAndLogIn();
//         }
//       });
//     }
//   }
//
//   Future<void> _loadLogInDataAndLogIn()async{
//     AuthService().token = await AuthEndpointProvider.storage.read(key: 'token');
//     String userIdString = await AuthEndpointProvider.storage.read(key: 'userId');
//     int userId = int.parse(userIdString);
//     await AuthEndpointProvider().checkIfAlreadyLoggedInAndLoadUser(userId);
//
//     AuthEndpointProvider().reloadUserResponse.fold((failure) {}, (success) {
//       GroupServiceProvider()
//           .loadAllGroups()
//           .then((value) => UserServiceProvider().getAllUsers(GroupServiceProvider().ownGroup))
//           .then((value) => AuthService().loadUsersAndPoiData());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     authenticate();
//   }
// }
