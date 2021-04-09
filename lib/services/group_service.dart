import 'dart:convert';

import 'package:swtp_app/endpoints/groups_endpoint.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/services/auth_service.dart';

class GroupService {
  static final GroupService _instance = GroupService._internal();

  factory GroupService() => _instance;

  Group _ownGroup;
  List<Group> _acceptedGroups;
  List<GroupMembership> _memberships;
  List<Group> _invitetInto;

  AuthService authService;

  GroupsEndpoint _groupsEndpoint;

  UserEndpoint _userEndpoint;

  GroupService._internal() {
    _acceptedGroups = List<Group>();
    _memberships = List<GroupMembership>();
    _invitetInto = List<Group>();
    authService = AuthService();
    _groupsEndpoint = GroupsEndpoint();
    _userEndpoint = UserEndpoint();

    reloadAll();
  }

  void reloadAll() async {
    await loadOwnGroup();
    await loadGroupMembershipsOfOwnUserOnly();
    await loadGroupInvitations();
    await loadAcceptedGroups();
  }

  Future<void> loadOwnGroup() async {
    Map<String, dynamic> response =
        await _groupsEndpoint.getGroupById(authService.user.userId);

    _ownGroup = _readGroupfromJson(response);
  }

  Future<void> loadGroupInvitations() async {
    _invitetInto.clear();

    if (_memberships.isEmpty) await loadGroupMembershipsOfOwnUserOnly();

    for (GroupMembership m in _memberships) {
      if (m.invitationPending)
        _invitetInto.add(_readGroupfromJson(
            await _groupsEndpoint.getGroupById(m.id.groupId)));
    }
  }

  Future<void> loadGroupMembershipsOfOwnUserOnly() async {
    _memberships.clear();
    String response =
        await _userEndpoint.getMemberships(authService.user.userId);

    for (dynamic e in jsonDecode(response)) {
      _memberships.add(GroupMembership.fromJSON(e));
      print(_memberships.length);
    }
  }

  Future<void> loadAcceptedGroups() async {
    _acceptedGroups.clear();
    if (_memberships.isEmpty) await loadGroupMembershipsOfOwnUserOnly();

    for (GroupMembership membership in _memberships) {
      if (!membership.invitationPending)
        _acceptedGroups.add(_readGroupfromJson(
            await _groupsEndpoint.getGroupById(membership.id.groupId)));
    }
  }

  void denyInvitationOrLeaveGroup(int groupId) {
    _groupsEndpoint.removeUserFromGroup(groupId, authService.user.userId);
  }

  void kickUserFromOwnGroup(int userId) {
    _groupsEndpoint.removeUserFromGroup(_ownGroup.groupId, userId);
  }

  void inviteUserToGroup(int userId) {
    _groupsEndpoint.inviteUserToGroup(_ownGroup.groupId, userId);
  }

  Group get ownGroup => _ownGroup;

  List<GroupMembership> get memberships => _memberships;

  List<Group> get invitetInto => _invitetInto;

  List<Group> get acceptedGroups => _acceptedGroups;

  Group _readGroupfromJson(Map<String, dynamic> json) {
    Group gr = Group.fromJSON(json);

    List<GroupMembership> groupmemberships = List<GroupMembership>();

    for (dynamic e in json['memberships']) {
      groupmemberships.add(GroupMembership.fromJSON(e));
    }
    gr.memberships = groupmemberships;

    return gr;
  }
}
