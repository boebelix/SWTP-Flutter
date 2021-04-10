import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class PoiEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();

  Future<String> getPoiForUser(int userId) async {
    return await http
        .get(Uri.http(url, "/api/pois", {"author": "$userId"}), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      print(response.statusCode);
      if (response.statusCode == HttpStatus.ok) {
        return response.body;
      } else {
        if (response.statusCode == HttpStatus.notFound) {
          throw HttpException("not found");
        }
        throw HttpException("User is not valid");
      }
    });
  }
}
