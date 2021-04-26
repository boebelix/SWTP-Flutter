import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:swtp_app/endpoints/auth_endpoint.dart';
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/auth_response.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/auth_endpoint_provider.dart';
import 'package:swtp_app/services/auth_service.dart';

class MockAuthEndpoint extends Mock implements AuthEndpoint{}

void main(){
  LoginCredentials loginCredentials=LoginCredentials("test", "test");
  AuthService authService=AuthService();
  AuthEndpointProvider authEndpointProvider=AuthEndpointProvider();
  AuthEndpoint authEndpoint=MockAuthEndpoint();
  authEndpointProvider.logInEndpoint=authEndpoint;

  User user=User.fromJSON({
    "city": "Rychvald",
    "email": "nwiley0@google.nl",
    "firstname": "Test",
    "groupMemberships": [
      {
        "id": {
          "groupId": 3,
          "userId": 1
        },
        "invitationPending": true,
        "member": {
          "city": "Rychvald",
          "email": "nwiley0@google.nl",
          "firstname": "Test",
          "lastname": "User",
          "street": "Hauk",
          "streetNr": "50",
          "userId": 1,
          "username": "test",
          "zip": "43450"
        }
      },
      {
        "id": {
          "groupId": 5,
          "userId": 1
        },
        "invitationPending": false,
        "member": {
          "city": "Rychvald",
          "email": "nwiley0@google.nl",
          "firstname": "Test",
          "lastname": "User",
          "street": "Hauk",
          "streetNr": "50",
          "userId": 1,
          "username": "test",
          "zip": "43450"
        }
      }
    ],
    "lastname": "User",
    "street": "Hauk",
    "streetNr": "50",
    "userId": 1,
    "username": "test",
    "zip": "43450"
  });


  test("login test", () async{
    when(authEndpoint.signIn(loginCredentials)).thenAnswer((_) async{
      return AuthResponse.fromJSON({"token":"token","user":{
        "city": "Rychvald",
        "email": "nwiley0@google.nl",
        "firstname": "Test",
        "groupMemberships": [
          {
            "id": {
              "groupId": 3,
              "userId": 1
            },
            "invitationPending": true,
            "member": {
              "city": "Rychvald",
              "email": "nwiley0@google.nl",
              "firstname": "Test",
              "lastname": "User",
              "street": "Hauk",
              "streetNr": "50",
              "userId": 1,
              "username": "test",
              "zip": "43450"
            }
          },
          {
            "id": {
              "groupId": 5,
              "userId": 1
            },
            "invitationPending": false,
            "member": {
              "city": "Rychvald",
              "email": "nwiley0@google.nl",
              "firstname": "Test",
              "lastname": "User",
              "street": "Hauk",
              "streetNr": "50",
              "userId": 1,
              "username": "test",
              "zip": "43450"
            }
          }
        ],
        "lastname": "User",
        "street": "Hauk",
        "streetNr": "50",
        "userId": 1,
        "username": "test",
        "zip": "43450"
      }});
    });
    await authEndpointProvider.logIn(loginCredentials);
    verify(authEndpoint.signIn(loginCredentials));
    expect(authService.user,user);
  });
  test("login fail", () async{
    when(authEndpoint.signIn(loginCredentials)).thenThrow(Failure(FailureTranslation.text('authFail')));

    await authEndpointProvider.logIn(loginCredentials);

    verify(authEndpoint.signIn(loginCredentials));
    //expect(authEndpointProvider.authResponse.isLeft(), true);
  });
}