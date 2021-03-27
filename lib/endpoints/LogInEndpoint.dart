

import 'dart:convert';

import 'package:swtp_app/models/Credentials.dart';
import 'package:http/http.dart' as http;

class LogInEndpoint
{

  Future<void> signIn(Credentials data) async {
    print("in Methode");
    print(data.toJson());
    print(jsonEncode(data.toJson()));
    return await http.post(
      Uri.https("10.0.2.2:9080","/api/authentication"),
      body: jsonEncode(data.toJson())
    ).then((response){

      print(response.statusCode);
    });
  }


}