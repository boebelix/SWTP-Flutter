import 'package:swtp_app/models/user.dart';

class UserMemberships  {

  bool invitationPending;
  int groupId;


  UserMemberships({this.invitationPending, this.groupId});

  factory UserMemberships.fromJSON(Map<String, dynamic> json)=>UserMemberships(
    invitationPending: json['invitationPending'],
    groupId: json['id']['groupId']
  );

  @override
  String toString() {
    return 'Member{invitationPending: $invitationPending, groupId: $groupId}';
  }
}
