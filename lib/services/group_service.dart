/*import 'dart:convert';

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

  //eigene gruppe
  Group _ownGroup = null;
  //gruppen in denen man member ist und pending false (wird aus membership generiert)
  List<Group> _acceptedGroups;
  //eigene memberships also eine liste von alle memberships die der Nutzer hat
  List<GroupMembership> _memberships;
  //gruppen in die man eingeladen wird (wird aus memberships generiert)
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

  //nicht notwendig
  Future<void> reloadAll() async {
    await loadOwnGroup();
    await loadGroupMembershipsOfOwnUserOnly();
    await loadGroups();
  }

  //spricht getGroupById an und baut antwort in gruppe um (eigene Gruppe)
  //group speichert keine memberships etc ab (sicherlich unpraktisch)

  Future<void> loadOwnGroup() async {
    try {
      Map<String, dynamic> response = await _groupsEndpoint.getOwnGroup(_authService.user.userId);
      _ownGroup = _readGroupFromJson(response);
    } catch (e) {
      if (FailureTranslation.text('groupNotFound') != e.toString()) {
        throw Failure('${FailureTranslation.text('unknownFailure')} ${e.toString()}');
      }
      _ownGroup = null;
    }
  }

  //liest memberships ein von nutzer und geht dann durch bei welchen er drin is und wo pending is
  //weißt je nach dem die entsprechende gruppe zu
  //frage nach dem sinn? wieso kann das nicht direkt im consumer gemacht werden?
  //aka where(pending)? wäre deutlich performanter

  Future<void> loadGroups() async {
    _invitedIntoGroups.clear();
    _acceptedGroups.clear();

    if (_memberships.isEmpty) await loadGroupMembershipsOfOwnUserOnly();

    //ersetzen: einfach nur alle gruppen in ne liste speichern, die zuweisung der liste is im frontend besser
    for (GroupMembership m in _memberships) {
      if (m.invitationPending) {
        _invitedIntoGroups.add(_readGroupFromJson(await _groupsEndpoint.getOwnGroup(m.id.groupId)));
      } else {
        _acceptedGroups.add(_readGroupFromJson(await _groupsEndpoint.getOwnGroup(m.id.groupId)));
      }
    }
  }

  //holt groupMemberships für den angemeldeten Nutzer
  //irgendwie unnötig das von relaod all aufrufen zu lassen
  Future<void> loadGroupMembershipsOfOwnUserOnly() async {
    _memberships.clear();
    _memberships = await _userEndpoint.getMemberships(_authService.user.userId);
  }

  //lehnt einladung ab (entfernt den nutzer aus der gruppe (sich selbst!)
  // ignoriert antwort?
  //deny löscht den user aus der gruppe die angefragt hat (also entfernen von membership aus groupId where
  //userId==authServiceUserId
  Future<void> denyInvitationOrLeaveGroup(int groupId) async {
    await _groupsEndpoint.removeUserFromGroup(groupId, _authService.user.userId);
  }

  //entfernt Nutzer aus eigener Gruppe
  //es kommt kein body also wenn 204 dann userId suchen in owngroup und dort rauswerfen
  Future<void> kickUserFromOwnGroup(int userId) async {
    await _groupsEndpoint.removeUserFromGroup(_ownGroup.groupId, userId);
    await loadOwnGroup();
  }

  //einladen eines Nutzers in die eigene Gruppe
  // ignoriert antwort?
  //bekommt membershipObjekt was eingebaut werden kann (own group)
  Future<void> inviteUserToGroup() async {
    await _groupsEndpoint.inviteUserToGroup(_ownGroup.groupId);
    await loadOwnGroup();
  }

  //einladung annehmen
  // ignoriert antwort?
  //bekommt membershipobjekt was eingebaut werden kann (updated eingene membership die auf pending war)
  //also für group Id suchen und dort die membershipsuchen und pending false setzen
  Future<void> acceptGroupInvitation(int groupId) async {
    await _groupsEndpoint.acceptGroupInvitation(groupId);
  }

  Group get ownGroup => _ownGroup;

  List<GroupMembership> get memberships => _memberships;

  List<Group> get invitedIntoGroups => _invitedIntoGroups;

  List<Group> get acceptedGroups => _acceptedGroups;

  //baut aus einem json response eine gruppe (aber baut memberships nachträglich ein)
  Group _readGroupFromJson(Map<String, dynamic> json) {
    Group group = Group.fromJSON(json);

    List<GroupMembership> groupMemberships = <GroupMembership>[];

    for (dynamic elem in json['memberships']) {
      groupMemberships.add(GroupMembership.fromJSON(elem));
    }
    group.memberships = groupMemberships;

    return group;
  }

  //erzeugt gruppe
  Future<void> createGroup(String name) async {
    _ownGroup = await _groupsEndpoint.createGroup(name);
  }
}*/
