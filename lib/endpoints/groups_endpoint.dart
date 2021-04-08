import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/models/user.dart';

class GroupsEndpoint {
  Future<Map<String, dynamic>> getGroup(int groupNumber,String token) async {

    return await http
        .get(Uri.http("10.0.2.2:9080", "/api/groups/$groupNumber"),
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
        if(response.statusCode ==HttpStatus.notFound)
          throw HttpException('NotFound');

        print('throws');
        throw HttpException('Unauthorized');
      }
    });
  }
  Future<Map<String, dynamic>> createGroup(int adminId,String groupName, String token) async {

    return await http
        .post(Uri.http("10.0.2.2:9080", "/api/groups/"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {
          "adminId":"$adminId",
          "groupName":"$groupName"
        })
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('throws');
        throw HttpException(response.reasonPhrase+response.statusCode.toString());
      }
    });
  }
  Future<Map<String, dynamic>> inviteUserToGroup(int groupId,int userId, String token) async {

    return await http
        .post(Uri.http("10.0.2.2:9080", "/api/groups/$groupId/members"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {
          "userId":"$userId"
        })
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('throws');
        throw HttpException(response.reasonPhrase+response.statusCode.toString());
      }
    });
  }
  Future<Map<String, dynamic>> removeUserFromGroup(int groupId,int userId, String token) async {

    return await http
        .delete(Uri.http("10.0.2.2:9080", "/api/groups/$groupId/members/$userId"),
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
        throw HttpException(response.reasonPhrase+response.statusCode.toString());
      }
    });
  }

  Future<Map<String, dynamic>> acceptGroupInvitation(int groupId,int userId, String token) async {

    return await http
        .put(Uri.http("10.0.2.2:9080", "/api/groups/$groupId/members/$userId"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {
          "invitationPending": "false"
        })
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('throws');
        throw HttpException(response.reasonPhrase+response.statusCode.toString());
      }
    });
  }
}
