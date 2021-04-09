import 'package:flutter/cupertino.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/user.dart';

class Group {
  @required
  User admin;

  @required
  int groupId;

  @required
  String groupName;

  List<GroupMembership> memberships;

  Group({this.admin, this.groupId, this.groupName, this.memberships});

  factory Group.fromJSON(Map<String, dynamic> json) => Group(
      admin: User.fromJSON(json['admin']),
      groupId: json['groupId'],
      groupName: json['groupName']);

  Map<String, dynamic> toJson() => {
        "admin": admin,
        "groupId": groupId,
        "groupName": groupName,
        //"memberships": memberships.map((i) => i.toJSON()).toList(),
      };
}
