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
        throw Failure('Authentification failed');
      }

      await Future.delayed(Duration(milliseconds: 500));

      return AuthResponse.fromJSON(jsonDecode(response.body));
    } on SocketException {
      throw Failure('No connection to server 😑');
    } on HttpException {
      throw Failure("Couldn't find the post 😱");
    } on FormatException {
      throw Failure("Bad response format 👎");
    }
  }
}
