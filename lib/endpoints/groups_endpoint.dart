import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class GroupsEndpoint {
  var _url = Properties.url;
  AuthService _userService = AuthService();

  Future<List<Group>> getAllRelevantGroups(List<int> groupIds) async {
    try {
      List<Group> groups = [];
      for (int groupId in groupIds) {
        final response = await http.get(
          Uri.http(_url, "/api/groups/$groupId"),
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
          Map<String,dynamic> json=jsonDecode(response.body);
          Group group=Group.fromJSON(jsonDecode(response.body));

          List<GroupMembership> memberships=[];
          for(dynamic elem in json['memberships']){
            memberships.add(GroupMembership.fromJSON(elem));
          }
          group.memberships=memberships;
          groups.add(group);
        } else {
          throw Failure('${FailureTranslation.text('unknownFailure')} ${response.statusCode}');
        }
      }
      return groups;
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }


  //TODO WICHTIG, NURNOCH OWNGROUP
  Future<Group> getOwnGroup() async {
    try {
      final response = await http.get(
        Uri.http(_url, "/api/groups/${AuthService().user.userId}"),
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
        Map<String,dynamic> json=jsonDecode(response.body);
        Group group=Group.fromJSON(jsonDecode(response.body));

        List<GroupMembership> memberships=[];
        for(dynamic elem in json['memberships']){
          memberships.add(GroupMembership.fromJSON(elem));
        }
        group.memberships=memberships;

        return group;
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

  Future<Group> createGroup(String groupName) async {
    try {
      final response = await http.post(Uri.http(_url, "/api/groups/"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer ${_userService.token}"
          },
          body: json.encode(<String, dynamic>{"adminId": AuthService().user.userId, "name": "$groupName"}));

      if (response.statusCode == HttpStatus.ok) {
        return Group.fromJSON(json.decode(response.body));
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

  //TODO
  Future<GroupMembership> inviteUserToGroup(int userId) async {
    try {
      final response = await http.post(
        Uri.http(_url, "/api/groups/${AuthService().user.userId}/members"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${_userService.token}",
        },
        body: json.encode({"userId": userId}),
      );

      if (response.statusCode == HttpStatus.ok) {
        return GroupMembership.fromJSON(jsonDecode(response.body));
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

  //ok
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

  Future<GroupMembership> acceptGroupInvitation(int groupId) async {
    try {
      final response = await http.put(
        Uri.http(_url, "/api/groups/$groupId/members/${AuthService().user.userId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_userService.token}",
        },
        body: jsonEncode(
          {"isInvitationPending": "false"},
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        return GroupMembership.fromJSON(jsonDecode(response.body));
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
