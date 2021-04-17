import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/services/auth_service.dart';

class UserEndpointProvider extends ChangeNotifier {
  static final UserEndpointProvider _instance = UserEndpointProvider._internal();

  factory UserEndpointProvider() => _instance;

  UserEndpointProvider._internal();

  NotifierState _state = NotifierState.initial;

  UserEndpoint _userEndpoint = UserEndpoint();

  Either<Failure, List<User>> _allUsersResponse;
  List<User> _allUsers = [];
  List<User> _usersNotInOwnGroup = [];
  List<User> _usersInOwnGroup = [];
  List<User> _userInvitedIntoOwnGroup = [];
  Either<Failure, List<GroupMembership>> _membershipsResponse;
  List<GroupMembership> _memberships = [];

  _setMemberships(Either<Failure, List<GroupMembership>> memberships) {
    if (memberships.isRight()) _memberships = memberships.getOrElse(() => null);

    _membershipsResponse = memberships;
  }

  NotifierState get state => _state;

  _setAllUsers(Either<Failure, List<User>> value) {
    if (value.isRight()) _allUsers = value.getOrElse(() => null);

    _allUsersResponse = value;
  }

  Either<Failure, List<User>> get allUsersResponse => _allUsersResponse;

  List<User> get allUsers => _allUsers;

  List<User> get usersNotInOwnGroup => _usersNotInOwnGroup;

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
    await Task(() => _userEndpoint.getUser()).attempt().mapLeftToFailure().run().then((value) {
      _setAllUsers(value);
    });

    _setState(NotifierState.loaded);
  }

  Future<void> _setUsersNotInOwnGroupList() async {
    _usersNotInOwnGroup.clear();
    if (_allUsers.isEmpty) await getAllUsers();

    for (GroupMembership membership in _memberships)
      if (_allUsers.where((element) => element.userId != membership.member.userId).isNotEmpty)
        _usersNotInOwnGroup.add(_allUsers.where((element) => element.userId != membership.member.userId).first);
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
    _userInvitedIntoOwnGroup.clear();
    _usersInOwnGroup.clear();
    if (allMemberships.isRight()) {
      final tmp = allMemberships.getOrElse(null);

      if (tmp.where((element) => (element.invitationPending)).isNotEmpty)
        _userInvitedIntoOwnGroup.add(tmp.where((element) => (element.invitationPending)).first.member);

      if (tmp.where((element) => (!element.invitationPending)).isNotEmpty)
        _usersInOwnGroup.add(tmp.where((element) => (!element.invitationPending)).first.member);
    }
  }

  List<User> get usersInOwnGroup => _usersInOwnGroup;

  List<User> get userInvitedIntoOwnGroup => _userInvitedIntoOwnGroup;

  List<GroupMembership> get memberships => _memberships;
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
