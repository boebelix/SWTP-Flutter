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



  List<UserMemberships> _memberships=List<UserMemberships>();
  List<Group> _groups =List<Group>();
  Group _ownGroup;
  GroupsEndpoint _groupsEndpoint=GroupsEndpoint();

  AuthService authService=AuthService();

  UserEndpoint _userEndpoint=UserEndpoint();

  void loadGroupMemberships() async {
    _memberships.clear();
    String response=await _userEndpoint.getMemberships(authService.user.userId);
    int i=0;
    for(dynamic e in jsonDecode(response))
      {
        print(i++);
        print(e);
        _memberships.add(UserMemberships.fromJSON(e));
      }
  }
}
