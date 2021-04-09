import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/models/register_credentials.dart';
import 'package:swtp_app/properties/properties.dart';

class RegisterEndpoint {
  var url = Properties.url;

  Future<Map<String, dynamic>> register(RegisterCredentials credentials) async {
    print(credentials.toJson());
    return await http
        .post(Uri.http(url, "/api/users"),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            },
            body: jsonEncode(credentials.toJson()))
        .then((response) {
      print(response.body);
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
