import 'dart:convert';

import 'package:swtp_app/endpoints/groups_endpoint.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/member.dart';
import 'package:swtp_app/models/user_memberships.dart';
import 'package:swtp_app/services/auth_service.dart';


class GroupService {
  static final GroupService _instance = GroupService._internal();

  factory GroupService() => _instance;

  GroupService._internal();

  List<UserMemberships> _memberships = List<UserMemberships>();
  List<Group> _groups = List<Group>();
  Group _ownGroup;
  GroupsEndpoint _groupsEndpoint = GroupsEndpoint();

  AuthService authService = AuthService();

  UserEndpoint _userEndpoint = UserEndpoint();

  void loadGroupMemberships() async {
    _memberships.clear();
    String response =
        await _userEndpoint.getMemberships(authService.user.userId);

    for (dynamic e in jsonDecode(response)) {
      _memberships.add(UserMemberships.fromJSON(e));
    }
  }

  void loadGroups() async {
    _groups.clear();
    if (_memberships.isEmpty) loadGroupMemberships();

    Map<String, dynamic> response =
        await _groupsEndpoint.getGroupById(authService.user.userId);
    _ownGroup = readGroupfromJson(response);

    for (UserMemberships membership in _memberships) {
      _groups.add(readGroupfromJson(
          await _groupsEndpoint.getGroupById(membership.groupId)));
    }
  }

  Group readGroupfromJson(Map<String, dynamic> json) {
    Group gr = Group.fromJSON(json);

    List<Member> groupmembers = List<Member>();
    for (dynamic e in json['memberships']) {
      groupmembers.add(Member.fromJSON(e));
    }
    gr.members = groupmembers;

    return gr;
  }

  void denyInvitationOrLeaveGroup(int groupId) {
    _groupsEndpoint.removeUserFromGroup(groupId, authService.user.userId);
    loadGroups();
  }

  void kickUserFromOwnGroup(int userId) {
    _groupsEndpoint.removeUserFromGroup(_ownGroup.groupId, userId);
  }

  void inviteUserToGroup(int userId) {
    _groupsEndpoint.inviteUserToGroup(_ownGroup.groupId, userId);
  }
}
