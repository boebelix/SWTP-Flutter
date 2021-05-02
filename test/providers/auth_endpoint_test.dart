import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:swtp_app/endpoints/auth_endpoint.dart';
import 'package:swtp_app/models/auth_response.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/services/auth_service.dart';

import '../fixtures/fixture_reader.dart';

class MockAuthEndpoint extends Mock implements AuthEndpoint {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  LoginCredentials loginCredentials = LoginCredentials("test", "test");
  AuthService authService = AuthService();
  AuthEndpointProvider authEndpointProvider = AuthEndpointProvider();
  AuthEndpoint authEndpoint = MockAuthEndpoint();
  authEndpointProvider.logInEndpoint = authEndpoint;

  User user = User.fromJSON(jsonDecode(fixture('test_user.json')));

  group("login", () {
    test("login test", () async {
      when(authEndpoint.signIn(loginCredentials)).thenAnswer((_) async {
        return AuthResponse.fromJSON(jsonDecode(fixture('test_user_auth_response.json')));
      });
      await authEndpointProvider.logIn(loginCredentials);

      verify(authEndpoint.signIn(loginCredentials));
      expect(authService.user, user);
    });
  });
}
