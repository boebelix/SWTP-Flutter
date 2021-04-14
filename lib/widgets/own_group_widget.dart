import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/services/group_service.dart';

class OwnGroupWidget extends StatefulWidget {
  @override
  _OwnGroupState createState() => _OwnGroupState();
}

class _OwnGroupState extends State<OwnGroupWidget> {
  GroupService _groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    if (_groupService.ownGroup.groupName.isEmpty)
      // TODO: implement build
      throw UnimplementedError();
  }

  Widget buildOwnGroupNonExistentWidget() {
    return Expanded(key: UniqueKey());
  }

  Widget buildOwnGroupWidget() {
    return FutureBuilder<void>(
      future: _groupService.loadOwnGroup(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        List<Widget> children;
        if (snapshot.connectionState == ConnectionState.done) {
          children = <Widget>[
            _buildMemberText(context),
            _buildListViewAcceptedMembersOfOwnGroup(),
            _buildInvitedText(context),
            _buildListViewOfInvitedMembersOfOwnGroup(),
            IconButton(icon: Icon(Icons.person_add), onPressed: null)
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
        } else if (_groupService.ownGroup.memberships.isEmpty) {
          children = const <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
          ];
        } else {
          children = <Widget>[
            _buildMemberText(context),
            _buildListViewAcceptedMembersOfOwnGroup(),
            _buildInvitedText(context),
            _buildListViewOfInvitedMembersOfOwnGroup(),
            IconButton(icon: Icon(Icons.person_add), onPressed: null)
          ];
        }

        return Center(
          child: Column(
            children: children,
          ),
        );
      },
    );
  }

  Text _buildMemberText(BuildContext context) {
    return Text(Language.of(context).members,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Text _buildInvitedText(BuildContext context) {
    return Text(Language.of(context).invited,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ));
  }

  ListView _buildListViewAcceptedMembersOfOwnGroup() {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _groupService.ownGroup.memberships.length,
        itemBuilder: (context, index) {
          if (!_groupService.ownGroup.memberships.elementAt(index).invitationPending)
            return _createMemberCard(_groupService.ownGroup.memberships.elementAt(index));
          return null;
        });
  }

  ListView _buildListViewOfInvitedMembersOfOwnGroup() {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _groupService.ownGroup.memberships.length,
        itemBuilder: (context, index) {
          if (_groupService.ownGroup.memberships.elementAt(index).invitationPending)
            return _createMemberCard(_groupService.ownGroup.memberships.elementAt(index));
          return null;
        });
  }

  Card _createMemberCard(GroupMembership membership) {
    return Card(
        key: UniqueKey(),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16),
              child: Text("${membership.member.firstName} ${membership.member.firstName}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  setState(() {
                    _removeUserFromGroup(membership.member.userId);
                  });
                })
          ],
        ));
  }

  Future<void> _removeUserFromGroup(int userId) async {
    await _groupService.kickUserFromOwnGroup(userId);
  }
}
