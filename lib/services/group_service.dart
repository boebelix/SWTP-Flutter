import 'package:swtp_app/endpoints/groups_endpoint.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/services/auth_service.dart';

class GroupService {
  static final GroupService _instance = GroupService._internal();

  factory GroupService() => _instance;

  Group _ownGroup = null;
  List<Group> _acceptedGroups;
  List<GroupMembership> _memberships;
  List<Group> _invitedIntoGroups;

  AuthService _authService;

  GroupsEndpoint _groupsEndpoint;

  UserEndpoint _userEndpoint;

  GroupService._internal() {
    _acceptedGroups = <Group>[];
    _memberships = <GroupMembership>[];
    _invitedIntoGroups = <Group>[];
    _authService = AuthService();
    _groupsEndpoint = GroupsEndpoint();
    _userEndpoint = UserEndpoint();
  }

  Future<void> reloadAll() async {
    await loadOwnGroup();
    await loadGroupMembershipsOfOwnUserOnly();
    await loadGroups();
  }

  Future<void> loadOwnGroup() async {
    try {
      Map<String, dynamic> response = await _groupsEndpoint.getGroupById(_authService.user.userId);
      _ownGroup = _readGroupFromJson(response);
    } catch (e) {
      if (FailureTranslation.text('groupNotFound') != e.toString()) {
        throw Failure('${FailureTranslation.text('unknownFailure')} ${e.toString()}');
      }
      _ownGroup = null;
    }
  }

  Future<void> loadGroups() async {
    _invitedIntoGroups.clear();
    _acceptedGroups.clear();

    if (_memberships.isEmpty) await loadGroupMembershipsOfOwnUserOnly();

    for (GroupMembership m in _memberships) {
      if (m.invitationPending) {
        _invitedIntoGroups.add(_readGroupFromJson(await _groupsEndpoint.getGroupById(m.id.groupId)));
      } else {
        _acceptedGroups.add(_readGroupFromJson(await _groupsEndpoint.getGroupById(m.id.groupId)));
      }
    }
  }

  Future<void> loadGroupMembershipsOfOwnUserOnly() async {
    _memberships.clear();
    _memberships = await _userEndpoint.getMemberships(_authService.user.userId);
  }

  Future<void> denyInvitationOrLeaveGroup(int groupId) async {
    await _groupsEndpoint.removeUserFromGroup(groupId, _authService.user.userId);
  }

  Future<void> kickUserFromOwnGroup(int userId) async {
    await _groupsEndpoint.removeUserFromGroup(_ownGroup.groupId, userId);
    await loadOwnGroup();
  }

  Future<void> inviteUserToGroup(int userId) async {
    await _groupsEndpoint.inviteUserToGroup(_ownGroup.groupId, userId);
    await loadOwnGroup();
  }

  Future<void> acceptGroupInvitation(int groupId) async {
    await _groupsEndpoint.acceptGroupInvitation(groupId, _authService.user.userId);
  }

  Group get ownGroup => _ownGroup;

  List<GroupMembership> get memberships => _memberships;

  List<Group> get invitedIntoGroups => _invitedIntoGroups;

  List<Group> get acceptedGroups => _acceptedGroups;

  Group _readGroupFromJson(Map<String, dynamic> json) {
    Group group = Group.fromJSON(json);

    List<GroupMembership> groupMemberships = <GroupMembership>[];

    for (dynamic elem in json['memberships']) {
      groupMemberships.add(GroupMembership.fromJSON(elem));
    }
    group.memberships = groupMemberships;

    return group;
  }

  Future<void> createGroup(String name) async {
    _ownGroup = await _groupsEndpoint.createGroup(name);
  }
}
