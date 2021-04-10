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
  List<Group> _invitedIntoGroups;

  AuthService authService;

  GroupsEndpoint _groupsEndpoint;

  UserEndpoint _userEndpoint;

  GroupService._internal() {
    _acceptedGroups = List<Group>();
    _memberships = List<GroupMembership>();
    _invitedIntoGroups = List<Group>();
    authService = AuthService();
    _groupsEndpoint = GroupsEndpoint();
    _userEndpoint = UserEndpoint();

  }

  void reloadAll() async {
    await loadOwnGroup();
    await loadGroupMembershipsOfOwnUserOnly();
    await loadGroups();
  }

  Future<void> loadOwnGroup() async {
    Map<String, dynamic> response =
        await _groupsEndpoint.getGroupById(authService.user.userId);

    _ownGroup = _readGroupfromJson(response);
  }

  Future<void> loadGroups() async {
    _invitedIntoGroups.clear();

    if(_memberships.isEmpty) await loadGroupMembershipsOfOwnUserOnly();

    for (GroupMembership m in _memberships) {
      if (m.invitationPending){
        _invitedIntoGroups.add(_readGroupfromJson(
            await _groupsEndpoint.getGroupById(m.id.groupId)));
      }else{
        _acceptedGroups.add(_readGroupfromJson(
            await _groupsEndpoint.getGroupById(m.id.groupId)));
      }
    }
  }

  Future<void> loadGroupMembershipsOfOwnUserOnly() async {
    _memberships.clear();
    String response =
        await _userEndpoint.getMemberships(authService.user.userId);

    for (dynamic elem in jsonDecode(response)) {
      _memberships.add(GroupMembership.fromJSON(elem));
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

  List<Group> get invitetIntoGroups => _invitedIntoGroups;

  List<Group> get acceptedGroups => _acceptedGroups;

  Group _readGroupfromJson(Map<String, dynamic> json) {
    Group gr = Group.fromJSON(json);

    List<GroupMembership> groupmemberships = List<GroupMembership>();

    for (dynamic elem in json['memberships']) {
      groupmemberships.add(GroupMembership.fromJSON(elem));
    }
    gr.memberships = groupmemberships;

    return gr;
  }
}
