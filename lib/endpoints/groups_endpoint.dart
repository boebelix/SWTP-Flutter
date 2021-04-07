import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class GroupsEndpoint {
  Future<Map<String, dynamic>> getGroups(int groupNumber,String token) async {

    return await http
        .post(Uri.http("10.0.2.2:9080", "/api/groups/$groupNumber"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token"
        })
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
