import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/user_service.dart';

class PoiEndpoint {
  var url = Properties.url;
  UserService userService = UserService();

  Future<String> getPoiForUser(int userId) async {
    return await http.get(Uri.http(url, "/api/pois?author=$userId"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      print(url+"/api/pois?author=$userId");
      print(userId);
      print(response.statusCode);
      if (response.statusCode == HttpStatus.ok) {
        return response.body;
      } else {
        throw HttpException("User is not valid");
      }
    });
  }
}
