import 'dart:convert';
import 'dart:io';
import 'package:swtp_app/models/auth_response.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/properties/properties.dart';

class AuthEndpoint {
  var url = Properties.url;

  Future<AuthResponse> signIn(LoginCredentials data) async {
    try {
      final response = await http.post(
        Uri.http(url, "/api/authentication"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(
          data.toJson(),
        ),
      );

      if (response.statusCode == HttpStatus.unauthorized) {
        throw Failure('Authentifizierung Fehlgeschlagen');
      }

      await Future.delayed(Duration(milliseconds: 3000));

      return AuthResponse.fromJSON(jsonDecode(response.body));
    } on SocketException {
      throw Failure('Kein Verbindung zum Server 😑');
    } on HttpException {
      throw Failure("Couldn't find the post 😱");
    } on FormatException {
      throw Failure("Bad response format 👎");
    }
  }
}
