import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/group_service.dart';

class UserEndpointProvider extends ChangeNotifier {
  static final UserEndpointProvider _instance = UserEndpointProvider._internal();

  factory UserEndpointProvider() => _instance;

  UserEndpointProvider._internal();

  NotifierState _state = NotifierState.initial;

  UserEndpoint _userEndpoint = UserEndpoint();

  Either<Failure, List<User>> _allUsers;
  List<User> _usersNotInOwnGroup = [];
  List<User> _usersInOwnGroup = [];
  List<User> _userInvitedIntoOwnGroup = [];
  Either<Failure, List<GroupMembership>> _memberships;

  _setMemberships(Either<Failure, List<GroupMembership>> memberships) {
    _memberships = memberships;
  }

  NotifierState get state => _state;

  _setAllUsers(Either<Failure, List<User>> value) {
    _allUsers = value;
  }

  Either<Failure, List<User>> get allUsers => _allUsers;

  List<User> get usersNotInOwnGroup => _usersNotInOwnGroup;

  void setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    _state = NotifierState.initial;
    notifyListeners();
  }

  Future<void> getAllUsers() async {
    setState(NotifierState.loading);
    await Task(() => _userEndpoint.getUser())
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setAllUsers(value))
        .then((value) => _setUsersInOwnGroupLists(value));
    setState(NotifierState.loaded);
  }

  _setUsersNotInOwnGroupList(Either<Failure, List<User>> allUsersResponse) {
    _usersNotInOwnGroup.clear();
    if (allUsersResponse.isRight()) {
      final tmp = allUsersResponse.getOrElse(null);

      for (GroupMembership member in GroupService().ownGroup.memberships) {
        _usersNotInOwnGroup.add(tmp.where((element) => (element.userId != member.member.userId)).first);
      }
    }
  }

  Future<void> getMembersOfOwnGroup() async {
    setState(NotifierState.loading);
    await Task(() => _userEndpoint.getMemberships(AuthService().user.userId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setUsersInOwnGroupLists(value))
        .then((value) => _setUsersNotInOwnGroupList(value))
        .then((value) => _setMemberships(value));
    setState(NotifierState.loaded);
  }

  _setUsersInOwnGroupLists(Either<Failure, List<GroupMembership>> allMemberships) {
    _userInvitedIntoOwnGroup.clear();
    _usersInOwnGroup.clear();
    if (allMemberships.isRight()) {
      final tmp = allMemberships.getOrElse(null);
      for (GroupMembership member in GroupService().ownGroup.memberships) {
        _userInvitedIntoOwnGroup.add(tmp
            .where((element) => (element.member.userId != member.member.userId && element.invitationPending))
            .first
            .member);
        _usersInOwnGroup.add(tmp
            .where((element) => (element.member.userId != member.member.userId && element.invitationPending))
            .first
            .member);
      }
    }
  }

  List<User> get usersInOwnGroup => _usersInOwnGroup;

  List<User> get userInvitedIntoOwnGroup => _userInvitedIntoOwnGroup;

  Either<Failure, List<GroupMembership>> get memberships => _memberships;
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
