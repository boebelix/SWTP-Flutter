import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:swtp_app/endpoints/groups_endpoint.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/services/auth_service.dart';

class GroupServiceProvider extends ChangeNotifier {
  static final GroupServiceProvider _instance = GroupServiceProvider._internal();

  factory GroupServiceProvider() => _instance;

  GroupServiceProvider._internal();

  NotifierState _state = NotifierState.initial;

  Either<Failure, List<GroupMembership>> ownMembershipsResponse;
  Either<Failure, List<Group>> allRelevantGroupsResponse;
  Either<Failure, void> removeUserFromGroupResponse;
  Either<Failure, void> removeUserFromOwnGroupResponse;
  Either<Failure, GroupMembership> inviteUserToGroupResponse;
  Either<Failure, GroupMembership> acceptGroupInvitationResponse;

  //own group gibt nen 404 failure wenn keine eigene gruppe existiert => TODO Fangen
  Either<Failure, Group> ownGroupResponse;

  Group ownGroup;
  List<Group> allGroupsExceptOwn = [];
  List<Group> invitedIntoGroups = [];
  List<Group> acceptedGroups = [];
  List<GroupMembership> ownMemberships = [];

  NotifierState get state => _state;

  _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  resetState() {
    _setState(NotifierState.initial);
    notifyListeners();
  }

  _setOwnMemberships(Either<Failure, List<GroupMembership>> ownMembershipsResponse) {
    if (ownMembershipsResponse.isRight()) {
      ownMemberships = ownMembershipsResponse.getOrElse(null);
    }
    this.ownMembershipsResponse = ownMembershipsResponse;
  }

  _setOwnGroup(Either<Failure, Group> ownGroupResponse) {
    if (ownGroupResponse.isRight()) {
      ownGroup = ownGroupResponse.getOrElse(null);
    }

    this.ownGroupResponse = ownGroupResponse;
  }

  _setAllGroups(Either<Failure, List<Group>> allRelevantGroupsResponse) {
    if (allRelevantGroupsResponse.isRight()) {
      allGroupsExceptOwn = allRelevantGroupsResponse.getOrElse(null);
      for (GroupMembership membership in ownMemberships) {
        Group group = allGroupsExceptOwn.where((element) => element.groupId == membership.id.groupId).first;
        if (membership.invitationPending) {
          invitedIntoGroups.add(group);
        } else {
          acceptedGroups.add(group);
        }
      }
    }

    this.allRelevantGroupsResponse = allRelevantGroupsResponse;
  }

  _setRemoveUserFromGroup(Either<Failure, void> removeUserFromGroupResponse, int groupId) {
    if (removeUserFromGroupResponse.isRight()) {
      GroupMembership membership = ownMemberships.where((element) => element.id.groupId == groupId).first;
      ownMemberships.remove(membership);

      Group group = allGroupsExceptOwn.where((element) => element.groupId == groupId).first;
      allGroupsExceptOwn.remove(group);
    }

    this.removeUserFromGroupResponse = removeUserFromGroupResponse;
  }

  _setRemoveUserFromOwnGroup(Either<Failure, void> removeUserFromOwnGroupResponse, int userId) {
    if (removeUserFromOwnGroupResponse.isRight()) {
      GroupMembership membership = ownGroup.memberships.where((element) => element.id.userId == userId).first;
      ownGroup.memberships.remove(membership);
    }

    this.removeUserFromOwnGroupResponse = removeUserFromOwnGroupResponse;
  }

  _setInviteUserToGroup(Either<Failure, GroupMembership> inviteUserToGroupResponse) {
    if (inviteUserToGroupResponse.isRight()) {
      ownGroup.memberships.add(inviteUserToGroupResponse.getOrElse(null));
    }

    this.inviteUserToGroupResponse = inviteUserToGroupResponse;
  }

  _setAcceptGroupInvitation(Either<Failure, GroupMembership> acceptGroupInvitationResponse, int groupId) {
    if (acceptGroupInvitationResponse.isRight()) {
      ownMemberships.where((element) => element.id.groupId == groupId).first.invitationPending = false;
    }

    this.acceptGroupInvitationResponse = acceptGroupInvitationResponse;
  }

  Future<void> loadAllGroups() async {
    _setState(NotifierState.loading);

    if (allGroupsExceptOwn.isNotEmpty) {
      allGroupsExceptOwn.clear();
    }
    if (invitedIntoGroups.isNotEmpty) {
      invitedIntoGroups.clear();
    }
    if (acceptedGroups.isNotEmpty) {
      acceptedGroups.clear();
    }
    if (ownMemberships.isNotEmpty) {
      ownMemberships.clear();
    }

    await Task(() => UserEndpoint().getMemberships(AuthService().user.userId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setOwnMemberships(value));
    if (ownMembershipsResponse.isRight()) {
      await Task(() => GroupsEndpoint().getOwnGroup())
          .attempt()
          .mapLeftToFailure()
          .run()
          .then((value) => _setOwnGroup(value));
    }

    List<int> groupIds = [];
    for (GroupMembership membership in ownMemberships) {
      groupIds.add(membership.id.groupId);
    }
    await Task(() => GroupsEndpoint().getAllRelevantGroups(groupIds))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setAllGroups(value));

    _setState(NotifierState.loaded);
  }

  Future<void> denyInvitationOrLeaveGroup(int groupId) async {
    _setState(NotifierState.loading);

    await Task(() => GroupsEndpoint().removeUserFromGroup(groupId, AuthService().user.userId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setRemoveUserFromGroup(value, groupId));

    _setState(NotifierState.loaded);
  }

  Future<void> kickUserFromOwnGroup(int userId) async {
    _setState(NotifierState.loading);

    await Task(() => GroupsEndpoint().removeUserFromGroup(ownGroup.groupId, userId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setRemoveUserFromOwnGroup(value, userId));

    _setState(NotifierState.loaded);
  }

  Future<void> inviteUserToGroup(int userId) async {
    _setState(NotifierState.loading);

    await Task(() => GroupsEndpoint().inviteUserToGroup(userId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setInviteUserToGroup(value));

    _setState(NotifierState.loaded);
  }

  Future<void> acceptGroupInvitation(int groupId) async {
    _setState(NotifierState.loading);

    await Task(() => GroupsEndpoint().acceptGroupInvitation(groupId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setAcceptGroupInvitation(value, groupId));

    _setState(NotifierState.loaded);
  }

  Future<void> createGroup(String name) async {
    _setState(NotifierState.loading);

    Task(() => GroupsEndpoint().createGroup(name))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setOwnGroup(value));

    _setState(NotifierState.loaded);
  }
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map(
      (either) => either.leftMap((obj) {
        try {
          return obj as Failure;
        } catch (e) {
          throw obj;
        }
      }),
    );
  }
}
