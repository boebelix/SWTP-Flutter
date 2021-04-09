import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/models/user_memberships.dart';

class Member{
  User user;
  UserMemberships membership;

  Member({this.user, this.membership});

  factory Member.fromJSON(Map<String, dynamic> json)=>Member(
    user:User.fromJSON(json),
    membership: UserMemberships.fromJSON(json)
  );

}
