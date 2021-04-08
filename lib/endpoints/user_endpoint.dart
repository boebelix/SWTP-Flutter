import 'dart:convert';
import 'dart:io';

import 'package:swtp_app/models/login_credentials.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/user_service.dart';

class LogInEndpoint {
  var url = Properties.url;
  UserService userService = UserService();

  Future<Map<String, dynamic>> getUserById(int userId) async {
    return await http.get(Uri.http(url, "/api/users/$userId"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        if (response.statusCode == HttpStatus.notFound)
          throw HttpException('NotFound');

        print('throws');
        throw HttpException('Unauthorized');
      }
    });
  }

  Future<Map<String, dynamic>> getUser() async {
    return await http.get(Uri.http(url, "/api/users/"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        if (response.statusCode == HttpStatus.notFound)
          throw HttpException('NotFound');

        print('throws');
        throw HttpException('Unauthorized');
      }
    });
  }
  Future<Map<String, dynamic>> getMemberships(int userId) async {
    return await http.get(Uri.http(url, "/api/users/$userId/member"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        if (response.statusCode == HttpStatus.notFound)
          throw HttpException('NotFound');

        print('throws');
        throw HttpException('Unauthorized');
      }
    });
  }

  Future<Map<String, dynamic>> getCommentsByUserId(int userId) async {
    return await http.get(Uri.http(url, "/api/users/$userId/comments"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        if (response.statusCode == HttpStatus.notFound)
          throw HttpException('NotFound');

        print('throws');
        throw HttpException('Unauthorized');
      }
    });
  }
}
