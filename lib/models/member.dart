import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/user.dart';

class Member {
  User user;
  GroupMembership membership;

  Member({this.user, this.membership});

  factory Member.fromJSON(Map<String, dynamic> json) => Member(
      user: User.fromJSON(json), membership: GroupMembership.fromJSON(json));
}
