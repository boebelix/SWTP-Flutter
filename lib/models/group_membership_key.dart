class GroupMembershipKey
{
  int groupId;
  int userId;

  GroupMembershipKey(this.groupId, this.userId);

  factory GroupMembershipKey.fromJSON(Map<String, dynamic> json)=>GroupMembershipKey(json['groupId'], json['userId']);
}
