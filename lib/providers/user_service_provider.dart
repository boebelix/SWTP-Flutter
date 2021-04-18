import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/services/auth_service.dart';

class UserServiceProvider extends ChangeNotifier {
  static final UserServiceProvider _instance = UserServiceProvider._internal();

  factory UserServiceProvider() => _instance;

  UserServiceProvider._internal();

  NotifierState _state = NotifierState.initial;

  UserEndpoint _userEndpoint = UserEndpoint();

  Either<Failure, List<User>> _allUsersResponse;
  List<User> allUsers = [];
  List<User> usersNotInOwnGroup = [];
  List<User> usersInOwnGroup = [];
  List<User> userInvitedIntoOwnGroup = [];
  Either<Failure, List<GroupMembership>> _membershipsResponse;
  List<GroupMembership> _memberships = [];

  void _setMemberships(Either<Failure, List<GroupMembership>> memberships) {
    if (memberships.isRight()) {
      _memberships = memberships.getOrElse(() => null);
    }
    _membershipsResponse = memberships;
  }

  NotifierState get state => _state;

  void _setAllUsers(Either<Failure, List<User>> value) {
    if (value.isRight()) {
      allUsers = value.getOrElse(() => null);
    }
    _allUsersResponse = value;
  }

  Either<Failure, List<User>> get allUsersResponse => _allUsersResponse;

  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    _state = NotifierState.initial;
    notifyListeners();
  }

  Future<void> getAllUsers() async {
    _setState(NotifierState.loading);
    await Task(() => _userEndpoint
        .getUser())
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) {
      _setAllUsers(value);
    });

    _setState(NotifierState.loaded);
  }

  Future<void> _setUsersNotInOwnGroupList() async {
    usersNotInOwnGroup.clear();
    if (allUsers.isEmpty) {
      await getAllUsers();
    }
    for (GroupMembership membership in _memberships) {
      var userNotInGroup = allUsers.where((element) => element.userId != membership.member.userId);

      if (userNotInGroup.isNotEmpty) {
        usersNotInOwnGroup.add(userNotInGroup.first);
      }
    }
  }

  Future<void> getMembersOfOwnGroup() async {
    _setState(NotifierState.loading);
    await Task(() => _userEndpoint.getMemberships(AuthService().user.userId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) async {
      _setUsersInOwnGroupLists(value);
      _setMemberships(value);
      await _setUsersNotInOwnGroupList();
    });

    _setState(NotifierState.loaded);
  }

  _setUsersInOwnGroupLists(Either<Failure, List<GroupMembership>> allMemberships) {
    userInvitedIntoOwnGroup.clear();
    usersInOwnGroup.clear();
    if (allMemberships.isRight()) {
      final tmp = allMemberships.getOrElse(null);

      var invitationPendingUser = tmp.where((element) => (element.invitationPending));

      for (int i = 0; i < invitationPendingUser.length; i++) {
        userInvitedIntoOwnGroup.add((invitationPendingUser).elementAt(i).member);
      }

      var userAlreadyInGroup = tmp.where((element) => (!element.invitationPending));
      for (int i = 0; i < userAlreadyInGroup.length; i++) {
        usersInOwnGroup.add(userAlreadyInGroup.elementAt(i).member);
      }
    }
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