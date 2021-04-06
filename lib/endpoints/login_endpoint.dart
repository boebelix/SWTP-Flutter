import 'dart:convert';
import 'dart:io';

import 'package:swtp_app/models/login_credentials.dart';
import 'package:http/http.dart' as http;

class LogInEndpoint {
  Future<Map<String, dynamic>> signIn(LoginCredentials data) async {
    print("in Methode");
    print(data.toJson());
    print(jsonEncode(data.toJson()));
    return await http
        .post(Uri.http("boebelix.ddns.net", "/api/authentication"),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            },
            body: jsonEncode(data.toJson()))
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('throws');
        throw HttpException('Unauthorized');
      }
    });
  }
}
