import 'dart:convert';
import 'dart:io';
import 'package:swtp_app/l10n/failure_translation.dart';
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
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == HttpStatus.unauthorized) {
        throw Failure(FailureTranslation.text('authFail'));
      }

      await Future.delayed(Duration(milliseconds: 500));

      return AuthResponse.fromJSON(jsonDecode(response.body));
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }
}
