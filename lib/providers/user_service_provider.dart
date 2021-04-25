import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/user.dart';

class UserServiceProvider extends ChangeNotifier {
  static final UserServiceProvider _instance = UserServiceProvider._internal();

  factory UserServiceProvider() => _instance;

  UserServiceProvider._internal();

  NotifierState _state = NotifierState.initial;

  UserEndpoint _userEndpoint = UserEndpoint();

  Either<Failure, List<User>> allUsersResponse;
  List<User> allUsers = [];
  List<User> usersNotInOwnGroup = [];
  List<User> usersInOwnGroup = [];
  List<User> userInvitedIntoOwnGroup = [];
  List<User> usersToInvite = [];

  NotifierState get state => _state;

  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    _state = NotifierState.initial;
    notifyListeners();
  }

  // aus der Liste aller zurückgegebenen Nutzer werden hier 3 Listen geformt:
  // 1: alle Nutzer (allUsers)
  // 2: Nutzer in eigener Gruppe (usersInOwnGroup)
  // 3: Nutzer die nicht in der eigenen Gruppe sind (usersNotInOwnGroup)
  void _setAllUsers(Either<Failure, List<User>> allUsersResponse, Group ownGroup) {
    if (allUsersResponse.isRight()) {
      allUsers = allUsersResponse.getOrElse(() => null);
      if (ownGroup != null) {
        allUsers.remove(ownGroup.admin);
        usersNotInOwnGroup.addAll(allUsers);
        for (GroupMembership membership in ownGroup.memberships) {
          usersInOwnGroup.add(membership.member);
        }
        usersNotInOwnGroup.removeWhere((element) => usersInOwnGroup.contains(element));
      }
    }

    this.allUsersResponse = allUsersResponse;
  }

  Future<void> getAllUsers(Group ownGroup) async {
    _setState(NotifierState.loading);

    if (allUsers.isNotEmpty) {
      allUsers.clear();
    }
    if (usersInOwnGroup.isNotEmpty) {
      usersInOwnGroup.clear();
    }
    if (usersNotInOwnGroup.isNotEmpty) {
      usersNotInOwnGroup.clear();
    }

    await Task(() => _userEndpoint.getUsers()).attempt().mapLeftToFailure().run().then((value) {
      _setAllUsers(value, ownGroup);
    });

    _setState(NotifierState.loaded);
  }

  void chooseUser(int index, bool chosen) {
    if (usersNotInOwnGroup.length > index && index >= 0) {
      if (!chosen && usersToInvite.contains(usersNotInOwnGroup.elementAt(index))) {
        usersToInvite.remove(usersNotInOwnGroup.elementAt(index));
      } else if (chosen && !usersToInvite.contains(usersNotInOwnGroup.elementAt(index))) {
        usersToInvite.add(usersNotInOwnGroup.elementAt(index));
      }
    }
  }

  bool isUserChosen(int index) {
    if (usersToInvite.isEmpty) {
      return false;
    }
    return usersToInvite.contains(usersNotInOwnGroup.elementAt(index));
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
