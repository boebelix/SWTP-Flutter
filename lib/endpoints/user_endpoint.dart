import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/log_service.dart';

class UserEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();
  LogService logService = LogService();

  Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/users/$userId"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}"
        },
      );

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

  Future<List<User>> getUser() async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/users/"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        List<User> allUsers = [];

        logService.prettyLogger.d(jsonDecode(response.body));

        for (dynamic elem in jsonDecode(response.body)) {
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

  Future<List<GroupMembership>> getMemberships(int userId) async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/users/$userId/memberships"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        List<GroupMembership> memberships = [];

        for (dynamic elem in jsonDecode(response.body)) {
          memberships.add(GroupMembership.fromJSON(elem));
        }
        print(memberships.length);
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
          "Authorization": "Bearer ${userService.token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
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
