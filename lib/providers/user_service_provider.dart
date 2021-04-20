import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/group_service.dart';

class UserServiceProvider extends ChangeNotifier {
  static final UserServiceProvider _instance = UserServiceProvider._internal();

  factory UserServiceProvider() => _instance;

  UserServiceProvider._internal();

  NotifierState _state = NotifierState.initial;

  UserEndpoint _userEndpoint = UserEndpoint();

  Either<Failure, List<User>> allUsersResponse;
  List<User> allUsers=[];
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

  void _setAllUsers(Either<Failure, List<User>> allUsersResponse,Group ownGroup) {
    if (allUsersResponse.isRight()) {
      allUsers = allUsersResponse.getOrElse(() => null);
      if(ownGroup!=null){
        print(1);

        allUsers.remove(ownGroup.admin);
        print(2);

        usersNotInOwnGroup.addAll(allUsers);
        print(3);

        for(GroupMembership membership in ownGroup.memberships){
          usersInOwnGroup.add(membership.member);
          print(4);
        }
        usersNotInOwnGroup.removeWhere((element) => usersInOwnGroup.contains(element));
        print(5);
      }

    }

    this.allUsersResponse = allUsersResponse;
  }



  Future<void> getAllUsers(Group ownGroup) async {
    _setState(NotifierState.loading);
    await Task(() => _userEndpoint.getUser()).attempt().mapLeftToFailure().run().then((value) {
      _setAllUsers(value,ownGroup);
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
