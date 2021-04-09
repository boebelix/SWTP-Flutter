import 'package:swtp_app/models/group_membership_key.dart';
import 'package:swtp_app/models/user.dart';

class GroupMembership {
  GroupMembershipKey id;
  User member;
  bool invitationPending;

  GroupMembership({this.id, this.member, this.invitationPending});

  factory GroupMembership.fromJSON(Map<String, dynamic> json) =>
      GroupMembership(
          id: json['id'] == null
              ? null
              : GroupMembershipKey.fromJSON(json['id']),
          member: json['member'] == null ? null : User.fromJSON(json['member']),
          invitationPending: json['invitationPending']);
}
