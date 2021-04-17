import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/providers/user_endpoint_provider.dart';
import 'package:swtp_app/screens/invite_user_screen.dart';
import 'package:swtp_app/services/group_service.dart';
import 'package:swtp_app/widgets/user_endpoint_visualisation.dart';

class OwnGroupWidget extends StatefulWidget {
  @override
  _OwnGroupState createState() => _OwnGroupState();
}

class _OwnGroupState extends State<OwnGroupWidget> {
  GroupService _groupService = GroupService();
  final TextEditingController _groupNameTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (_groupService.ownGroup.groupName.isNotEmpty)
      return buildOwnGroupWidget();
    else
      return buildOwnGroupNonExistentWidget();
  }

  Widget buildOwnGroupNonExistentWidget() {
    return Expanded(
        key: UniqueKey(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: Language.of(context).ownGroup,
                ),
                controller: _groupNameTextController,
                validator: _validatorGroupnameIsNotEmpty,
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _createGroupWithName()),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        (Colors.black12),
                      ),
                    ),
                    child: Text(
                      Language.of(context).createGroup,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildOwnGroupWidget() {
    return Stack(
      children: [
        FutureBuilder<void>(
          future: _groupService.loadOwnGroup(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            List<Widget> children;
            if (snapshot.connectionState == ConnectionState.done) {
              children = <Widget>[
                _buildMemberText(context),
                _buildListViewAcceptedMembersOfOwnGroup(),
                _buildInvitedText(context),
                _buildListViewOfInvitedMembersOfOwnGroup(),
                _createInviteUserButton()
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
        UserScreenVisualisation(destinationRouteBySuccess: InviteUserScreen.routeName,),
      ],
    );
  }

  Row _createInviteUserButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(icon: Icon(Icons.person_add), onPressed: _showInvitationScreenAsync(context)),
      ],
    );
  }

  Padding _buildMemberText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(Language.of(context).members,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Padding _buildInvitedText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(Language.of(context).invited,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
    );
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
          return Container(
            height: 0.0,
            width: 0.0,
          );
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
          return Container(
            height: 0.0,
            width: 0.0,
          );
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
              padding: const EdgeInsets.all(16.0),
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

  _showInvitationScreenAsync(context)
  {
    _showInvitationScreen(context);
  }

  Future<void> _showInvitationScreen(BuildContext context)  async {
     await Provider.of<UserEndpointProvider>(context,listen: false).getAllUsers();
     await Provider.of<UserEndpointProvider>(context,listen: false).getAllUsers();
  }

  String _validatorGroupnameIsNotEmpty(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_group_name_NN;
    }

    return null;
  }

  Future<void> _createGroupWithName() async {
    if (_formKey.currentState.validate()) {
      //TODO createGroup in Endpoint erstellen und aufrufen
    }
    _groupNameTextController.clear();
  }
}
