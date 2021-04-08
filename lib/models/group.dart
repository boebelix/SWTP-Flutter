import 'package:flutter/cupertino.dart';
import 'package:swtp_app/models/user.dart';

class Group {
  @required
  int groupId;

  @required
  User admin;

  @required
  String groupName;

  List<User> memberships;

  Group({this.admin, this.groupId, this.groupName, this.memberships});

  factory Group.fromJSON(Map<String, dynamic> json) => Group(
        admin: json['admin'],
        groupId: json['groupId'],
        groupName: json['groupName'],
        memberships: json['memberships']
            .cast<List>()
            .map((e) => User.fromJSON(e))
            .toList(),
      );

  @override
  String toString() {
    String toReturn =
        'Group{ admin : $admin , groupId: $groupId, groupName: $groupName, memberships: $memberships';

    toReturn += '}';
  }

  Map<String, dynamic> toJson() => {
        "admin": admin,
        "groupId": groupId,
        "groupName": groupName,
        "memberships": memberships.map((e) => e.toJSON()).toList(),
      };
}
