import 'package:flutter/cupertino.dart';
import 'package:swtp_app/models/member.dart';
import 'package:swtp_app/models/user.dart';

class Group {
  @required
  int groupId;

  @required
  User admin;

  @required
  String groupName;

  List<Member> memberships;

  Group({this.admin, this.groupId, this.groupName, this.memberships});

  factory Group.fromJSON(Map<String, dynamic> json) => Group(
        admin: json['admin'],
        groupId: json['groupId'],
        groupName: json['groupName'],
        memberships: json['memberships']
            .cast<List>()
            .map((i) => Member.fromJSON(i))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "admin": admin,
        "groupId": groupId,
        "groupName": groupName,
        "memberships": memberships.map((i) => i.toJSON()).toList(),
      };
}
