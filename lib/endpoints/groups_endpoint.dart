import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class GroupsEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();

  Future<Map<String, dynamic>> getGroupById(int groupNumber) async {
    return await http.get(Uri.http(url, "/api/groups/$groupNumber"), headers: {
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

  Future<Map<String, dynamic>> createGroup(
      int adminId, String groupName) async {
    return await http.post(Uri.http(url, "/api/groups/"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }, body: {
      "adminId": "$adminId",
      "groupName": "$groupName"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('throws');
        throw HttpException(
            response.reasonPhrase + response.statusCode.toString());
      }
    });
  }

  Future<Map<String, dynamic>> inviteUserToGroup(
      int groupId, int userId) async {
    return await http
        .post(Uri.http(url, "/api/groups/$groupId/members"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }, body: {
      "userId": "$userId"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('throws');
        throw HttpException(
            response.reasonPhrase + response.statusCode.toString());
      }
    });
  }

  Future<void> removeUserFromGroup(int groupId, int userId) async {
    return await http.delete(
        Uri.http(url, "/api/groups/$groupId/members/$userId"),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}"
        }).then((response) {
      if (response.statusCode == HttpStatus.noContent) {
        return;
      } else {
        print('throws');
        throw HttpException(
            response.reasonPhrase + response.statusCode.toString());
      }
    });
  }

  Future<Map<String, dynamic>> acceptGroupInvitation(
      int groupId, int userId) async {
    return await http
        .put(Uri.http(url, "/api/groups/$groupId/members/$userId"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${userService.token}"
            },
            body: jsonEncode({"isInvitationPending": "false"}))
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('throws');
        throw HttpException(
            response.reasonPhrase + response.statusCode.toString());
      }
    });
  }
}
