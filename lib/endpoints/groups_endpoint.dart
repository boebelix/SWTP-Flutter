import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class GroupsEndpoint {
  var _url = Properties.url;
  AuthService _userService = AuthService();

  Future<Map<String, dynamic>> getGroupById(int groupNumber) async {
    try {
      final response = await http.get(
        Uri.http(_url, "/api/groups/$groupNumber"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${_userService.token}"
        },
      );

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('groupNotFound'));
      }

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        throw Failure('${FailureTranslation.text('unknownFailure')} ${response.statusCode}');
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<Map<String, dynamic>> createGroup(int adminId, String groupName) async {
    try {
      final response = await http.post(
        Uri.http(_url, "/api/groups/"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${_userService.token}"
        },
        body: {
          "adminId": "$adminId",
          "groupName": "$groupName",
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        throw Failure('${FailureTranslation.text('unknownFailure')} ${response.statusCode}');
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<Map<String, dynamic>> inviteUserToGroup(int groupId, int userId) async {
    try {
      final response = await http.post(
        Uri.http(_url, "/api/groups/$groupId/members"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${_userService.token}",
        },
        body: json.encode({"userId": userId}),
      );

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        throw Failure('${FailureTranslation.text('unknownFailure')} ${response.statusCode}');
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<void> removeUserFromGroup(int groupId, int userId) async {
    try {
      final response = await http.delete(
        Uri.http(_url, "/api/groups/$groupId/members/$userId"),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer ${_userService.token}",
        },
      );

      if (response.statusCode != HttpStatus.noContent) {
        throw Failure(FailureTranslation.text('noConnection'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<Map<String, dynamic>> acceptGroupInvitation(int groupId, int userId) async {
    try {
      final response = await http.put(
        Uri.http(_url, "/api/groups/$groupId/members/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_userService.token}",
        },
        body: jsonEncode(
          {"isInvitationPending": "false"},
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        throw Failure('${FailureTranslation.text('unknownFailure')} ${response.statusCode}');
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }
}
