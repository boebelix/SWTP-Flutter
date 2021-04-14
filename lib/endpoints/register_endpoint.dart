import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/log_service.dart';

class RegisterEndpoint {
  var url = Properties.url;
  LogService logger = LogService();

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

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
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
