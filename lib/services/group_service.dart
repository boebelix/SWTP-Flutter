import 'dart:convert';

import 'package:swtp_app/endpoints/groups_endpoint.dart';
import 'package:swtp_app/endpoints/user_endpoint.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/user_memberships.dart';
import 'package:swtp_app/services/auth_service.dart';

class GroupService {
  static final GroupService _instance = GroupService._internal();

  factory GroupService() => _instance;

  GroupService._internal();



  List<UserMemberships> _groups=List<UserMemberships>();
  Group _ownGroup;
  GroupsEndpoint _groupsEndpoint=GroupsEndpoint();

  AuthService authService=AuthService();

  UserEndpoint _userEndpoint=UserEndpoint();

  void loadGroups() async {
    _groups.clear();
    String response=await _userEndpoint.getMemberships(authService.user.userId);
    int i=0;
    for(dynamic e in jsonDecode(response))
      {
        print(i++);
        print(e);
        _groups.add(UserMemberships.fromJSON(e));
      }
    print(_groups);
  }
}
