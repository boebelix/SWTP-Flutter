import 'package:flutter/cupertino.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/user.dart';

class Group {
  @required
  User admin = User();

  @required
  int groupId = 0;

  @required
  String groupName = "";

  List<GroupMembership> memberships = [];

  Group({this.admin, this.groupId, this.groupName, this.memberships});

  factory Group.fromJSON(Map<String, dynamic> json) => Group(
      admin: User.fromJSON(json['admin']), groupId: json['groupId'], groupName: json['groupName'], memberships: null);

  Map<String, dynamic> toJson() => {
        "admin": admin,
        "groupId": groupId,
        "groupName": groupName,
      };
}
