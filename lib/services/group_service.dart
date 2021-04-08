import 'package:swtp_app/models/group.dart';

class GroupService {
  static final GroupService _instance = GroupService._internal();

  factory GroupService() => _instance;

  GroupService._internal();

  List<Group> _groups;
  Group _ownGroup;

  //List<Group> loadGroups() {}
}
