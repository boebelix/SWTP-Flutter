import 'package:flutter/material.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/services/group_service.dart';

class GroupsScreen extends StatefulWidget {
  static const routeName = '/groups';

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  GroupService _groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text(Language.of(context).groups,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            ListView.builder(
                padding: EdgeInsets.all(5),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => createGroupCard(
                    _groupService.acceptedGroups.elementAt(index))),
            Text(Language.of(context).invitations,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            ListView.builder(
                padding: EdgeInsets.all(5),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => createGroupCard(
                    _groupService.invitetIntoGroups.elementAt(index))),
          ]),
    );
  }

  Card createGroupCard(Group group) {
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(group.groupName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            Text("${group.admin.firstName} ${group.admin.firstName}",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                ))
          ],
        ));
  }
}
