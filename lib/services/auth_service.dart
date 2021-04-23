import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/endpoints/register_endpoint.dart';
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  User user;
  String token;

  void logOut(BuildContext context) {
    user = null;
    token = null;
    Provider.of<AuthEndpointProvider>(context, listen: false).resetState();
  }

  bool isSignedIn() {
    return token != null && user != null;
  }

  Future<bool> registerUser({RegisterCredentials credentials}) async {
    try {
      Map<String, dynamic> responseData = await RegisterEndpoint().register(credentials);
      user = User.fromJSON(responseData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logIn({
    @required BuildContext context,
    @required String username,
    @required String password,
  }) async {
    var authEndpointProvider = Provider.of<AuthEndpointProvider>(context, listen: false);
    var groupServiceProvider = Provider.of<GroupServiceProvider>(context, listen: false);
    var userEndpointProvider = Provider.of<UserServiceProvider>(context, listen: false);

    await authEndpointProvider.logIn(LoginCredentials(username, password));

    if (AuthService().isSignedIn()) {
      await groupServiceProvider.loadAllGroups();

      await userEndpointProvider.getAllUsers(groupServiceProvider.ownGroup);
    }

    if (AuthService().isSignedIn()) {

      List<int> allUserIdsOfMembershipsOwner = [];
      allUserIdsOfMembershipsOwner.add(AuthService().user.userId);

      for (Group group in groupServiceProvider.allGroupsExceptOwn) {

        allUserIdsOfMembershipsOwner.add(group.admin.userId);

      }

      var poiEndpointProvider = Provider.of<PoiServiceProvider>(context, listen: false);

      try {
        await poiEndpointProvider.getAllVisiblePois(allUserIdsOfMembershipsOwner);
      } catch (e) {
        if (FailureTranslation.text('responseNoAccess') != e.toString()) {
          throw Failure('${FailureTranslation.text('unknownFailure')} ${e.toString()}');
        }
      }
    }
  }
}
