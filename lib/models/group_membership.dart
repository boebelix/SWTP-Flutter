import 'package:swtp_app/models/group_membership_key.dart';
import 'package:swtp_app/models/member.dart';

class GroupMembership {

  GroupMembershipKey id;
  Member member;
  bool invitationPending;


  GroupMembership({this.id, this.member, this.invitationPending});

  factory GroupMembership.fromJSON(Map<String, dynamic> json)=>GroupMembership(
    id: GroupMembershipKey.fromJSON(json['id']),
    member: Member.fromJSON(json['member']),
    invitationPending: json['invitationPending']
  );


}
