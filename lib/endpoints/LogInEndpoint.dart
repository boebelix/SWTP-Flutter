import 'dart:convert';
import 'dart:io';

import 'package:swtp_app/models/Credentials.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/models/User.dart';

class LogInEndpoint {
  Future<Map<String, dynamic>> signIn(Credentials data) async {
    print("in Methode");
    print(data.toJson());
    print(jsonEncode(data.toJson()));
    return await http
        .post(Uri.http("10.0.2.2:9080", "/api/authentication"),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            },
            body: jsonEncode(data.toJson()))
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
