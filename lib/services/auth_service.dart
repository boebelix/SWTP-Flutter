import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/endpoints/register_endpoint.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';

enum NotifierState { initial, loading, loaded }

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  User user;
  String token;

  void logIn(LoginCredentials credentials) async {}

  void logOut(BuildContext context) {
    user = null;
    token = null;
    Provider.of<AuthEndpointProvider>(context, listen: false).resetState();
  }

  bool isSignedIn() {
    return token.isNotEmpty && user != null;
  }

  Future<void> registerUser({RegisterCredentials credentials}) async {
    Map<String, dynamic> responseData =
        await RegisterEndpoint().register(credentials);
    user = User.fromJSON(responseData);
  }
}
