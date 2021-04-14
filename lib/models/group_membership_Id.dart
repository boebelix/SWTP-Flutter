class GroupMembershipId {
  int groupId = 0;
  int userId = 0;

  GroupMembershipId({this.groupId, this.userId});

  factory GroupMembershipId.fromJSON(Map<String, dynamic> json) =>
      GroupMembershipId(groupId: json['groupId'], userId: json['userId']);
}
