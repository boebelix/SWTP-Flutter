import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/models/register_credentials.dart';

class RegisterEndpoint {
  Future<Map<String, dynamic>> register(RegisterCredentials credentials) async {
    print(credentials.toJson());
    return await http
        .post(Uri.http("10.0.2.2:9080", "/api/users"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(credentials.toJson()))
        .then((response) {
      if(response.statusCode ==HttpStatus.ok){
        Map<String, dynamic> responseData= jsonDecode(response.body);
        return responseData;
      }else{
        print('throws');
        throw HttpException('Unauthorized');
      }
    });

  }
}