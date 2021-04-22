import 'package:swtp_app/models/group_membership_Id.dart';
import 'package:swtp_app/models/user.dart';

class GroupMembership {
  GroupMembershipId id = GroupMembershipId();
  User member = User();
  bool invitationPending = false;

  GroupMembership({this.id, this.member, this.invitationPending});

  factory GroupMembership.fromJSON(Map<String, dynamic> json) => GroupMembership(
      id: json['id'] == null ? null : GroupMembershipId.fromJSON(json['id']),
      member: json['member'] == null ? null : User.fromJSON(json['member']),
      invitationPending: json['invitationPending']);

  @override
  String toString() {
    return 'GroupMembership{id: $id, member: $member, invitationPending: $invitationPending}';
  }
}
