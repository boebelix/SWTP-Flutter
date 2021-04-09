class GroupMembershipId {
  int groupId;
  int userId;

  GroupMembershipId(this.groupId, this.userId);

  factory GroupMembershipId.fromJSON(Map<String, dynamic> json) =>
      GroupMembershipId(json['groupId'], json['userId']);
}
