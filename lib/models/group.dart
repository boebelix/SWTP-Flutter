import 'package:flutter/cupertino.dart';
import 'package:swtp_app/models/user_memberships.dart';
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
        admin: User.fromJSON(json['admin']),
        groupId: json['groupId'],
        groupName: json['groupName'],
        memberships: json['memberships']
            .cast<List>()
            .map((i) => User.fromJSON(i))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "admin": admin,
        "groupId": groupId,
        "groupName": groupName,
        "memberships": memberships.map((i) => i.toJSON()).toList(),
      };
}
