import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/endpoints/register_endpoint.dart';
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/providers/user_endpoint_provider.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';

import 'information_pre_loader_service.dart';

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
    await authEndpointProvider.logIn(LoginCredentials(username, password));

    if (AuthService().isSignedIn()) {
      var userEndpointProvider = Provider.of<UserEndpointProvider>(context, listen: false);
      await userEndpointProvider.getAllUsers();
      await userEndpointProvider.getMembersOfOwnGroup();
    }

    if (AuthService().isSignedIn()) {
      var allUserIdsOfMembershipsOwner = InformationPreLoaderService().userIds;
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
