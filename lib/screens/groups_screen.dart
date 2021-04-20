import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/services/group_service.dart';

class GroupsScreen extends StatefulWidget {
  static const routeName = '/groups';

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  GroupServiceProvider groupServiceProvider;

  @override
  Widget build(BuildContext context) {
    groupServiceProvider=Provider.of<GroupServiceProvider>(context,listen: false);
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
      child: FutureBuilder<void>(
        future: groupServiceProvider.loadAllGroups(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          List<Widget> children;
          if (snapshot.connectionState == ConnectionState.done) {
            children = <Widget>[
              _buildAcceptedGroupsText(context),
              _buildListViewAcceptedGroups(),
              _buildGroupInvitationsText(context),
              _buildListViewInvitedGroups()
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

  Padding _buildGroupInvitationsText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(Language.of(context).invitations,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Padding _buildAcceptedGroupsText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(Language.of(context).groups,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  ListView _buildListViewInvitedGroups() {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: groupServiceProvider.invitedIntoGroups.length,
        itemBuilder: (context, index) => _createGroupCard(groupServiceProvider.invitedIntoGroups.elementAt(index), true));
  }

  ListView _buildListViewAcceptedGroups() {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: groupServiceProvider.acceptedGroups.length,
        itemBuilder: (context, index) => _createGroupCard(groupServiceProvider.acceptedGroups.elementAt(index), false));
  }

  Card _createGroupCard(Group group, bool isInvited) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16),
                  child: Text(group.groupName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Text("${Language.of(context).founder}: ${group.admin.firstName} ${group.admin.firstName}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      )),
                )
              ],
            ),
            Row(
              children: [
                Visibility(
                  key: GlobalKey(),
                  visible: isInvited,
                  child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _acceptGroupInvitation(group);
                        });
                      }),
                ),
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _denyInvitationOrLeaveGroup(group);
                      });
                    }),
              ],
            )
          ],
        ));
  }

  Future<void> _acceptGroupInvitation(Group group) async {
    await groupServiceProvider.acceptGroupInvitation(group.groupId);
  }

  Future<void> _denyInvitationOrLeaveGroup(Group group) async {
    await groupServiceProvider.denyInvitationOrLeaveGroup(group.groupId);
  }
}
