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
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
      child: FutureBuilder<void>(
        future: _groupService.reloadAll(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          List<Widget> children;
          if (snapshot.connectionState == ConnectionState.done) {
            children = <Widget>[
              buildAcceptedGroupsText(context),
              buildListViewAcceptedGroups(),
              buildGroupInvitationsText(context),
              buildListViewInvitedGroups()
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
            ];
          }
          return Center(
            child: Column(
              children: children,
            ),
          );
        },
      ),
    );
  }

  Text buildGroupInvitationsText(BuildContext context) {
    return Text(Language.of(context).invitations,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Text buildAcceptedGroupsText(BuildContext context) {
    return Text(Language.of(context).groups,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ));
  }

  ListView buildListViewInvitedGroups() {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _groupService.invitetIntoGroups.length,
        itemBuilder: (context, index) => createGroupCard(
            _groupService.invitetIntoGroups.elementAt(index), true));
  }

  ListView buildListViewAcceptedGroups() {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _groupService.acceptedGroups.length,
        itemBuilder: (context, index) => createGroupCard(
            _groupService.acceptedGroups.elementAt(index), false));
  }

  Card createGroupCard(Group group, bool isInvitet) {
    return Card(
        key: UniqueKey(),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          acceptGroupInvitation(group);
                        });
                      }),
                ),
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        denyInvitationOrLeaveGroup(group);
                      });
                    }),
              ],
            )
          ],
        ));
  }

  Future<void> acceptGroupInvitation(Group group) async {
    await _groupService.acceptGroupInvitation(group.groupId);
  }

  Future<void> denyInvitationOrLeaveGroup(Group group) async {
    await _groupService.denyInvitationOrLeaveGroup(group.groupId);
  }
}
