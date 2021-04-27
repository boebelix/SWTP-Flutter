import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class UserEndpoint {
  var url = Properties.url;

  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/users/"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${AuthService().token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        List<User> allUsers = [];

        for (dynamic elem in jsonDecode(utf8.decode(response.bodyBytes))) {
          allUsers.add(User.fromJSON(elem));
        }

        return allUsers;
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseNoUserFound'));
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

  Future<List<GroupMembership>> getMemberships() async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/users/${AuthService().user.userId}/memberships"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${AuthService().token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        List<GroupMembership> memberships = [];

        for (dynamic elem in jsonDecode(utf8.decode(response.bodyBytes))) {
          memberships.add(GroupMembership.fromJSON(elem));
        }
        return memberships;
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseNoMembershipFound'));
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

  Future<Map<String, dynamic>> getCommentsByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/users/$userId/comments"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${AuthService().token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseNoMembershipFound'));
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
