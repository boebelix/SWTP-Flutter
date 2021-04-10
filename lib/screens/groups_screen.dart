import 'package:flutter/material.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/services/group_service.dart';

class GroupsScreen extends StatefulWidget {
  static const routeName = '/groups';

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

GroupService _groupService = GroupService();

class _GroupsScreenState extends State<GroupsScreen> {
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
                itemCount: _groupService.acceptedGroups.length,
                itemBuilder: (context, index) => createGroupCard(
                    _groupService.acceptedGroups.elementAt(index), false)),
            Text(Language.of(context).invitations,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            ListView.builder(
                padding: EdgeInsets.all(5),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _groupService.invitetIntoGroups.length,
                itemBuilder: (context, index) => createGroupCard(
                    _groupService.invitetIntoGroups.elementAt(index), true)),
          ]),
    );
  }

  Card createGroupCard(Group group, bool isInvitet) {
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Column(
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
            ),
            Row(
              children: [
                Visibility(
                  key: GlobalKey(),
                  visible: isInvitet,
                  child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _groupService.acceptGroupInvitation(group.groupId);
                        });
                      }),
                ),
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _groupService.denyInvitationOrLeaveGroup(group.groupId);
                      });
                    }),
              ],
            )
          ],
        ));
  }
}
