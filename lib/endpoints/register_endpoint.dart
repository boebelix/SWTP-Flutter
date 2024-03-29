import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/properties/properties.dart';

class RegisterEndpoint {
  var url = Properties.url;

  Future<Map<String, dynamic>> register(RegisterCredentials credentials) async {
    try {
      final response = await http.post(
        Uri.http(url, "/api/users"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(
          credentials.toJson(),
        ),
      );

      if (response.statusCode == HttpStatus.conflict) {
        throw Failure(FailureTranslation.text('responseExistAlready'));
      }

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Failure(FailureTranslation.text('responseFailureRegister'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }
}
